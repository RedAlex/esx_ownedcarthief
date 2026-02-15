# esx_ownedcarthief

Allows stolen & sold vehicles owned by other players.
Player need to contact a mecano to install one of the 3 alarm system on ther car.
Only mecano can buy alarm system in the pawnshop and install it on a car.

## 🚀 NEW v1.2.0: Auto Vehicle Lock Integration

**Automatic compatibility with 7 vehicle lock resources!**

Simply add ONE of these resources to your server.cfg:
- ✨ `ox_vehiclelock` (Recommended - Modern)
- `esx_carkeys` (Alternative - ESX Native)
- `esx_lockpick` (Alternative - Lockpick System)
- `tsn_carlock` (Alternative - Advanced)
- `vms_carlock` (Alternative - Flexible)
- `bd_carlock` (Alternative - Simple)
- `esx_vehiclelock` (Alternative - Basic)

**The script auto-detects and adapts - no code changes needed!**

📖 **See:** [SYSTEM_AUTO_INTEGRATION.md](SYSTEM_AUTO_INTEGRATION.md)

Items
-Hammer & wire cutter
This tool can unlock a vehicle with a low rate of success but triggers alarm systems all the time.

-Burglary tools (Illegal)
This tool can unlock a vehicle with a normal pass rate and a low chance of triggering the alarm systems.

-Signal jammer (Illegal)
This tool allows a burglar to shut down advanced alarm systems once released into the vehicle

-Interface of alarm system
This tool allows a police officer to shut down advanced alarm systems.

-Basic alarm system
This system starts an audible alarm when an attempt is made to open a door without the key.

-Alarm system connect to the central
This system starts an audible alarm when an attempt is made to open a door without the key.
This system sends the vehicle's position to the police officer if an attempt is made to open a door without the key.

-High tech alarm system with GPS
This system starts an audible alarm when an attempt is made to open a door without the key.
This system sends the vehicle's position to the police officer if an attempt is made to open a door without the key.
This system sends the vehicle's position in REAL-TIME to the policeman in case of starting the engine without the key.


# Installation
1. Download the .Zip from this repository.
2. Extract it with your favorite program.
3. Copy the project to your ressource folder.
4. ~~Don't forget to import the esx_ownedcarthiefEN.sql file to your database.~~ **OBSOLETE - Installation automatique**
5. Configure the language in `config.lua` (Config.Locale = 'en', 'fr', 'br' or 'de')
6. Add "ensure esx_ownedcarthief" in your `server.cfg`
7. The script will automatically create the necessary tables and columns on first start

**Note:** The SQL files are now installed automatically based on the language selected in the config. The system checks if tables/columns exist and creates them with the appropriate labels for your language.


# Required resources
- es_extended
- esx_vehicleshop
- mysql-async (or oxmysql as alternative)

# Optional
- ox_inventory (Auto-detected - items will be registered automatically)

# Created by
- Code - Alex Garcio     https://github.com/RedAlex
- Code - Alain Proviste  https://github.com/EagleOnee
- Translation PT/BR - iKaoticx https://github.com/iKaoticx
- Code based on the resources of https://github.com/ESX-Org

# Documentation
- 📖 [CHANGELOG.md](CHANGELOG.md) - Historique complet des versions et changements
- 🔧 [INSTALLATION.md](INSTALLATION.md) - Guide du système d'installation automatique SQL
- 🎒 [OX_INVENTORY.md](OX_INVENTORY.md) - Guide de compatibilité ox_inventory
___
# esx_ownedcarthief

Permet de volé et de vendre les véhicules posseder par d'autre joueurs.
Le joueur doit contacter un mécano pour installer l’un des 3 systèmes d’alarme sur la voiture.
Seul le mécano peut acheter un système d'alarme dans le prêteur sur gages et l'installer sur une voiture.
## 🚀 NOUVEAU v1.2.0: Intégration Automatique de Verrouillage

