#!/bin/sh

# ////////////// Validation //////////////////
# Vous devez créer un script Bash qui va permettre de mettre en place une installation complète de Vagrant et Virtualbox sur un poste sous linux. Avant de lancer l’installation de ces paquets, vous devrez vérifier, via une ligne de commande, si ceux-là sont déjà installés et auquel cas, afficher un message à l’utilisateur comme quoi ces logiciels sont déjà installés.

# Votre script devra ensuite permettre de créer un Vagrantfile automatiquement avec des inputs client, en demandant de modifier le nom des deux dossiers synchronisés (local [../data] et distant[/vagrant_data]) et en donnant le choix parmis 3 boxes et l’adresse IP.
# Une fois mis en place, vous devrez pouvoir afficher toutes les Vagrant en cours d’utilisation sur le système et pouvoir interagir avec, comme par exemple éteindre une machine en particulier.

# Une fois le tout opérationnel, vous lui demanderez s'il souhaite démarrer sa vagrant.

# Une importance particulière devra être apportée au test et affichages des erreurs et a l’ergonomie du logiciel. Bien évidemment, le fonctionnement du script comptera pour la plus grosse partie.

# Petit bonus : Vous demanderez à l'utilisateur s'il souhaite installer apache2, MySQL et PHP7.0 sur son environnement quand la machine sera connectée en SSH. S'il répond "oui", vous lancerez l'installation de ces 3 paquets. Un gros bonus sera apporté si vous parvenez à installer MySQL avec 0000 comme password par défaut, sans que l'utilisateur n'ait à agir.

# Rendu :
# Ce projet doit être rendu à 17h30 au plus tard.
# Vous devrez fournir un ou des scripts fonctionnels et commentés. Un guide utilisateur devra permettre d’utiliser l’application sans connaissance préalable. La validation se fera sur le fonctionnement du script, la qualité de la documentation fournie et la réutilisation des notions étudiées en formation. Le script devra être fourni via GIT et envoyé par mail.

# Adresse mail : a.corrot@it-akademy.fr
# Nom du mail : LINUX1 + Votre nom et prénom
# Contenu : Un lien vers votre repo Git.

echo -e "\e[42mBienvenue dans le programme de mise en place de votre virtualisation"
echo -e "Vérification de la présence de Vagrant et Virtualbox sur votre système...\e[0m"

    dpkg -s vagrant virtualbox &> /dev/null  

    if [ $? -ne 0 ]

        then
            echo "Vagrant et Virtualbox vont être installés"  
            sudo apt update
            sudo apt install vagrant virtualbox -y

        else
            echo "Votre système est déjà prêt :)"
            echo "Passons à la suite..."
    fi


echo -e "\e[42mCréation et personnalisation de votre Vagrantfile\e[0m"

