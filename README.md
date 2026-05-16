# Debian Garage

Génère une ISO Debian 12 **installable** et personnalisée via preseed. Une seule commande, zéro interaction pendant l'installation.

## Pré-requis

- Machine de build **x86_64** sous Debian/Ubuntu
- ISO Debian 12 **netinstall** placée dans le dossier (`debian-12.x.x-amd64-netinst.iso`)
- Droits `sudo`

Téléchargement de l'ISO source : https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/

Les outils nécessaires (`xorriso`, `python3`) sont installés automatiquement.

## Utilisation

```bash
chmod +x *.sh
./install_main.sh
```

Le script demande le profil, puis génère l'ISO sans aucune autre intervention.

## Profils disponibles

| Profil | Utilisateur | Logiciels installés |
|--------|-------------|---------------------|
| **DevOps** | `bellinuxien` | nginx, git, VSCodium, RustDesk, fail2ban, openssh-server, vlc, gimp... |
| **Habitant** | `habitant` | flatpak + LibreOffice, Thunderbird, Zoom, WhatsApp, FreeTube, Teams (au 1er démarrage) |

## Comment ça fonctionne

```
Étape 1/2 — Préparation    install_in.sh
  └─ Extraction de l'ISO netinstall dans iso_work/
  └─ Sauvegarde du MBR

Étape 2/2 — Génération    install_out.sh
  └─ Injection de preseed_<profil>.cfg → répond au wizard debian-installer
  └─ Injection de post_install_<profil>.sh → installe les logiciels custom
  └─ Modification des menus de démarrage (BIOS + UEFI)
  └─ Repackage → debian-12-custom-<profil>-amd64.iso
```

L'ISO générée s'installe automatiquement :
1. Boot sur l'ISO
2. Le wizard debian-installer s'exécute sans interaction
3. À la fin, `post_install.sh` installe les logiciels custom (VSCodium, RustDesk…)
4. Reboot → Debian prêt à l'emploi

## Personnalisation

Toutes les variables sont dans les fichiers preseed et post_install.

**`preseed_devops.cfg` / `preseed_habitant.cfg`**
```
# Changer le mot de passe par défaut (actuellement "debian")
d-i passwd/user-password password debian
d-i passwd/user-password-again password debian

# Changer le hostname
d-i netcfg/get_hostname string debian-devops
```

**`post_install_devops.sh`**
```bash
RUSTDESK_VERSION="1.2.4"
VSCODIUM_VERSION="1.89.1.24130"
```

## Tester dans VirtualBox

```
Type     : Linux / Debian (64-bit)
RAM      : 4096 Mo minimum
Disque   : 20 Go (dynamique)
Réseau   : NAT
Storage  : ajouter l'ISO générée comme lecteur optique
Boot     : Optical en premier
```

L'installation se déroule entièrement en automatique (~15-30 min selon la connexion).

## Structure des fichiers

```
install_main.sh            ← point d'entrée
install_in.sh              ← extraction ISO + sauvegarde MBR
install_out.sh             ← injection preseed + repackage ISO
preseed_devops.cfg         ← répond au wizard debian-installer (profil DevOps)
preseed_habitant.cfg       ← répond au wizard debian-installer (profil Habitant)
post_install_devops.sh     ← installe VSCodium, RustDesk, nginx… (via in-target)
post_install_habitant.sh   ← installe flatpak + service first-boot flatpak
```

## Docs

### Preseed Debian
https://www.debian.org/releases/stable/amd64/apb.html

### xorriso
https://www.gnu.org/software/xorriso/

### isolinux
https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX
