# 🔧 Système d'Installation Automatique SQL

## 📋 Description

Ce script dispose d'un **système d'installation automatique** de la base de données qui élimine le besoin d'importer manuellement les fichiers SQL.

## ✨ Fonctionnalités

Le système vérifie et crée automatiquement au démarrage :

### Tables et Colonnes
- ✅ Ajout de la colonne `security` dans `owned_vehicles`
- ✅ Ajout de la colonne `alarmactive` dans `owned_vehicles`
- ✅ Création de la table `pawnshop_vehicles`
- ✅ Insertion des items nécessaires dans la table `items`

### Multi-langues Supportées
- 🇫🇷 Français (`fr`)
- 🇬🇧 Anglais (`en`)
- 🇧🇷 Portugais Brésilien (`br`)
- 🇩🇪 Allemand (`de`)

## 🚀 Installation

### Étape 1 : Configuration
Ouvrez `config.lua` et définissez votre langue :
```lua
Config.Locale = 'fr' -- Choisissez: 'fr', 'en', 'br' ou 'de'
```

### Étape 2 : Démarrage
Ajoutez la ressource à votre `server.cfg` :
```
start esx_ownedcarthief
```

### Étape 3 : C'est tout ! 🎉
Le script se charge du reste automatiquement au premier démarrage.

### 🎒 Bonus : Compatibilité ox_inventory
Si vous utilisez **ox_inventory**, le script le détectera automatiquement et enregistrera les items via ox_inventory au lieu de la table SQL. Aucune configuration supplémentaire n'est nécessaire !

👉 Consultez [OX_INVENTORY.md](OX_INVENTORY.md) pour plus de détails.

## 🔍 Comment ça fonctionne ?

Au démarrage du serveur, le script :

1. **Lit la langue configurée** dans `config.lua`
2. **Vérifie l'existence** de chaque colonne/table
3. **Crée uniquement ce qui manque** (pas de duplication)
4. **Utilise les labels appropriés** selon la langue choisie
5. **Affiche des logs** dans la console pour suivre la progression

## 📝 Logs de la Console

Vous verrez des messages comme :
```
[esx_ownedcarthief] Vérification de la base de données...
[esx_ownedcarthief] Ajout de la colonne 'security' à la table owned_vehicles...
[esx_ownedcarthief] Colonne 'security' ajoutée avec succès!
[esx_ownedcarthief] Item 'hammerwirecutter' ajouté avec succès!
[esx_ownedcarthief] Vérification de la base de données terminée!
```

## ⚙️ Structure des Données Créées

### Colonnes ajoutées à `owned_vehicles`
```sql
security INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level'
alarmactive INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state'
```

### Table `pawnshop_vehicles`
```sql
CREATE TABLE pawnshop_vehicles (
    owner varchar(40) DEFAULT NULL,
    security int(1) NOT NULL DEFAULT '0',
    plate varchar(12) NOT NULL,
    vehicle longtext,
    price int(15) NOT NULL,
    expiration int(15) NOT NULL,
    PRIMARY KEY (plate)
)
```

### Items ajoutés (avec labels selon la langue)
- `hammerwirecutter`
- `unlockingtool`
- `jammer`
- `alarminterface`
- `alarm1`
- `alarm2`
- `alarm3`

## 🛡️ Sécurité

- ✅ Vérification avant chaque création (pas de duplication)
- ✅ Pas d'écrasement des données existantes
- ✅ Compatible avec les installations manuelles précédentes
- ✅ Peut être relancé sans problème

## ❓ FAQ

**Q: Que se passe-t-il si j'ai déjà importé les fichiers SQL manuellement ?**  
R: Aucun problème ! Le système détecte ce qui existe déjà et ne crée que ce qui manque.

**Q: Puis-je changer de langue après l'installation ?**  
R: Oui, mais seuls les **nouveaux** items seront créés avec les nouveaux labels. Les items existants garderont leurs anciens labels. Pour mettre à jour tous les labels, vous devrez les modifier manuellement dans la base de données.

**Q: Les fichiers .sql sont-ils encore nécessaires ?**  
R: Non, ils sont conservés pour référence uniquement. Le système les a remplacés.

**Q: Comment vérifier que l'installation a réussi ?**  
R: Consultez les logs de la console ou vérifiez votre base de données pour confirmer la présence des colonnes/tables.

## 🔧 Dépannage

**Problème:** Les tables ne se créent pas  
**Solution:** Vérifiez que :
- MySQL-Async est bien installé et fonctionnel
- Votre utilisateur MySQL a les permissions CREATE et ALTER
- La base de données `essentialmode` existe

**Problème:** Les labels ne sont pas dans la bonne langue  
**Solution:** 
- Vérifiez `Config.Locale` dans config.lua
- Les langues supportées sont : 'fr', 'en', 'br', 'de'

## 📞 Support

Pour toute question ou problème :
- Vérifiez d'abord les logs de la console
- Assurez-vous d'avoir les ressources requises installées
- Consultez le README principal pour plus d'informations

---
**Créé par:** RedAlex & EagleOnee  
**Système d'installation automatique ajouté:** 2026
