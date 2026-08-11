# Script-hub

## Annonce d’utilisation Discord

Le script n’envoie aucune annonce d’utilisation par défaut. Le réglage local `usageAnnouncementsEnabled` vaut `false` dans `EL2BCODE_Steal.lua`. Pour activer volontairement une annonce vers le serveur Discord administré par le propriétaire du projet, l’utilisateur doit modifier ce réglage dans son fichier de configuration local.

Lorsque le réglage est activé, le script transmet uniquement le nom technique du script et une empreinte aléatoire propre à l’installation. Cette empreinte sert uniquement à limiter les notifications répétées pendant une minute ; aucune adresse IP, aucun nom de joueur et aucun identifiant de joueur n’est transmis.

L’annonce est reçue par le gestionnaire Script-hub Relay à l’endpoint `/api/script/usage`, puis envoyée côté serveur via le webhook Discord. Les événements peuvent être `success`, `rate_limited` ou `failed`. L’URL du gestionnaire est configurée dans la variable `relayUrl` du script si le projet est déplacé vers un autre domaine.

Le comportement est volontairement limité afin d’éviter les envois répétitifs et de garder l’utilisateur informé du fonctionnement de la notification.
