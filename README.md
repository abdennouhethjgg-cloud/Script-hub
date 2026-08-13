# Script-hub

## EL2B Hub

Le script principal est fourni dans `EL2BCODE_Steal.lua`. La version intégrée affiche le serveur communautaire Discord suivant : **https://discord.gg/T8KrJ9gwQ**.

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

Par défaut, le relais n’envoie pas le nom, l’identifiant Roblox ou une autre donnée personnelle. Ces informations ne sont ajoutées que si `EL2B_RELAY_INCLUDE_PROFILE = true` est activé explicitement :

```lua
getgenv().EL2B_RELAY_ENABLED = true
getgenv().EL2B_RELAY_INCLUDE_PROFILE = true -- optionnel : nom Roblox + temps de jeu
getgenv().EL2B_RELAY_URL = "https://URL-DU-RELAIS"
getgenv().EL2B_RELAY_TOKEN = "VOTRE_TOKEN_RELAIS"
```

Le script envoie seulement `user_started`, `win` ou `lose` vers `POST /api/relay/event`. Si `EL2B_RELAY_INCLUDE_PROFILE = true`, il ajoute le nom d’utilisateur Roblox et le temps écoulé depuis le lancement du script. Cette option est désactivée par défaut. Le webhook Discord reste côté serveur et les messages utilisent exactement 🏆 pour une victoire, ❌ pour une défaite et 🤖 pour un démarrage. Ne publiez jamais le token du relais dans un dépôt public.

## Utilisation

Utilisez ce dépôt uniquement dans le respect des règles du jeu, de la plateforme et des services tiers concernés.

## Référence

[1]: https://discord.gg/T8KrJ9gwQ "Serveur Discord EL2B Hub"

[1] désigne le lien d’invitation fourni pour le serveur Discord EL2B Hub.
