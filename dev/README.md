Preview Flutter Web (prebuild) — dev/README.md

Objectif

- Générer un build Flutter Web production et prévisualiser rapidement sans hot reload.
- Servir `build/web` via un serveur HTTP léger (Python ou npx serve).

Script

- `dev/preview.sh` : script qui exécute `flutter build web` (par défaut) puis sert `build/web` sur le port 8000.

Usage

- Build + serve (port 8000) :

```bash
./dev/preview.sh
```

- Build + serve sur un autre port :

```bash
./dev/preview.sh --port 8080
```

- Si vous avez déjà construit et voulez seulement servir (éviter le build) :

```bash
./dev/preview.sh --no-build
```

Alternatives

- Variante Node.js si Python absent :

```bash
flutter build web && npx serve build/web -l 8000
```

Accès depuis le navigateur

- Après `./dev/preview.sh` ouvrez : `http://localhost:8000` (ou remplacez 8000 par le port choisi).
- Dans un devcontainer ou cloud, forwardez le port 8000 via l'IDE / plateforme (VS Code : Forward Port), ou utilisez la redirection SSH / ngrok si nécessaire.

Notes

- Ce script est destiné au développement local uniquement.
- Le build Flutter Web prend du temps; utilisez `--no-build` si vous reconstruisez souvent manuellement.
