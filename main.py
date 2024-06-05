import json
import re
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
    trust_remote_code=True,
)

tokenizer.chat_template = "{{ bos_token }}{%for message in messages %}{% if (message['role'] == 'assistant') %}{% set role = 'model' %}{% else %}{% set role = message['role'] %}{% endif %}{{ '<start_of_turn>' + role + ' ' + message['content'] | trim + '<end_of_turn>' }}{% endfor %}{% if add_generation_prompt %}{{'<start_of_turn>model'}}{% endif %}"

model.to(device)


def askGPT(message:list):
    global model
    global tokenizer

    messages = [
        {"role": "system", "content": "Vous êtes le chatbot de l'UPHF, votre rôle est d'assister et de répondre aux questions des utilisateurs."},
        {"role": "assistant", "content": "Ok, je retiens que je suis un chatbot de l'UPHF et que mon rôle est d'assister et de répondre aux questions des utilisateurs."},
    ]

    if not json.loads(message):
        return "Veuillez poser une question..."

    messages = messages + json.loads(message) 

    input_ids = tokenizer.apply_chat_template(messages, tokenize=True, add_generation_prompt=True, return_tensors="pt")

    input_ids = input_ids.to(device)

    gen_tokens = model.generate(
        input_ids,
        max_new_tokens=300, 
        do_sample=True, 
        temperature=0.3,
    )

    gen_text = tokenizer.decode(gen_tokens[0])

    gen_text = gen_text.split("<start_of_turn>")[-1].strip()
    pattern = r"model (.*?)<eos>"
    gen_text = re.search(pattern, gen_text).group(1)

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
    app.run(host='127.0.0.1', port=34197)