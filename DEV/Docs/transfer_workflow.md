# Workflow de transfert (SHAREL)

Ce document décrit la logique utilisée pour créer un host (envoyeur), découvrir une session et télécharger les fichiers sur le client. Il explique aussi les choix techniques et les prérequis.

## Composants principaux

- `ShareEngine` (lib/services/share_engine.dart) :
  - Serveur HTTP embarqué (Dart `HttpServer`) qui expose deux endpoints principaux :
    - `GET /session` : Retourne les métadonnées de la session (sessionId, liste d'items avec index, nom, taille).
    - `GET /file/<index>` : Retourne le flux octet du fichier identifié par `<index>` (streaming).
  - Démarre un `HttpServer.bind(InternetAddress.anyIPv4, 0)` pour être joignable depuis le réseau local.
  - Recherche l'adresse IPv4 locale via `NetworkInterface.list()` et construit l'URI `http://<localIP>:<port>`.
  - Effectue une vérification interne après démarrage : tente une requête locale sur `/session` pour confirmer que le serveur répond (retries rapides). Si l'endpoint n'est pas joignable, le serveur s'arrête et une exception est lancée.

- `TransferViewModel` (lib/viewmodel/transfer_viewmodel.dart) :
  - Contrôle l'état du transfert (hosting, joining, receiving, error).
  - `startHost(selection)` : crée `ShareEngine(selection)`, appelle `start()` et renvoie l'URI locale si ok.
  - `joinAndDownload(baseUrl, saveDir)` : se connecte à `baseUrl/session`, récupère la liste des items, puis télécharge chaque fichier via `GET /file/<index>` en streamant vers le disque (`File.openWrite()`), tout en mettant à jour la progression.

- UI screens :
  - `RoomHostScreen` : lance `startHost` et affiche l'URI (QR / texte) à partager.
  - `JoinRoomScreen` / `QRScanScreen` : permet de saisir ou scanner l'URI du host.
  - `RoomClientScreen` : lit `targetServerProvider`, appelle `joinAndDownload` et affiche progression / statut.

## Workflow (Envoyeur)

1. L'utilisateur depuis l'écran Envoyer sélectionne des fichiers.
2. Il clique sur "Envoyer" → navigation vers la page de préparation (les permissions sont vérifiées avant de créer la room).
3. `TransferViewModel.startHost(selection)` : crée `ShareEngine` et démarre le serveur HTTP sur une interface IPv4 disponible.
4. `ShareEngine` trouve l'IP locale (ex. `192.168.1.42`) et un port aléatoire (ex. `45678`) et expose `http://192.168.1.42:45678`.
5. `ShareEngine` effectue une auto-vérification locale (`GET /session`). Si la vérification échoue, l'opération est arrêtée et l'utilisateur reçoit une erreur.
6. Si ok, l'UI affiche l'URL/QR code. Le client peut se connecter à cette adresse.

Notes :
- Le serveur sert directement les fichiers sélectionnés (streaming) — aucun stockage temporaire global n'est créé.
- Les fichiers sont servis avec `application/octet-stream` et `Content-Length` pour permettre un téléchargement progressif.

## Workflow (Récepteur / Client)

1. Le récepteur ouvre la page pour rejoindre et colle ou scanne l'URI fournie par l'envoyeur.
2. L'app appelle `TransferViewModel.joinAndDownload(baseUrl, saveDir)`.
3. Le client fait `GET baseUrl/session` pour obtenir la liste des items (index, name, size).
4. Pour chaque item, le client appelle `GET baseUrl/file/<index>` et écrit le flux dans un fichier local (`saveDir/<name>`), en mettant à jour la progression.
5. En cas d'erreur réseau / HTTP (non-200), l'opération se termine en erreur et l'UI informe l'utilisateur.

## Permissions & prérequis

- Android : `INTERNET` est requis (déjà déclaré). Pour accès fichiers : gestion runtime via `permission_handler` — demande de permission de stockage (ou `photos`/`media` pour Android 13+). La demande est faite au lancement (option configurable) et la page de préparation affiche l'état des permissions.
- iOS : accès aux photos ou fichiers si nécessaire (permissions séparées).
- Réseau : Les deux appareils doivent être sur le même réseau local (Wi‑Fi) ou être capables d'atteindre l'IP de l'envoyeur (hotspot, tethering). Sur certains réseaux (carrier NAT, VPN), la connectivité peut être limitée.

## Limitations et points à vérifier

- Emulateur Android : l'adresse `127.0.0.1` n'est pas directement accessible depuis un autre appareil — tester sur appareil réel.
- Certaines interfaces peuvent retourner des adresses non routables ; `ShareEngine` essaie de sélectionner la première IPv4 non-loopback. Si nécessaire, forcer une interface ou afficher la liste pour diagnostic.
- Pare-feu OS / réseau : peut bloquer les connexions entrantes.

## Tests recommandés

1. Sur un appareil réel A (envoyeur), sélectionner quelques fichiers (petits) et créer la room.
2. Vérifier que `RoomHostScreen` affiche une URL et qu'aucune exception n'a été levée (le `ShareEngine.start()` effectue un self-check local).
3. Depuis un navigateur sur un autre appareil B du même réseau, ouvrir `http://<IP>:<port>/session` — doit renvoyer JSON.
4. Tester le téléchargement via `http://<IP>:<port>/file/0`.

## Débogage

- Si le navigateur affiche "Not found": vérifier que l'URI est exactement `http://<ip>:<port>`, sans chemin supplémentaire.
- Si l'accès est refusé : vérifier pare-feu / permissions et que l'app n'est pas sur un réseau isolé.
- Logs : `ShareEngine` logge les erreurs en mode debug (assert print). Voir console de l'app.

## Conclusion

Le mécanisme utilise un serveur HTTP intégré pour partager directement les fichiers sélectionnés. J'ai ajouté une auto-vérification côté serveur pour éviter les situations où l'UI afficherait une room alors que le serveur n'est pas joignable. Pour valider complètement en conditions réelles, il faut tester sur appareils physiques (Wi‑Fi ou hotspot).