read -p "Souhaitez-vous paramétrer votre environnement virtuel ? o/n " choice

        case $choice in
            o)  read -p "Entrez le nom du dossier local : " folderName
                read -p "Saisissez le nom de votre dossier distant : " distantFolder
                mkdir virtuPerso
                cd virtuPerso
                echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile

                read -p "Quelle distribution souhaitez-vous utiliser ?
                        1) Ubuntu/xenial64 - Tapez 1
                        2) Ubuntu/trusty64 - Tapez 2
                        3) ubuntu/precise64 - Tapez 3 " box
                        case $box in
                            1) echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
                               echo "La box ubuntu/xenial64 a bien été configurée"
                               ;;
                            2) echo "config.vm.box = "\"ubuntu/trusty64"\"" >> Vagrantfile
                               echo "La box ubuntu/trusty64 a bien été configurée"
                               ;;
                            3) echo "config.vm.box = "\"ubuntu/precise64"\"" >> Vagrantfile
                               echo "La box ubuntu/precise64 a bien été configurée"
                               ;;
                            *) echo "À défaut de saisie correcte, nous vous avons attribué la box ubuntu/xenial64"
                               echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
                               ;;
                        esac

                read -p "Maintenant, je vous invite à personnaliser votre adresse IP en saisissant les deux derniers chiffres " -n 2 IP
                echo -e "\e[42mVotre adresse IP sera donc la suivante : 192.168.33.$IP\e[0m"
                echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.$IP"\"" >> Vagrantfile

                echo "config.vm.synced_folder "\"./$folderName"\", "\"/var/www/$distantFolder"\"" >> Vagrantfile
                echo "end" >> Vagrantfile
                mkdir $folderName

                echo "Avant de finaliser l'installation, voici la liste des environnements en cours d'utilisation"
                vagrant global-status | grep "running"
                read -p "souhaitez-vous intéragir avec l'une d'entre elles? o/n " boxInUse
                        case $boxInUse in
                            o) read -p "Souhaitez vous l'éteindre ? " shutdown
                                case $shutdown in
                                    o) read -p "Saisissez l'ID de l'environnement que vous souhaitez éteindre : " boxHalt
                                       vagrant halt $boxHalt
                                       ;;
                                    n) echo "Nous allons vérifier une dernière fois vos paramètres"
                                    ;;
                                esac
                        esac
                echo "Voici le contenu du fichier Vagrantfile dans lequel figurent vos paramètres : "
                cat Vagrantfile
                read -p "Récapitulatif de vos paramètres :
                Un dossier de virtualisation a été créé sous le nom virtuPerso.
                Vous avez choisi le nom de dossier local /$folderName et le nom de dossier distant /var/www/$distantFolder
                Votre adresse IP sera 192.168.33.$IP
                Avant d'exécuter Vagrant, est-ce correct pour vous?
                 o/n " validate
                        case $validate in
                            o) echo "Lancement de Vagrant"
                               vagrant up
                               ;;

                            n) echo "annulation du programme"
                               exit
                               ;;
                        esac
            ;;

            n)  mkdir autoVirtu
                cd autoVirtu
                mkdir data
                echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile

                read -p "Quelle distribution souhaitez-vous utiliser ?
                        1) Ubuntu/xenial64 - Tapez 1
                        2) Ubuntu/trusty64 - Tapez 2
                        3) ubuntu/precise64 - Tapez 3
                         " box
                        case $box in
                            1) echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
                               echo "La box ubuntu/xenial64 a bien été configurée"
                               ;;
                            2) echo "config.vm.box = "\"ubuntu/trusty64"\"" >> Vagrantfile
                               echo "La box ubuntu/trusty64 a bien été configurée"
                               ;;
                            3) echo "config.vm.box = "\"ubuntu/precise64"\"" >> Vagrantfile
                               echo "La box ubuntu/precise64 a bien été configurée"
                               ;;
                            *) echo "À défaut de saisie correcte, nous vous avons attribué la box ubuntu/xenial64"
                               echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
                               ;;
                        esac

                echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
                echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.10"\"" >> Vagrantfile
                echo "end" >> Vagrantfile

                echo "Avant de finaliser l'installation, voici la liste des environnements en cours d'utilisation"
                                vagrant global-status | grep "running"
                                read -p "souhaitez-vous intéragir avec l'une d'entre elles? o/n " boxInUse
                                        case $boxInUse in
                                            o) read -p "Souhaitez vous l'éteindre ? " shutdown
                                                case $shutdown in
                                                    o) read -p "Saisissez l'ID de l'environnement que vous souhaitez éteindre : " boxHalt
                                                    vagrant halt $boxHalt
                                                    ;;
                                                    n) echo "Nous allons vérifier une dernière fois vos paramètres"
                                                    ;;
                                                esac
                                        esac

                read -p "Vérification des paramètres :
                Un dossier de virtualisation a été créé sous le nom autoVirtu.
                À l'intérieur vous retrouverez votre dossier local /data et votre dossier distant sera /var/www/html.
                Votre adresse IP sera 192.168.33.10
                Avant d'exécuter Vagrant, est-ce correct pour vous? o/n " validate
                        case $validate in
                            o) echo "Lancement de Vagrant"
                               vagrant up
                               ;;

                            n) echo "annulation du programme"
                               exit
                               ;;
                        esac
                ;;
        esac
