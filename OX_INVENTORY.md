# 🎒 Compatibilité ox_inventory

## 📋 Description

Ce script détecte **automatiquement** si vous utilisez ox_inventory et enregistre les items de manière appropriée sans configuration manuelle.

## ✨ Fonctionnalités

### Détection Automatique
- ✅ Détection automatique d'ox_inventory au démarrage
- ✅ Enregistrement automatique des items via l'export ox_inventory
- ✅ Pas de modification nécessaire dans les fichiers ox_inventory
- ✅ Compatible avec ESX standard si ox_inventory n'est pas présent

## 🚀 Installation

### Cas 1: Vous utilisez ox_inventory

Aucune action supplémentaire n'est requise ! Le script :
1. Détecte ox_inventory automatiquement
2. Enregistre les items directement via l'export
3. Affiche dans la console : `ox_inventory détecté! Utilisation d'ox_inventory pour les items.`

### Cas 2: Vous utilisez ESX standard

Le script fonctionne comme avant :
1. Détecte l'absence d'ox_inventory
2. Utilise la table SQL `items` classique
3. Affiche dans la console : `Utilisation du système d'items ESX standard.`

## 📦 Items Enregistrés

Les 7 items suivants sont enregistrés automatiquement :

| Item | Label (EN) | Poids | Description |
|------|-----------|-------|-------------|
| `hammerwirecutter` | Hammer & wire cutter | 1000g | Basic tool for breaking into vehicles |
| `unlockingtool` | Burglary tools | 1000g | Advanced burglary tools (Illegal) |
| `jammer` | Signal jammer | 500g | Signal jammer device (Illegal) |
| `alarminterface` | Alarm interface | 200g | Alarm system interface |
| `alarm1` | Basic alarm | 1500g | Basic alarm system with loudspeaker |
| `alarm2` | Emergency module | 2000g | Advanced alarm with police notification |
| `alarm3` | GPS module | 2500g | GPS tracking alarm system |

## 🔧 Propriétés des Items (ox_inventory)

Tous les items sont enregistrés avec les propriétés suivantes :
```lua
{
    label = "Item Label",     -- Label multilingue selon Config.Locale
    weight = 1000,            -- Poids en grammes
    stack = true,             -- Empilable
    close = true,             -- Ferme l'inventaire après utilisation
    description = "..."       -- Description de l'item
}
```

## 🎨 Images des Items

Pour ajouter des images dans ox_inventory :

1. Créez ou téléchargez les images (format PNG, 100x100px recommandé)
2. Placez-les dans : `ox_inventory/web/images/`
3. Nommez les fichiers exactement comme les items :
   - `hammerwirecutter.png`
   - `unlockingtool.png`
   - `jammer.png`
   - `alarminterface.png`
   - `alarm1.png`
   - `alarm2.png`
   - `alarm3.png`

Les items seront automatiquement associés aux images.

## 📝 Fichier de Référence

Un fichier `items.lua` est fourni avec la ressource contenant la définition complète des items pour référence. Vous pouvez :

### Option A (Recommandé): Laisser le script gérer tout automatiquement
- Aucune action nécessaire
- Le script enregistre les items au démarrage

### Option B: Ajouter manuellement à ox_inventory
Si vous préférez gérer les items manuellement :

1. Ouvrez `ox_inventory/data/items.lua`
2. Copiez le contenu de `esx_ownedcarthief/items.lua`
3. Ajoutez-le dans le return de items.lua

⚠️ **Note**: Cette méthode n'est pas nécessaire si vous laissez le script s'exécuter normalement.

## 📊 Logs de Console

### Avec ox_inventory :
```
[esx_ownedcarthief] Vérification de la base de données...
[esx_ownedcarthief] ox_inventory détecté! Utilisation d'ox_inventory pour les items.
[esx_ownedcarthief] Item 'hammerwirecutter' enregistré dans ox_inventory!
[esx_ownedcarthief] Item 'unlockingtool' enregistré dans ox_inventory!
...
[esx_ownedcarthief] Vérification de la base de données terminée avec succès!
```