**Compatibilité automatique avec 7 ressources de verrouillage!**

Ajoutez simplement UNE de ces ressources à votre server.cfg:
- ✨ `ox_vehiclelock` (Recommandé - Moderne)
- `esx_carkeys` (Alternative - ESX Natif)
- `esx_lockpick` (Alternative - Système de Crochetage)
- `tsn_carlock` (Alternative - Avancé)
- `vms_carlock` (Alternative - Flexible)
- `bd_carlock` (Alternative - Simple)
- `esx_vehiclelock` (Alternative - Basique)

**Le script détecte et s'adapte automatiquement - aucune modification requise!**

📖 **Voir:** [SYSTEM_AUTO_INTEGRATION.md](SYSTEM_AUTO_INTEGRATION.md)
Items
-Marteau & coupe fil
Cette outil peut déverrouiller un véhicule avec un taux de réusite faible mais déclanche les systems d'alarm a tout coup.

-Outils de cambriolage (Illégal)
Cette outil peut déverrouiller un véhicule avec un taux de réusite normal et une faible chance de déclanché les systems d'alarm.

-Brouilleur de Signal (Illégal)
Cette outil permet a un cambrioleur de couper les systems d'alarm avancé une fois déclanché dans le véhicule

-Interface de système d'alarm
Cette outil permet a un policier de couper les systems d'alarm avancé.

-Système d'alarm de base
Ce system démarre une alarme sonore en cas de tentative d'ouverture d'une porte sans la clé.

-Système d'alarm relier a la central
Ce system démarre une alarme sonore en cas de tentative d'ouverture d'une porte sans la clé.
Ce system envoie la position du véhicule au policier en cas de tentative d'ouverture d'une porte sans la clé.

-Système d'alarm high tech avec GPS
Ce system démarre une alarme sonore en cas de tentative d'ouverture d'une porte sans la clé.
Ce system envoie la position du véhicule au policier en cas de tentative d'ouverture d'une porte sans la clé.
Ce system envoie la position du véhicule EN TEMPS RÉEL au policier en cas de de démarrage du moteur sans la clé.


# Installation
1. Téléchargez le .Zip
2. Extractez-le avec votre programme favori.
3. Copiez le projet dans votre dossier ressource.
4. ~~N'oubliez pas d'importer le esx_ownedcarthiefFR.sql a votre base de données.~~ **OBSOLÈTE - Installation automatique**
5. Configurez la langue dans `config.lua` (Config.Locale = 'en', 'fr', 'br' ou 'de')
6. Ajoutez "ensure esx_ownedcarthief" dans votre `server.cfg`
7. Le script créera automatiquement les tables et colonnes nécessaires au premier démarrage

**Note:** Les fichiers SQL sont maintenant installés automatiquement en fonction de la langue sélectionnée dans la config. Le système vérifie si les tables/colonnes existent et les crée avec les labels appropriés pour votre langue.


# Ressources requises
- es_extended
- esx_vehicleshop
- mysql-async (ou oxmysql en alternative)

# Optionnel
- ox_inventory (Auto-détecté - les items seront enregistrés automatiquement)


# Créer par
- Code - Alex Garcio    https://github.com/RedAlex
- Code - Alain Proviste https://github.com/EagleOnee
- Traduction PT/BR - iKaoticx https://github.com/iKaoticx
- Code basé sur les ressource de https://github.com/ESX-Org

# Documentation
- 📖 [CHANGELOG.md](CHANGELOG.md) - Historique complet des versions et changements
- 🔧 [INSTALLATION.md](INSTALLATION.md) - Guide du système d'installation automatique SQL
- 🎒 [OX_INVENTORY.md](OX_INVENTORY.md) - Guide de compatibilité ox_inventory
___
# esx_ownedcarthief

Permite roubar veículo de propiedade de outros jogadores.
O jogador precisa entrar em contato com um mecânico para instalar um dos 3 sistemas de alarme no carro.
Somente o mecânico pode comprar sistema de alarme na casa de penhores e instalar em um carro.

