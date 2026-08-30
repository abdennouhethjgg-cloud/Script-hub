# Script-hub

## EL2B Hub

Le script principal **EL2B HUB** est fourni dans `EL2B_HUB.lua`. La version intégrée affiche le serveur communautaire Discord suivant : **https://discord.gg/T8KrJ9gwQ**.

Le lien est affiché dans les deux emplacements de l’interface prévus à cet effet. L’ancien lien Discord a été supprimé du script.

## Vérification

Le fichier Lua a été contrôlé avec un analyseur syntaxique Lua après la mise à jour. Aucune erreur de syntaxe n’a été détectée. La validation syntaxique ne remplace toutefois pas un test dans l’environnement Roblox cible pour les fonctions dépendant d’extensions d’exécution.

## Discord

[Rejoindre le serveur Discord](https://discord.gg/T8KrJ9gwQ)

## Relais Discord sécurisé (opt-in)

Le fichier Lua contient uniquement un client de relais : il ne contient aucun webhook Discord. Pour activer les notifications, suivez ces trois étapes :

1. **Configuration.** Définissez les variables ci-dessous avant d’exécuter le script, avec l’URL du projet relais et le token privé configuré côté serveur.
2. **Test réel.** Lancez le script dans Roblox, puis vérifiez dans le tableau de bord et dans Discord le message 🤖 indiquant qu’une personne utilise le script. Les événements 🏆 et ❌ sont envoyés lorsque le résultat est détecté.
3. **Révocation.** Révoquez tout ancien webhook Discord partagé et ne conservez le webhook actif que dans le gestionnaire de secrets du projet.

Par défaut, le relais n’envoie pas le nom, l’identifiant Roblox ou une autre donnée personnelle. Le site admin décide à distance si ces informations peuvent être ajoutées :

```lua
getgenv().EL2B_RELAY_URL = "https://URL-DU-RELAIS"
getgenv().EL2B_RELAY_TOKEN = "VOTRE_TOKEN_RELAIS"
```

Le script envoie seulement `user_started`, `win` ou `lose` vers `POST /api/relay/event`. Le site relais est l’unique source de vérité : dans sa page admin, le bouton **Discord Notifications** active ou désactive automatiquement les notifications pour tous les scripts, et **Roblox Name + Play Time** contrôle séparément l’ajout du nom et du temps de jeu. Le script ne contient aucun bouton local pour ces fonctions et consulte automatiquement la configuration distante. Si le switch **Roblox Name + Play Time** du website est activé, il ajoute le nom d’utilisateur Roblox et le temps écoulé depuis le lancement du script. Ce switch est désactivé par défaut. Le webhook Discord reste côté serveur et les messages utilisent exactement 🏆 pour une victoire, ❌ pour une défaite et 🤖 pour un démarrage. Ne publiez jamais le token du relais dans un dépôt public.

## Utilisation

Utilisez ce dépôt uniquement dans le respect des règles du jeu, de la plateforme et des services tiers concernés.

## Référence

[1]: https://discord.gg/T8KrJ9gwQ "Serveur Discord EL2B Hub"

[1] désigne le lien d’invitation fourni pour le serveur Discord EL2B Hub.

## ACECodeSniper SpiderSammy

Ce module est distinct du script principal : utilisez `EL2B_HUB.lua` pour EL2B HUB et `TgyEl2b.lua` uniquement pour le quiz SpiderSammy.

Le script complet pour le quiz SpiderSammy est disponible dans `TgyEl2b.lua`. Il contient l’IA locale, l’API OpenAI facultative, la détection des questions et la soumission rapide. Ne placez jamais une clé API dans le dépôt.

Pour charger la version Raw depuis Roblox :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/TgyEl2b.lua"))()
```

L’API externe nécessite un fichier local `openai_api_key.txt` dans l’environnement d’exécution. Le fichier n’est pas inclus dans le dépôt.

## EL2B HUB — version corrigée et renommée

Script EL2B HUB corrigé et vérifié pour exécution par `loadstring` :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_HUB.lua"))()
```

## RemoteEvent & RemoteFunction Lister Pro

`RemoteLister.lua` propose une interface modernisée avec recherche, filtres par type et catégorie, compteur séparé, copie de la liste et fenêtre déplaçable. Son analyse intelligente est **locale et heuristique** : elle classe les noms selon des mots-clés courants et affiche un indicateur de confiance, sans appeler d’API externe.

La liste est actualisée automatiquement lorsque de nouveaux `RemoteEvent` ou `RemoteFunction` apparaissent ou disparaissent. Le script ne contient ni requête HTTP, ni webhook, ni collecte distante. La fonction de copie reste dépendante de la disponibilité de `setclipboard` ou `toclipboard` dans l’environnement d’exécution.

Pour charger la version Raw depuis Roblox :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/RemoteLister.lua"))()
```

Le contrôle statique Luau est passé. Aucun compilateur Luau n’étant disponible dans l’environnement de développement, un test manuel dans Roblox reste nécessaire pour confirmer la compatibilité avec l’exécuteur utilisé. Utilisez ce script uniquement dans des expériences et environnements où vous disposez de l’autorisation nécessaire, conformément aux règles de Roblox et du jeu concerné.
