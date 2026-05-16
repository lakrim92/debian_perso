# Debian Garage

Ensemble de scripts pour créer une image ISO Debian 12 Live personnalisée de façon entièrement automatisée.

## Pré-requis

- Machine de build **x86_64** sous Debian/Ubuntu
- Image ISO Debian 12 Live placée dans le même dossier que les scripts
- Droits `sudo`

Les outils nécessaires (`xorriso`, `squashfs-tools`, `systemd-container`, etc.) sont installés automatiquement par le script.

## Utilisation

### Lancement tout-en-un

```bash
chmod +x *.sh
./install_main.sh
```

Le script demande interactivement quel profil installer, puis enchaîne les 3 étapes sans intervention manuelle.

### Profils disponibles

| Profil | Utilisateur créé | Logiciels |
|--------|-----------------|-----------|
| **DevOps** | `bellinuxien` | nginx, git, VSCodium, RustDesk, fail2ban, openssh-server... |
| **Habitant** | `habitant` | LibreOffice, Thunderbird, Zoom, WhatsApp, FreeTube, Teams... |

### Étapes automatisées

```
Étape 1/3 — Préparation    install_in.sh
  └─ Installation des outils (xorriso, squashfs-tools, systemd-container...)
  └─ Extraction de l'ISO dans iso/
  └─ Décompression du filesystem.squashfs

Étape 2/3 — Personnalisation    install_devops.sh | install_habitant.sh
  └─ Exécution dans un container systemd-nspawn (proc/sys/dev/D-Bus inclus)
  └─ Création de l'utilisateur, installation des paquets, configuration

Étape 3/3 — Génération    install_out.sh
  └─ Recompression du filesystem.squashfs (format xz)
  └─ Calcul des checksums md5
  └─ Génération de l'ISO finale : debian-live-12.5.0-custom-amd64.iso
```

## Utilisation des scripts individuellement

Chaque script peut aussi être lancé seul depuis son répertoire :

```bash
./install_in.sh       # Prépare l'environnement (extraction ISO)
./install_out.sh      # Génère l'ISO finale
```

## Personnalisation

Les variables configurables sont en tête de chaque script :

**`install_devops.sh`**
```bash
USER_NAME="bellinuxien"
RUSTDESK_VERSION="1.2.4"
VSCODIUM_VERSION="1.89.1.24130"
```

**`install_habitant.sh`**
```bash
USER_NAME="habitant"
```

**`install_out.sh`**
```bash
ISO_LABEL="Debian Live 12.5.0 amd64"
ISO_OUTPUT="debian-live-12.5.0-custom-amd64.iso"
```

## Docs

### Tuto de création
https://dev.to/otomato_io/how-to-create-custom-debian-based-iso-4g37

### xorriso
https://www.gnu.org/software/xorriso/

### fakeroot
https://docs.sylabs.io/guides/3.7/user-guide/fakeroot.html

### squashfs-tools
https://packages.debian.org/fr/sid/squashfs-tools

### syslinux
https://fr.wikipedia.org/wiki/Syslinux

### isolinux
https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX
