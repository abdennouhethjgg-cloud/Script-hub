# Script-hub · EL2B Control Center

Le dépôt contient maintenant une application web statique **EL2B Control Center** : une page d’accueil claire pour consulter le script, télécharger `EL2B_ALL_GEAR.lua` et copier son point d’entrée Raw. La page ne lance aucun code automatiquement et ne collecte aucune donnée.

## Fichiers principaux

| Fichier | Rôle |
| --- | --- |
| `index.html` | Interface Control Center, présentation, installation et avertissement |
| `styles.css` | Design responsive sombre, mobile-first |
| `app.js` | Copie du loadstring et navigation accessible |
| `EL2B_ALL_GEAR.lua` | Script Lua actuellement servi par le dépôt |

## Utilisation

Ouvre `index.html` localement ou sers le dossier avec un serveur statique. Le bouton **Télécharger le .lua** conserve une copie locale ; le bouton **Copier le loadstring** copie le lanceur suivant :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/abdennouhethjgg-cloud/Script-hub/main/EL2B_ALL_GEAR.lua"))()
```

Le script doit être lu et utilisé uniquement dans un environnement autorisé. L’application web ne vérifie pas la compatibilité d’un exécuteur et ne peut pas garantir l’absence de déconnexion dans un jeu Roblox.

## Audit de portée

La page décrit les modules visibles dans le fichier Lua, mais ne prétend pas que le script est « interface-only ». Le fichier actuel contient des modules de menu, loading screen, joueur, ESP, déplacement et autres fonctions de gameplay avancées. Cette distinction est volontaire afin que l’utilisateur puisse vérifier le code avant exécution.

Aucune clé API, aucun token privé, webhook secret ou donnée personnelle ne doit être ajouté au dépôt.
