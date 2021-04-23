# DEV_Epicture_2019

## Présentation du Projet

Epicture est le premier des trois projets du module « AppDev » d’Epitech. Ce module a pour but d’apprendre aux troisièmes années d’Epitech à développer des applications dans des environnements de développement définis.
L’Epicture est un projet qui a pour but de réaliser une application mobile compatible au moins avec Android et si possible avec IOS, et reprenant les fonctionnalités de la plateforme [Imgur](https://imgur.com/)
Imgur est une plateforme de partage de photos/gif poussés par la communauté utilisant la plateforme.
Afin de mener ce projet à bien, nous devions utiliser et implémenter l’API d’Imgur grâce à leur [documentation](https://apidocs.imgur.com/?version=latest)

## Environnement de développement

Flutter est un framework créé par Google permettant de concevoir des applications multiplateformes pour Android et IOS. La facilité de prise en main ainsi que sa puissance de développement m’ont séduit pour le développement de ce projet.

Android studio est un environnement de développement pour développer des applications Android.
C’est un IDE puissant et facile d’utilisation qui permet concilier ergonomie et environnement de test pour mobile. En effet, grâce à cet IDE, il est possible de développer une feature et de la tester en direct sur son mobile.

## Installation et compilation du projet sur Android

Avant de commencer à essayer de compiler le projet, il vous faudra installer flutter. Pour ce faire il suffit de suivre les étapes du tutoriel présent sur le site officiel de flutter : https://flutter.dev/docs/get-started/install
Une fois l’installation de flutter effectuée avec succès, il vous suffira de vous rendre à la racine du projet via votre interpréteur de commandes.

### Installation via l’apk

Vous pouvez utiliser cette méthode pour installer manuellement l’application sur votre smartphone android.

Quand vous êtes à la racine, il faudra télécharger tous les packages nécessaires au bon fonctionnement de l’application. Pour ce faire, il vous suffit d’écrire et de lancer la commande suivante dans votre interpréteur de commandes :

```flutter --no-color packages get```

A la fin de l’installation, il reste à construire l’APK (programme d’installation de l’application) avec la commande suivante à écrire et lancer dans un interpréteur de commandes :

```flutter build apk –release```

Vous pourrez trouver l’APK dans le dossier : /build/app/outputs/apk/release/app.apk
La dernière étape est de l’installer sur votre smartphone et de lancer l’application nommée « epicture »

### Installation avec un smartphone connecté avec Android Studio

Si vous voulez tester l’application sur votre smartphone qui est branché et que vous avez android-studio, il vous suffit de suivre le tutoriel présent sur le site officiel de flutter : https://flutter.dev/docs/get-started/test-drive

## Documentation

Vous trouverez la documentation complète dans le dossier "documentation".