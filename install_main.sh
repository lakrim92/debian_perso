#!/bin/bash

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ███╗   ███╗ █████╗ ██╗███╗   ██╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ████╗ ████║██╔══██╗██║████╗  ██║
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██╔████╔██║███████║██║██╔██╗ ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
███████║╚██████╗██║  ██║██║██║        ██║       ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝"

# SCRIPT IN
echo "Lancement du script in"
./install_in.sh

if [ $? -eq 0 ]; then
    echo "Le script in s'est bien exécuté"
else
    echo "Il y a eu une erreur lors de l’exécution du script in"
    exit 1
fi

# SCRIPT DEVOPS
echo "Lancement du script devops"
./install_devops.sh

if [ $? -eq 0 ]; then
    echo "Le script devops s'est bien exécuté"
else 
    echo "Il y a eu une erreur lors de l’exécution du script devops"
    exit 1
fi

# SCRIPT OUT
echo "Lancement du script out"
./install_out.sh

if [ $? -eq 0 ]; then
    echo "Le script in s'est bien exécuté"
else 
    echo "Il y a eu une erreur lors de l’exécution du script out"
    exit 1
fi