# UPHF - Generative AI ChatBot

Mise en place d'outils d'intelligence artificielle afin de proposer un chatbot capable d'intéragir avec les usagers et externes de l'établissement.

## Objectifs et besoins

Le chatbot devra être en mesure de réponse à des questions simples et complexes, de manière à pouvoir guider l'utilisateur.
Ses fonctionnalités inclues :

- Répondre aux questions récurrentes des usagers sur l'UPHF
- Fournir des informations et des ressources sur les services proposées par l'UPHF
- Gestions de conversations multi-tour prenant en compte l'état de la conversation et fournissant les réponses appropriées
- Traitement des documents et communication en langue française.

Le service développé autour du chatbot inclut également :

- Possibilité pour les usagers de soumettre des suggestions d'amélioration.
- Possibilité d'apprécier les suggestions proposées par les autres usagers.
- Possibilité de signaler des erreurs ou des réponses non pertinentes.
- Possibilité d'approuver et de remarquer les réponses considérées excellentes

## Segmentation

Afin de répondre à la problématique posée, le projet est divisé en deux parties majeures :
- Segment 1 : Modèle d'intelligence et API
- Segment 2 : Application utilisateur

Le segment 1 correspond au traitement des requêtes et à la génération des réponses.
Tandis que le segment 2 correspond au développement de l'interface utilisateur.

### Modèle d'intelligence et API

*Contraintes : Le projet devant être réalisé en un intervalle de temps limité avec des contraintes matériels non infini
et l'équipe de travail n'ayant pas des connaissances approfondis dans le domaine de l'intelligence artificielle, nous avons choisi pour sa réalisation un modèle pré-entraîné.
Le finetuning nécessitant de grosses configurations matérielle ainsi qu'une grande quantité de temps nous n'en avons pas réalisé.*

Le modèle d'intelligence artificielle utilisé est le modèle `Gemma-1.1-2b-it` proposé par Google.
Ce modèle est entraîné pour de la génération de texte et est capable d'intéragir en français.

Pour la génération de textes basés sur les information de l'UPHF le modèle est alimenté d'un *contexte* sur lequel ce dernier se base pour répondre à la question posée.
Le modèle tourne en local et aucune donnée n'est envoyé sur des serveurs externes.

Il est possible d'intéragir avec le modèle via une REST API afin de poser une question et récupérer une réponse.

**Technologies utilisées :**

```
pytorch
transformers
langchain.text_splitter
langchain.vectorstores
langchain.embeddings
flask
```

**Configuration matérielle :**

```
- CPU  : AMD Ryzen 5 3600 6-Core Processor 3.60GHz
- GPU  : NVIDIA GeForce RTX 2060 Super
- RAM  : 32 Go
- VRAM : 8 Go
```

Plus d'information à l'adresse : [GPT - README.md](https://github.com/Miunn/projet-info-s8/blob/gpt/README.md)

### Application utilisateur

L'application utilisateur est une application Flutter multi-plateforme (Android, iOS, Web).
Cette dernière permet directement d'intéragir avec le modèle d'intelligence via l'API mise en place.

L'application permet de poser des questions au chatbot, de récupérer ses réponses,
de créer de nouvelles conversations et de les administrer,
de soumettre des suggestions ainsi que de voter pour les meilleures suggestions.

**Technologies utilisées :**

```
flutter 3.19.6
Target Android SDK : 34 (Android 14)
Minimal Android SDK : 16 (Android 4.1)
```

Plus d'information à l'adresse : [UI - README.md](https://github.com/Miunn/projet-info-s8/blob/ui/README.md)