### Sans ox_inventory (ESX standard) :
```
[esx_ownedcarthief] Vérification de la base de données...
[esx_ownedcarthief] Utilisation du système d'items ESX standard.
[esx_ownedcarthief] Ajout de l'item 'hammerwirecutter'...
[esx_ownedcarthief] Item 'hammerwirecutter' ajouté avec succès!
...
```

## 🔄 Migration d'ESX vers ox_inventory

Si vous migrez d'ESX standard vers ox_inventory :

1. ✅ Installez ox_inventory
2. ✅ Redémarrez votre serveur
3. ✅ Les items seront automatiquement enregistrés dans ox_inventory
4. ℹ️ Les anciens items dans la table SQL ne seront pas supprimés mais ne seront plus utilisés

## ⚙️ Configuration Technique

### Code de Détection
```lua
local useOxInventory = GetResourceState('ox_inventory') == 'started'
```

Le script vérifie l'état de la ressource ox_inventory :
- `'started'` → Utilise ox_inventory
- Autre état → Utilise ESX standard

### Enregistrement des Items
```lua
exports.ox_inventory:RegisterItem(item_name, {
    label = item_label,
    weight = item_weight,
    stack = true,
    close = true,
    description = item_description
})
```

## ❓ FAQ

**Q: Dois-je modifier quelque chose dans ox_inventory ?**  
R: Non, le script s'occupe de tout automatiquement.

**Q: Les items seront-ils en double si je les ajoute manuellement ?**  
R: Le script utilise pcall pour éviter les erreurs si un item existe déjà. Pas de problème de duplication.

**Q: Les labels sont-ils multilingues avec ox_inventory ?**  
R: Oui, les labels utilisent la langue définie dans `Config.Locale`.

**Q: Que se passe-t-il si j'ajoute ox_inventory après avoir utilisé ESX ?**  
R: Redémarrez simplement le serveur. Le script détectera ox_inventory et utilisera la nouvelle méthode.

**Q: Les poids des items sont-ils personnalisables ?**  
R: Oui, modifiez les valeurs dans la fonction `addItemsToOxInventory` du fichier `server/main.lua`.

**Q: Puis-je désactiver l'auto-détection ?**  
R: Vous pouvez forcer l'utilisation d'ESX en commentant la ligne de détection, mais ce n'est pas recommandé.

## 🛡️ Avantages d'ox_inventory

- 🎯 Interface moderne et intuitive
- 📊 Gestion du poids des items
- 🎨 Support des images personnalisées
- 🔒 Système de slots
- 📦 Meilleure organisation de l'inventaire
- ⚡ Performances optimisées

## 🔧 Dépannage

**Problème**: Les items n'apparaissent pas dans ox_inventory  
**Solution**: 
- Vérifiez que ox_inventory est bien démarré : `ensure ox_inventory` dans server.cfg
- Vérifiez les logs de console pour les erreurs
- Assurez-vous que esx_ownedcarthief démarre APRÈS ox_inventory

**Problème**: Erreur "attempt to call a nil value (field 'RegisterItem')"  
**Solution**: 
- ox_inventory n'est pas correctement installé ou configuré
- Mettez à jour ox_inventory vers la dernière version

**Problème**: Les images ne s'affichent pas  
**Solution**: 
- Vérifiez que les fichiers PNG sont dans `ox_inventory/web/images/`
- Les noms de fichiers doivent correspondre exactement aux noms des items
- Redémarrez ox_inventory après l'ajout des images

## 📞 Support

Pour les problèmes spécifiques à ox_inventory :
- [Documentation ox_inventory](https://overextended.dev/ox_inventory)
- [GitHub ox_inventory](https://github.com/overextended/ox_inventory)

---
**Créé par:** RedAlex & EagleOnee  
**Compatibilité ox_inventory ajoutée:** 2026
