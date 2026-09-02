# Script-hub

## EL2B ALL GEAR — version stable

Le script principal est `EL2B_ALL_GEAR.lua`. `EL2B_HUB.lua` reste conservé comme copie de compatibilité. Cette édition est conçue pour éviter les erreurs et les déconnexions liées aux fonctions d’automatisation dans **Steal a Brainrot**. Elle affiche une interface légère avec le nom **EL2B ALL GEAR**, le nombre de joueurs et la liste des joueurs présents.

Aucune action de gameplay n’est exécutée par cette version. Le script ne contient pas de téléportation, de commande admin, d’appel `RemoteEvent` ou `RemoteFunction`, de lagger, de hook, d’anti-ragdoll, d’aimbot, de quick pickup, de blocage automatique ou d’automatisation de vol.

Pour charger la version Raw depuis Roblox :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_ALL_GEAR.lua"))()
```

## À propos du code 267

Le code 267 est une déconnexion générée par l’expérience Roblox ou par son système de sécurité. La suppression des fonctions de gameplay non nécessaires réduit les causes possibles liées au script, mais elle ne peut pas garantir qu’une expérience Roblox ne déconnectera jamais un joueur. Utilisez uniquement des scripts et des fonctions autorisés par les règles de Roblox et du jeu.

## Autres scripts

`EL2BCODE_Steal.lua` et `vis_hub_corrected.lua` sont des versions historiques non utilisées par la version stable. `TgyEl2b.lua` est un module séparé destiné au quiz SpiderSammy. `RemoteLister.lua` est un outil distinct d’inspection locale. Ils ne sont pas chargés par `EL2B_ALL_GEAR.lua` ni par `EL2B_HUB.lua`.

## Petite GUI Delta

`Petite_GUI_Delta.lua` est une interface locale minimale avec un titre, un statut, un bouton pour masquer/rouvrir la fenêtre et un bouton de fermeture. Elle ne contient ni requête HTTP, ni `loadstring`, ni hook, ni appel `RemoteEvent` ou `RemoteFunction`. Elle peut être collée telle quelle dans Delta ou un exécuteur compatible.

`StealAnEgg_GUI.lua` est la variante visuelle adaptée à **Steal an Egg**. Elle affiche le nom du jeu détecté localement, avec un thème œuf doré, mais n'automatise aucune action de jeu.

## Utilisation responsable

N’utilisez ce dépôt que dans les environnements où vous disposez de l’autorisation nécessaire. Ne publiez aucune clé API, aucun token privé ni aucune donnée personnelle dans le dépôt.
