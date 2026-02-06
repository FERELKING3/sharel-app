# Limitations et Roadmap

**Version:** 1.0  
**Date:** 2026-02-06

## v1.0 - MVP (actuel)

✅ **Implémenté**
- Transfert fichiers HTTP simple (host/client).
- Streaming + chunking.
- QR / URI string.
- Android + iOS (base).

❌ **Volontairement non implémenté**
1. Chiffrement (TLS/AES).
2. Token expiration + authentication.
3. Multi-clients (1 seul simultané).
4. Resume (Range) HTTP 206.
5. Bluetooth / Wi‑Fi Direct.
6. Dossiers/récursif.
7. Permissions finales (trusts).
8. Stats/transferId correlé.

## v1.1 - Robustesse (estimé Q1 2026)

- ✏️ Ajouter `sessionToken` + expiration (30 min).
- ✏️ Accept/Reject + trusted devices (one-time).
- ✏️ Resume HTTP 206 Partial Content.
- ✏️ Hash SHA-256 validation (intégrité fichier).
- ✏️ Atomic write (.part + rename).
- ✏️ Collisions auto-renomme.
- ✏️ Rate limiting (DOS prevention).
- ✏️ Manifest JSON structuré + protocol versioning.
- ✏️ TransferId + logging corrélé.
- ✏️ Tests automatisés (basic).

## v2.0 - Production (estimé Q2/Q3 2026)

- 🔐 TLS local (self-signed).
- 🔐 AES-256-GCM encryption (payload).
- 🔐 Token refresh.
- 📊 Multi-clients + file d'attente.
- 📊 Bluetooth + WiFi Direct (Android).
- 📊 Dossiers récursifs.
- 📊 Permissions granulaires iOS (Local Network).
- 📊 Export logs + rapport transfert.
- 📊 Observabilité complète.
- 📊 UI dark mode, animations.

## Non prévu (hors scope)

- Blockchain / P2P décentralisé.
- Streaming vidéo live.
- Chat intégré.
- Cloud sync (Nextcloud, etc.).
- Backup automatique.

## Contraintes connues

### Android
- Scoped Storage (API 30+): dossiers limités.
- Permissions runtime.
- Hotspot: nécessite gestion IPv6.

### iOS
- Pas de création hotspot par app (API limitée).
- Local Network permission (iOS 14+).
- Sandboxing strict (accès fichier limité).
- Pas de Bluetooth socket (PrivateApi).

### Réseau
- Pas de DNS multicast (mDNS) actuellement.
- QR seulement: scalable pour petit groupe.
- LAN uniquement (pas public internet).

## Migration données

- v1.0 → v1.1: Pas de breaking change (token optionnel).
- v1.1 → v2.0: Possible reset de trusted devices.

## API stability

- v1.0-1.1: `/session` et `/file/<index>` restent stables.
- Protocol: versioning ajouté en v1.1 (manifest).

## Feedback utilisateurs

- TBD après beta testers.
- Intégrer demands + issues GitHub.

---

**Prochaine étape:** Sprint v1.1 initié Q1 2026 avec équipe.
