from flask import Flask
from flask import jsonify
from flask import request
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch

model_id = "google/gemma-1.1-2b-it"
#model_id = "microsoft/Phi-3-mini-128k-instruct"

device = "cuda" if torch.cuda.is_available() else "cpu"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id,
    torch_dtype="auto", 
)

model.to(device)


def askGPT(message:list):
    global model
    global tokenizer

    messages = [
        {"role": "user", "content": "la cafeteria de l'université ouvre a 12:30, batiment 1 se trouve en bas du campus a coté de la cafeteria, batiment 2 se trouve au milieu du campus a 2 minutes du batiment 1 et batiment 3 se trouve au bout du campus a 5 minutes du batiment 2, l'université est ouverte de 8h a 20h et le parking est ouvert 24h/24 7J/7"}
    ]

    if not list(message):
        return "Veuillez poser une question..."
    
    messages + list(message)

    input_ids = tokenizer.apply_chat_template(messages, tokenize=True, add_generation_prompt=True, return_tensors="pt")

    input_ids = input_ids.to(device)

    gen_tokens = model.generate(
        input_ids,
        max_new_tokens=300, 
        do_sample=True, 
        temperature=0.3,
    )

    gen_text = tokenizer.decode(gen_tokens[0])

    return gen_text


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello, World!"

@app.route("/ask", methods=['GET'])
def getAnswer():
    content = request.args.get('prompt', '')
    if not content:
        return jsonify({'role': 'assistant', 'content': 'Veuillez poser une question...'})
    print("Handling request with prompt: " + content)
    answer = askGPT(content)
    return jsonify({'role': 'assistant', 'content': answer})

if __name__ == "__main__":
    print(str(model.get_memory_footprint()*10**-9) + ' GB')
    app.run(host='127.0.0.1', port=8000)