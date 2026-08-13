# Script-hub

## EL2B Hub

Le script principal est fourni dans `EL2BCODE_Steal.lua`. La version intégrée affiche le serveur communautaire Discord suivant : **https://discord.gg/T8KrJ9gwQ**.

Le lien est affiché dans les deux emplacements de l’interface prévus à cet effet. L’ancien lien Discord a été supprimé du script.

## Vérification

Le fichier Lua a été contrôlé avec un analyseur syntaxique Lua après la mise à jour. Aucune erreur de syntaxe n’a été détectée. La validation syntaxique ne remplace toutefois pas un test dans l’environnement Roblox cible pour les fonctions dépendant d’extensions d’exécution.

## Discord

[Rejoindre le serveur Discord](https://discord.gg/T8KrJ9gwQ)

## Relais Discord sécurisé (opt-in)

Le fichier Lua contient uniquement un client de relais : il ne contient aucun webhook Discord. Pour activer les notifications, définissez ces variables avant d’exécuter le script, en remplaçant l’URL par celle du projet relais et le token par la valeur privée configurée côté serveur :

```lua
getgenv().EL2B_RELAY_ENABLED = true
getgenv().EL2B_RELAY_URL = "https://URL-DU-RELAIS"
getgenv().EL2B_RELAY_TOKEN = "VOTRE_TOKEN_RELAIS"
```

Le script envoie seulement `user_started`, `win` ou `lose` vers `POST /api/relay/event`. Le webhook Discord reste côté serveur et les messages utilisent exactement 🏆 pour une victoire, ❌ pour une défaite et 🤖 pour un démarrage. Ne publiez jamais le token du relais dans un dépôt public.

## Utilisation

Utilisez ce dépôt uniquement dans le respect des règles du jeu, de la plateforme et des services tiers concernés.

## Référence

[1]: https://discord.gg/T8KrJ9gwQ "Serveur Discord EL2B Hub"

[1] désigne le lien d’invitation fourni pour le serveur Discord EL2B Hub.
