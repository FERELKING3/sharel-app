# Troubleshooting - Erreurs courantes

**Version:** 1.0  
**Date:** 2026-02-06

## "No found" — serveur ne répond pas

**Symptômes:**
- Navigateur: "http refused" ou "Could not connect".
- App: Toast "Erreur de connexion au serveur".

**Causes possibles:**
1. Host pas encore prêt (délai démarrage serveur).
2. Adresse IP incorrecte (loopback 127.0.0.1 au lieu de 192.168.x.x).
3. Port fermé par pare-feu.
4. Client pas sur même réseau LAN.

**Solutions:**
- ✅ Attendre 2-3 sec avant tenter.
- ✅ Vérifier IP affiché : pas 127.0.0.1.
- ✅ Ping `<IP>` depuis autre device.
- ✅ Disable firewall temporairement.
- ✅ Vérifier `adb logcat` ou Xcode console pour erreurs serveur.

---

## Transfert interrompu mi-chemin

**Symptômes:**
- Progression arrêtée à X%.
- Pas d'erreur affichée.

**Causes possibles:**
1. Wi-Fi déconnexion.
2. Timeout réseau (>30s silence).
3. Out of memory (gros fichier).
4. App backgroundée et killed.

**Solutions:**
- ✅ Implémenter resume (Range HTTP 206) — v1.1.
- ✅ Réduire timeout si réseau lent.
- ✅ Tester sur WiFi stable.
- ✅ Vérifier mémoire `adb shell dumpsys meminfo`.

---

## Permission refusée "Local Network" (iOS)

**Symptômes:**
- Prompt apparaît (ou pas visible).
- App ne peut pas communiquer.

**Solutions:**
- ✅ Aller Paramètres [App Name] > Local Network > **ON**.
- ✅ Code: demander via `NetworkInterface.list()` à la première connexion.

---

## Hash mismatch — fichier corrompu

**Symptômes:**
- Téléchargement 100%, mais validation SHA-256 échoue.

**Causes:**
1. Transmission interrompue.
2. Man-in-the-middle (réseau).
3. Bug chunk manquant.

**Solutions:**
- ✅ Implémenter SHA-256 check (v1.1).
- ✅ Resume et retenter.
- ✅ Tester intégrité avec `sha256sum`.

---

## "Device not trusted" (future)

**Symptômes:**
- Host affiche prompt "Accepter ce device?".
- Client attend.

**Solutions:**
- ✅ Client approve via UI.
- ✅ Host peut mémoriser fingerprint (trusted).
- ✅ Prochain transfert sans ask.

---

## Collisions de noms — overwrite risqué

**Symptômes:**
- Host: fichier.pdf.
- Client: fichier.pdf existe déjà.
- Comportement: silencieusement overwrite (risqué!).

**Solutions:**
- ✅ v1.1: auto-rename `fichier (1).pdf`.
- ✅ UI prompt: "Remplacer ou Renommer?".

---

## Multi-clients / File d'attente (futur)

**Symptômes:**
- Plusieurs clients tentent de se connecter.
- Résultats imprévisibles.

**Solutions (v2.0):**
- ✅ File d'attente max 5 clients.
- ✅ Notification: "Transfert en cours, attente X min".

---

## CPU/Mémoire élevée

**Symptômes:**
- App rame, janky.
- Batterie drainée.

**Solutions:**
- ✅ Throttle progress events (200ms).
- ✅ Chunking optimal (256 KB).
- ✅ Profiler avec DevTools.

---

## Hotspot instable (Android)

**Symptômes:**
- Connexion vers hotspot intermittente.

**Solutions:**
- ✅ Vérifier canal Wi-Fi (2.4 vs 5 GHz).
- ✅ Réduire distance.
- ✅ Minimal interférence.

---

## Scoped Storage errors (Android 11+)

**Symptômes:**
- FileNotFound exception pour dossiers.

**Solutions:**
- ✅ Utiliser file_picker au lieu d'accès direct.
- ✅ Sauver dans `getDownloadsDirectory()`.
- ✅ Vérifier permissions granulaires.

---

## Rapport d'erreur template

Quand user signale bug:

```
Erreur: [description]
Device: [modèle Android/iOS]
OS Version: [version]
App version: [v1.0.0]
Network: [WiFi/Hotspot/LTE]
Fichier size: [MB]
Logs: [export si possible]
```

---

## Support URL

- Issues GitHub: https://github.com/ferelking1/sharel-app/issues
- Discussions: #sharel-support
