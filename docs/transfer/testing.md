# Testing - Checklist complète

**Version:** 1.0  
**Date:** 2026-02-06

## Tests manuels obligatoires (avant chaque release)

### Scénario 1: Transfert simple (fichier unique)

```
- [ ] Appareil A (Host): sélectionner 1 fichier texte (<1 MB)
- [ ] Room créée sans erreur
- [ ] QR/URI affiché
- [ ] Appareil B (Client): scanner ou coller URI
- [ ] Liste items affichée correctement
- [ ] Téléchargement commence
- [ ] Progression visible
- [ ] Fichier reçu sur B, contenu identique (hash OK)
```

### Scénario 2: Transfert multi-fichiers

```
- [ ] Host: 5 fichiers mixtes (images + vidéo + doc) totalisant ~100 MB
- [ ] Client: reçoit tous les fichiers
- [ ] Tailles correctes
- [ ] Aucune corruption (hash match)
```

### Scénario 3: Coupure Wi‑Fi et resume

```
- [ ] Transfert d'un gros fichier (>50 MB)
- [ ] Couper Wi‑Fi après 30% reçus
- [ ] Reconnecter Host et Client
- [ ] Client demande Range: bytes=<offset>-
- [ ] Reprise sans re-télécharger 0-30%
- [ ] Complète avec succès
```

### Scénario 4: Erreur réseau et retry

```
- [ ] Ajouter firewall rule pour bloquer port temporairement
- [ ] Client tente de se connecter → timeout
- [ ] Retry automatique (3x)
- [ ] Débloquer firewall
- [ ] Transfert reprend sur retry 2 ou 3 ✓
```

### Scénario 5: Acceptance (future)

```
- [ ] Host envoie signal "Ready"
- [ ] Client reçoit prompt "Accepter ce transfert?"
- [ ] Client refuse → Host notifié, transfert stopped
- [ ] Host marque device "trusted" si "Accept + Remember"
- [ ] Prochain transfer sans prompt ✓
```

### Scénario 6: Collisions noms

```
- [ ] Host: file.pdf
- [ ] Client reçoit: file.pdf
- [ ] Host: envoie file.pdf à nouveau
- [ ] Client: renomme auto en file (1).pdf
- [ ] Deux fichiers présents ✓
```

### Scénario 7: Permissions refusées

```
- [ ] Retirer permission "Photos" pour Client
- [ ] Tenter transfert vers dossier Photos → erreur UX
- [ ] Prompt: "Accorder permission?"
- [ ] Accorder → transfert continue ✓
```

### Scénario 8: Gros fichiers (>500 MB)

```
- [ ] Host: fichier vidéo 1 GB
- [ ] Streaming sans OOM
- [ ] Mémoire stable
- [ ] Complet après ~5 min (dépend Wi-Fi) ✓
```

### Scénario 9: Hotspot cross-platform

```
- [ ] Android Host, iPhone Client (ou inverse)
- [ ] Hotspot activé
- [ ] Room créée et accessible ✓
```

### Scénario 10: Changement réseau

```
- [ ] Transfert sur Wi-Fi
- [ ] Basculer sur hotspot mid-transfer
- [ ] IP change
- [ ] Host + Client détectent et basculent gracieusement OU erreur claire
```

## Tests automatisés (futur)

- Unit tests: `ShareEngine` endpoints.
- Integration: mock HTTP server + client.
- E2E: sur devices réels (CI via GitHub Actions).

## Outils

- Charles Proxy: inspecter requêtes HTTP.
- Network Link Conditioner: simuler latence/perte.
- Instrument (iOS) / Profiler (Android): mémoire/CPU.

## Critères d'acceptation

- ✅ Aucun crash.
- ✅ Fichiers identiques (hash).
- ✅ Messages d'erreur clairs.
- ✅ <500 MB RAM stable.
- ✅ UI responsive (pas de janks).
