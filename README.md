# UPHF - GPT - Generative AI ChatBot

Ce dépôt contient une implémentation d'un chatbot pour L'UPHF utilisant PyTorch, Transformers et Flask. Le chatbot utilise un modèle de génération de texte pour générer des réponses et utilise une base de données vectoriel pour une optimisation contextuelle.
Ce fichier a pour but d'expliquer de manière technique le développement de l'application, pour de plus amples informations se référer à [General - README.md](https://github.com/Miunn/projet-info-s8/blob/master/README.md)

## Table des Matières
- [Chatbot avec Réponses Contextuelles](#chatbot-avec-réponses-contextuelles)
  - [Table des Matières](#table-des-matières)
  - [Installation](#installation)
  - [Utilisation](#utilisation)
  - [Structure du Projet](#structure-du-projet)
  - [Points de Terminaison](#points-de-terminaison)
  - [Configuration](#configuration)
  - [Remerciements](#remerciements)

## Installation

1. Clonez le dépôt :
    ```bash
    git clone https://github.com/votreutilisateur/chatbot.git
    cd chatbot
    ```

2. Installez les dépendances requises :
    ```bash
    pip install -r requirements.txt
    ```

3. Téléchargez les fichiers de modèle nécessaires :
    ```python
    # Dans votre script Python ou environnement
    import torch
    from transformers import AutoTokenizer, AutoModelForCausalLM

    model_id = "google/gemma-1.1-2b-it"
    tokenizer = AutoTokenizer.from_pretrained(model_id)
    model = AutoModelForCausalLM.from_pretrained(model_id)
    ```

## Utilisation

1. Initialisez le contexte à partir d'un fichier texte :
    ```bash
    python main.py
    ```

2. (Optionnel) Pour limiter l'historique des messages, utilisez l'option `--forget` :
    ```bash
    python main.py --forget=3
    ```

3. Accédez à l'application web :
    Ouvrez un navigateur web et accédez à `http://127.0.0.1:34197`.

## Structure du Projet

```plaintext
├── README.md
├── requirements.txt
├── site_text.txt
├── main.py
├── templates/
│   └── index.html
|── downloads/
|   └── mon_uphf.apk
└── static/
    ├── Monocraft.ttf
    ├── style.css
    └── images/

    
requirements.txt
README.md
```

- `main.py` : Le script principal qui initialise le modèle, charge le contexte et démarre le serveur Flask.
- `templates/index.html` : Le modèle HTML pour l'interface web.
- `static/` : Fichiers statiques pour l'interface web.
- `requirements.txt` : Liste des paquets Python requis.

## Points de Terminaison

- `GET /` : Affiche la page d'accueil.
- `GET /ask` : Accepte un paramètre de requête `prompt` et renvoie la réponse du chatbot.
- `GET /download/<platform>` : Permet de télécharger des fichiers spécifiques en fonction de la plateforme (`ios` ou `android`).

## Configuration

- `forget` : Paramètre configurable pour limiter le nombre de messages passés pris en compte dans le contexte.
- `model_id` : ID du modèle pré-entraîné utilisé pour générer des réponses.
- `device` : Appareil sur lequel exécuter le modèle (`cuda` si disponible, sinon `cpu`).

## Remerciements

- [PyTorch](https://pytorch.org/)
- [Hugging Face Transformers](https://huggingface.co/transformers/)
- [Flask](https://flask.palletsprojects.com/)
- [LangChain](https://github.com/hwchase17/langchain)
- [Chroma](https://github.com/langchain-community/langchain-community)
