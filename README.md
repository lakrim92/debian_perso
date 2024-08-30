# Debian Garage

Ceci est un ensemble de scripts permettant de créer une image ISO Debian 12 Live personnalisée. 
Suivez les instructions ci-dessous pour préparer et personnaliser votre image.

## Pré-requis

Avoir cloné ce repository.

Assurez-vous d'avoir dans le dossier contenant les scripts l'image ISO Debian 12 Live que vous souhaitez personnaliser.

Avec la commande suivante, assurez-vous d'avoir les droits d'exécution des 3 scripts avant de les lancer.

    ```
    chmod +x le nom_du_script
    ```

## I. Étapes de personnalisation

1. Lancez le premier script

    ```
    ./install_in.sh
    ```

2. Lorsque le script a terminé de s'exécuter, suivez ces étapes manuellement : 
    
    - Ajoutez un serveur DNS
        ```
        echo 'nameserver 1.1.1.1' > /etc/resolv.conf
        ```

    - Montez le système de fichiers devpts
        ```
        mount devpts /dev/pts -t devpts
        ```

3. Création et configuration de l'utilisateur :

    - Créez un utilisateur
        ```
        adduser nom_utilisateur
        ```

    - Ajoutez l'utilisateur au groupe `sudo`
        ```
        usermod -aG sudo nom_utilisateur
        ```

    - Changez de session pour l'utilisateur créé
        ```
        su - nom_utilisateur
        ```

## II. OPTIONS 1 (DEVOPS) - Installation des paquets et configurations 

1. Installation des paquets :

    ```
    sudo apt install rsyslog wget curl git net-tools iptables resolvconf rsyslog python3-pip python3-venv zip openssh-server gimp fail2ban vlc nginx -y
    ```

2. Désactivation de services :

    - Désactivez rsyslog
        ```
        sudo systemctl stop rsyslog && sudo systemctl disable rsyslog
        ```

    - Désactivez nginx
        ```
        sudo systemctl stop nginx && sudo systemctl disable nginx
        ```

3. Configuration des sources :

    - Remplacez la liste des sources
        ```
        sudo curl -o /etc/apt/sources.list https://git.legaragenumerique.fr/GARAGENUM/apt-debian-12-bookworm/raw/branch/main/sources.list
        ```
4. Installation de logiciels supplémentaires :

    - Intallation rustdesk
        ```
        curl -LO https://github.com/rustdesk/rustdesk/releases/download/1.2.4/rustdesk-1.2.4-x86_64.deb && sudo dpkg -i rustdesk-1.2.4-x86_64.deb
        ```

    - Installation VSCodium
        ```
        curl -LO https://github.com/VSCodium/vscodium/releases/download/1.89.1.24130/codium_1.89.1.24130_amd64.deb && sudo dpkg -i codium_1.89.1.24130_amd64.deb
        ```

    - Suppression des pack .deb
        ```
        rm codium_1.89.1.24130_amd64.deb rustdesk-1.2.4-x86_64.deb
        ```

5. Nettoyage

    - Avant de quitter l'environnement, il faut nettoyer :
        ```
        sudo apt-get clean
        ```
        ```
        history -c
        ```
        ```
        exit
        ```

## II. OPTION 2 (HABITANT) - Installation des paquets et configurations (Avec Flatpak)

1. Installation de flatpak :

    ```
    sudo apt install flatpak -y
    ```

2. Ajout du dépôt flathub

    ```
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ```

3. Installation des application flatpak

    ```
    flatpak install flathub org.libreoffice.LibreOffice org.mozilla.Thunderbird com.github.IsmaelMartinez.teams_for_linux io.github.flattool.Warehouse io.freetubeapp.FreeTube im.riot.Riot us.zoom.Zoom io.github.mimbrero.WhatsAppDesktop
    ```

    - Applications Installées :

        Whatsapp, Freetube, Thunderbird, Zoom, Warehouse, LibreOffice, Teams

4. Nettoyage

    - Avant de quitter l'environnement, il faut nettoyer :
        ```
        sudo apt-get clean
        ```
        ```
        history -c
        ```
        ```
        exit
        ```

## III. Lancer le 2ème script 

1. Une fois les modifications effectuées, lancez le deuxième script pour créer l'image personnalisée :
    
    - Lancement du script
        ```
        ./install_out.sh
        ```

2. Une fois l'image créée, ne pas oublier de démonter le système de fichiers devpts :

    - Démonter le système de fichier devpts
        ```
        sudo umount devpts /dev/pts -t devpts
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