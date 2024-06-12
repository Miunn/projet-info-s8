# UPHF - UI - Generative AI ChatBot

Cette branche contient les sources permettant de compiler l'application utilisateur.
Ce fichier a pour but d'expliquer de manière technique le développement de l'application,
pour de plus amples informations se référer à [General - README.md](https://github.com/Miunn/projet-info-s8/blob/master/README.md)

## Architecture de l'application

Cette branche contient une application *Flutter*. L'architecture des sources respecte le design suivant :

```
lib/
├─ models/
├─ providers/
├─ screens/
├─ utils/
├─ widgets/
```

`models/`

Contient les représentations des données utilisées par l'application telles que `chat.dart` ou `conversation.dart`.
Ces fichiers sont utilisés dès que des données entrent ou sortent de l'application (lors des communications API par exemple),
à l'aide des fonctions respectives `Chat fromMap(Map<String, dynamic> map)` et `Map<String, Object?> toMap()`.

`providers/`

Propre à Flutter les *providers* permettent de distribuer les données au travers de l'application sans s'encombrer de fonctions callback ou de surplus de paramètres.
Ces derniers permettent également une séparation propre entre Widgets et lecture / envoi de données.
Un widget ayant besoin de données interroge le provider correspondant depuis son contexte afin de récupérer la donnée voulue.
Ce widget est alors (la plupart du temps) marqué comme nécessaire à rendre de nouveau lorsque la donnée change dans le provider.

Ce rechargement des Widgets associés aux données permet de ne pas recharger l'UI entière à chaque mise à jour des données mais uniquement les widgets concernés.
Cela se produit via la fonction `notifyListeners()`.

Pour exemple, le provider de messages contient la liste des messages sauvegardés dans l'application.
Ce dernier les chargent via la fonction `Future<void> loadChats()`, dans laquelle la fontion `notifyListeners()` est appelée en fin d'exécution.
La fonction `loadChats` est également appelée lorsqu'une fonction de mise à jour se termine telle que `addChat`.

`screens/`

Ce dossier contient les deux écrans de l'application *ChatBot* et *Suggestion*.
Ces écrans sont directement rendus dans le Scaffold primaire contenu dans le fichier `main.dart`.

`widgets/`

Les écrans sont alimenté de Widgets personnalisé (telles que la bulle de message), ces derniers sont contenus dans le dossier `widgets/`.
Cette division permet une meilleure lisibilité et pérennité du code.

## Déploiement

Le projet est prêt à être déployé sur Android *en l'état*, pour un déploiement iOS ou Web certainement changements doivent être pris en compte.
Il a été testé et déployé avec succès à l'aide du SDK `flutter 3.19.6`.

Les dépendances du projet sont listés dans le fichiers `pubspec.yaml` et peuvent être installées avec :

```
flutter pub get
```

L'API android cible est l'API 34 (Android 14).