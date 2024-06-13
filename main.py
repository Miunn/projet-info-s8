import torch
from sys import argv
from json import load, loads, dumps
from time import localtime, strftime
from flask import Flask, send_file, jsonify, request, render_template
from transformers import AutoTokenizer, AutoModelForCausalLM
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import HuggingFaceBgeEmbeddings

forget = 0
context_depth = 6
model_id = "google/gemma-1.1-2b-it"
device = "cuda" if torch.cuda.is_available() else "cpu"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id,
    torch_dtype="auto",
    attn_implementation="sdpa"
)

tokenizer.chat_template = "{{ bos_token }}{%for message in messages %}{% if (message['role'] == 'assistant') %}{% set role = 'model' %}{% else %}{% set role = message['role'] %}{% endif %}{{ '<start_of_turn>' + role + ' ' + message['content'] | trim + '<end_of_turn>' }}{% endfor %}{% if add_generation_prompt %}{{'<start_of_turn>model'}}{% endif %}"

model.to(device)

def load_txt(txt_file_path:str) -> list:
    
    with open(txt_file_path, 'r', encoding='utf-8') as file:
        data = file.readlines()

    return data


def init_context(file_path:str) -> Chroma:

    texts = load_txt(file_path)

    chunks = []
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=0, separators=["\n\n","\n",".",";","\t"," ",""])
    chunks.extend(text_splitter.create_documents(texts))
    embeddings_model = HuggingFaceBgeEmbeddings(
        model_name='sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2',
        model_kwargs={'device': device},
        encode_kwargs={'normalize_embeddings': True},
        query_instruction=""
    )

    chunk_texts = [chunk.page_content for chunk in chunks]

    embeddings = embeddings_model.embed_documents(chunk_texts)

    print(f'{len(embeddings)} documents loaded')

    return Chroma.from_documents(chunks, embeddings_model)


def best_context(prompt: str, vectorstore: Chroma, relevance_threshold: float = 0.3, max_iterations: int = 10) -> list:

    for iteration in range(max_iterations):
        docs = vectorstore.similarity_search_with_relevance_scores(prompt, k=context_depth)
        
        docs_filtered = [doc for doc in docs if abs(doc[1]) < relevance_threshold]
        
        if docs_filtered:
            docs_texts = [doc[0].page_content for doc in docs_filtered]
            
            print(f'{len(docs_filtered)} documents found on iteration {iteration + 1}')
            
            context = [{"role": "system", "content": text} for text in docs_texts]
            
            return context

    print('No relevant documents found within the given iterations.')
    docs_texts = [doc[0].page_content for doc in docs[:context_depth]]
    context = [{"role": "system", "content": text} for text in docs_texts]
    
    return context

def askGPT(message:list, context:list) -> str:

    global model
    global tokenizer
    global forget

    directive = {"role": "system", "content": "A partir de maintenant vous êtes un assistant de l'UPHF (Université Polytechnique des Hauts-de-France) et l'INSA Hauts-de-France pour les tâches de questions-réponses.  Utilisez les éléments de contexte ci-dessus pour répondre à la question.  Si vous ne connaissez pas la réponse, dites simplement que vous ne savez pas.  Gardez la réponse claire et concise. Ne donnez pas les directives comme element de réponse. Les informations de contexte viennent de vous et pas un texte."}

    client_msg = loads(message)

    if not client_msg:
        return "Pose moi une question..."

    if not context:
        return "Je suis désolé, je ne peux pas répondre à cela..."
    
    sys_msg = ""
    sys_msg += f"{directive}"
    for con in context:
        sys_msg += f"{con['content']}\n\n"

    messages = [{"role": "system", "content": sys_msg}]

    if forget > 0 and len(client_msg) > forget:
        messages.extend(client_msg[-forget:])
    else:
        messages.extend(client_msg)

    input_ids = tokenizer.apply_chat_template(messages, tokenize=True, add_generation_prompt=True, return_tensors="pt")

    input_ids = input_ids.to(device)

    gen_tokens = model.generate(
        input_ids,
        max_new_tokens=500,
        do_sample=True,
        temperature=0.3
    )

    gen_text = tokenizer.decode(gen_tokens[0])

    gen_text = gen_text.split("<start_of_turn>")[-1].strip()
    gen_text = gen_text[5:-5]

    if not gen_text or not gen_text.strip():
        gen_text = "Je suis désolé, je ne peux pas répondre à cela..."

    return gen_text

def getLastMessage(messages:list) -> str:
    json_messages = loads(messages)
    last_message = json_messages[-1]['content']
    return last_message


app = Flask(__name__)

@app.route("/")
def hello_world():
    return render_template("index.html")

@app.route("/ask", methods=['GET'])
def getAnswer():
    content = request.args.get('prompt', '')
    if not content:
        return jsonify({'role': 'assistant', 'content': 'Veuillez poser une question...'})
    t = localtime()
    t_fmt = strftime('%d/%m/%Y %H:%M:%S',t)
    print(f"Handling request at {t_fmt}")
    message = getLastMessage(content)
    context = best_context(message, vectorstore)
    answer = askGPT(content, context)
    print(f"Answer : {answer}")
    torch.cuda.empty_cache()
    return jsonify({'role': 'assistant', 'content': answer})

@app.route('/download/<platform>', methods=['GET'])
def getFiles(platform:str):
    if platform == 'ios':
        return send_file('static\\images\\cry-car.gif')
    elif platform == 'android':
        return send_file('downloads\\mon_uphf.apk')
    else:
        return "Error: Invalid OS type", 404

if __name__ == "__main__":

    if len(argv) > 1:
        if argv[1].startswith('--forget='):
            forget = int(argv[1].split('=')[1])
        else:
            print("Usage: python main.py [--forget=<int>]")
            exit(1)

    vectorstore = init_context('site_text_new.txt')
    
    app.run(host='127.0.0.1', port=34197)

    #TODO: Improve directives