## 🚀 NOVO v1.2.0: Integração Automática de Bloqueio de Veículo

**Compatibilidade automática com 7 recursos de bloqueio!**

Simplesmente adicione UM destes recursos ao seu server.cfg:
- ✨ `ox_vehiclelock` (Recomendado - Moderno)
- `esx_carkeys` (Alternativa - ESX Nativo)
- `esx_lockpick` (Alternativa - Sistema de Arrombamento)
- `tsn_carlock` (Alternativa - Avançado)
- `vms_carlock` (Alternativa - Flexível)
- `bd_carlock` (Alternativa - Simples)
- `esx_vehiclelock` (Alternativa - Básico)

**O script detecta e se adapta automaticamente - nenhuma modificação necessária!**

📖 **Veja:** [SYSTEM_AUTO_INTEGRATION.md](SYSTEM_AUTO_INTEGRATION.md)

Items
-Hammer & wirecutter
Esta ferramenta pode desbloquear um veículo com uma baixa taxa de sucesso, mas e sistemas de alarme o tempo todo.

-Ferramentas de arrombamento (ilegal)
Esta ferramenta pode desbloquear um veículo com uma taxa de sucesso mediana e uma baixa chance de acionar os sistemas de alarme.

- Bloqueador de sinal
Esta ferramenta permite que um ladrão desligue os sistemas de alarme avançados, uma vez ativados no veículo

-Interface do sistema de alarme
Essa ferramenta permite que um policial desligue os sistemas de alarme avançados.

-Sistema de alarme básico
Este sistema inicia um alarme sonoro quando é feita uma tentativa de abrir uma porta sem a chave.

-Sistema de alarme conectar-se à central
Este sistema inicia um alarme sonoro quando é feita uma tentativa de abrir uma porta sem a chave.
Este sistema envia a posição do veículo ao policial se for feita uma tentativa de abrir uma porta sem a chave.

-Sistema de alarme de alta tecnologia com GPS
Este sistema inicia um alarme sonoro quando é feita uma tentativa de abrir uma porta sem a chave.
Este sistema envia a posição do veículo ao policial se for feita uma tentativa de abrir uma porta sem a chave.
Este sistema envia a posição do veículo em TEMPO REAL para o policial em caso o motor ligue sem a chave.


# Instalação
1. Download o arquivo esx_ownedcarthief.zip neste github.
2. Extraia com o seu programa favorito.
3. Copie a pasta esx_ownedcarthief para o seu diretório de resources.
4. Configure o idioma em `config.lua` (Config.Locale = 'en', 'fr', 'br' ou 'de')
5. Adicione "ensure esx_ownedcarthief" no seu server.cfg.
6. O script criará automaticamente as tabelas e colunas necessárias na primeira inicialização.

**Nota:** Os arquivos SQL agora são instalados automaticamente com base no idioma selecionado na config. O sistema verifica se as tabelas/colunas existem e as cria com os rótulos apropriados para seu idioma.

# Recursos requeridos
- es_extended
- esx_vehicleshop
- mysql-async (ou oxmysql como alternativa)

# Opcional
- ox_inventory (Auto-detectado - os itens serão registrados automaticamente)


# Documentação
- 📖 [CHANGELOG.md](CHANGELOG.md) - Histórico completo de versões e mudanças
- 🔧 [INSTALLATION.md](INSTALLATION.md) - Guia do sistema de instalação automática SQL
- 🎒 [OX_INVENTORY.md](OX_INVENTORY.md) - Guia de compatibilidade ox_inventory
# Criado por
- Script - Alex Garcio     https://github.com/RedAlex
- Script - Alain Proviste  https://github.com/EagleOnee
- Trandução PT/BR - iKaoticx https://github.com/iKaoticx
- Código baseado nos recursos de https://github.com/ESX-Org