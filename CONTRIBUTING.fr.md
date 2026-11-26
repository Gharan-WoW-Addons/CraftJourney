# Contribuer à Craft Journey

*[English version](CONTRIBUTING.md)*

Merci de votre intérêt pour Craft Journey ! Ce guide explique comment signaler un problème, proposer une idée et contribuer au code.

## Comment contribuer

- **Signaler un bug** : ouvrez une issue avec le formulaire *Bug report*. Une traduction fausse ou manquante est aussi un bug.
- **Proposer une fonctionnalité** : ouvrez une issue avec le formulaire *Feature request*, en partant de votre cas d'usage.
- **Traduire** : quand l'addon aura ses fichiers de langue, les traductions se proposeront par pull request.
- **Écrire du code ou de la documentation** : choisissez une issue avec le label `accepted` (voir plus bas) et ouvrez une pull request.

Cherchez d'abord dans les [issues existantes](https://github.com/Gharan-WoW-Addons/CraftJourney/issues) : votre problème ou votre idée y est peut-être déjà.

Les formulaires d'issue sont en anglais, mais vous pouvez les remplir en français.

## Cycle de vie d'une issue

| Étape | Statut | Comment |
| --- | --- | --- |
| Nouvelle issue | Backlog | Label `needs-triage` posé par les formulaires |
| Affinage | Backlog | Les mainteneurs précisent le périmètre et les critères d'acceptation |
| Acceptée | Todo | Label `accepted` : l'issue est prête à être réalisée |
| Démarrée | In progress | Quelqu'un est assigné : il travaille dessus |
| Pull request | In review | Une pull request liée à l'issue est prête pour la relecture |
| Fusionnée | Done | La pull request ferme l'issue |

Le statut change automatiquement. **Attendez le label `accepted` avant de coder**, et laissez un commentaire sur l'issue pour qu'un mainteneur vous l'assigne. Ainsi, personne ne travaille sur quelque chose qui ne sera pas fusionné, et deux personnes ne travaillent jamais sur la même issue.

## Workflow Git

Le dépôt suit un gitflow allégé :

- `develop` est la branche par défaut : elle rassemble la prochaine version.
- `main` contient les versions publiées, un tag `vX.Y.Z` par version.

Pour contribuer :

1. Forkez le dépôt (les mainteneurs travaillent sur des branches du dépôt lui-même).
2. Créez une branche depuis `develop`, nommée d'après l'issue : `feature/<numéro d'issue>-<sujet>`, par exemple `feature/12-reagent-chain`.
3. Commitez comme vous voulez sur votre branche : les commits sont regroupés (squash) à la fusion.
4. Ouvrez une pull request vers `develop`, remplissez le modèle et ajoutez `Closes #<numéro d'issue>` à sa description.
5. Un code owner la relit. Une fois approuvée, la pull request est fusionnée en squash.

### Titre de la pull request

Le titre de la pull request devient le commit sur `develop` : il suit donc [Conventional Commits](https://www.conventionalcommits.org/fr/) : `<type>: <résumé>`, en anglais, à l'impératif, en minuscules.

| Type | À utiliser pour |
| --- | --- |
| `feat` | Une nouvelle fonctionnalité pour le joueur |
| `fix` | Une correction de bug |
| `docs` | De la documentation uniquement |
| `test` | Ajouter ou corriger des tests |
| `refactor` | Un changement de code qui ne corrige pas de bug et n'ajoute pas de fonctionnalité |
| `perf` | Une amélioration de performance |
| `build` | Configuration du dépôt, outillage, packaging |
| `ci` | Workflows d'intégration continue |

Exemples : `feat: track orders across characters`, `fix: wrong wool count for bags`.

## Intégration continue

Chaque pull request vers `develop` ou `main` lance ces vérifications. Elles sont toutes **obligatoires** : une seule en rouge bloque la fusion.

| Vérification | Ce qu'elle contrôle |
| --- | --- |
| `lint` | Luacheck et `stylua --check` : aucun avertissement, code formaté |
| `test` | Tests busted, avec le résumé de couverture dans le résumé du job |
| `pr-title` | Le titre suit Conventional Commits (voir plus haut) |
| `Analyze (actions)` | Analyse de sécurité CodeQL des workflows GitHub Actions |

Lancez `luacheck .`, `stylua --check .` et `busted` en local avant de pousser : la CI installe les mêmes outils, aux mêmes versions (figées dans `.github/workflows/ci.yml` : une version change aux deux endroits).

La branche doit aussi être **à jour** avec sa branche cible : ce que la CI a testé est exactement ce qui est fusionné. Si `develop` a avancé depuis l'ouverture de votre pull request, cliquez sur **Update branch** dans la pull request (ou fusionnez `develop` dans votre branche et poussez).

Après une fusion dans `develop`, seul CodeQL tourne à nouveau, pour garder l'onglet *Security* à jour. Dependabot ouvre des pull requests pour mettre à jour les GitHub Actions des workflows.

## Outils de développement

Tout ce qui est propre au projet vit dans le projet : Lua, ses paquets et le formateur sont installés dans `lua_modules/` (ignoré par Git), rien n'est installé en global à part `pipx`.

| Outil | Version | Rôle |
| --- | --- | --- |
| [Lua](https://www.lua.org/) | 5.1.5 | La version embarquée dans le jeu |
| [LuaRocks](https://luarocks.org/) | 3.13.0 | Gestionnaire de paquets Lua |
| [busted](https://lunarmodules.github.io/busted/) | 2.3.0 | Tests unitaires |
| [LuaCov](https://lunarmodules.github.io/luacov/) | 0.17.0 | Couverture des tests |
| [Luacheck](https://luacheck.readthedocs.io/) | 1.2.0 | Analyse statique (variables non définies ou inutilisées, globales…) |
| [StyLua](https://github.com/JohnnyMorganz/StyLua) | 2.6.0 | Formateur de code |

### Installation

Prérequis : Git, Python 3, un compilateur C (sur macOS : `xcode-select --install`) et [pipx](https://pipx.pypa.io/) (sur macOS : `brew install pipx`).

Depuis la racine du dépôt :

```bash
# Lua 5.1 (avec ses correctifs officiels) et LuaRocks, isolés dans lua_modules/
pipx run hererocks==0.25.1 lua_modules -l5.1 --patch -r@v3.13.0

# Activer l'environnement (comme un venv Python), puis installer les outils
source lua_modules/bin/activate
luarocks install busted 2.3.0-1
luarocks install luacov 0.17.0-1
luarocks install luacheck 1.2.0-1

# StyLua : binaire de la release GitHub, dans le même dossier
# (macOS Intel : stylua-macos-x86_64.zip, Linux : stylua-linux-x86_64.zip)
curl -L -o /tmp/stylua.zip https://github.com/JohnnyMorganz/StyLua/releases/download/v2.6.0/stylua-macos-aarch64.zip
unzip -o /tmp/stylua.zip -d lua_modules/bin && chmod +x lua_modules/bin/stylua
```

Sous Windows, [hererocks](https://github.com/luarocks/hererocks) a besoin de MinGW ou de Visual Studio, l'environnement s'active avec `lua_modules\bin\activate.bat` (ou `activate.ps1`), et StyLua vient de `stylua-windows-x86_64.zip`.

[hererocks](https://github.com/luarocks/hererocks) est lancé avec `pipx run` : il n'est pas installé, il ne sert qu'à créer `lua_modules/`.

### Au quotidien

```bash
source lua_modules/bin/activate   # une fois par terminal ; on en sort avec deactivate-lua

busted                            # tests, avec les données de couverture
luacov                            # rapport de couverture dans luacov.report.out
luacheck .                        # analyse statique
stylua .                          # formate le code (stylua --check . vérifie seulement)
```

Fichiers de configuration : `.busted`, `.luacov`, `.luacheckrc`, `stylua.toml`.

### Tests

Les tests sont dans `spec/` et se terminent par `_spec.lua`. Ils couvrent le domaine, en Lua pur. Pour charger un fichier de l'addon comme le fait le jeu (avec `local addonName, ns = ...`), utilisez le helper de test :

```lua
local Addon = require("spec.support.addon")

local ns = Addon.load("Domain/Order.lua")
```

### VS Code

Ouvrez le dossier du dépôt : VS Code propose les extensions recommandées (`.vscode/extensions.json`) :

- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) (LuaLS) : complétion et erreurs dans l'éditeur.
- [WoW API](https://marketplace.visualstudio.com/items?itemName=ketho.wow-api) : documentation de l'API du jeu pour LuaLS.
- [StyLua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) : formate les fichiers Lua à l'enregistrement, avec le StyLua de `lua_modules/`.

Les réglages partagés sont dans `.vscode/settings.json`. Ils demandent à l'extension WoW API d'écrire ses réglages LuaLS (Lua 5.1, annotations de l'API du jeu) dans vos réglages **utilisateur**, pas dans le dépôt : ils s'appliquent alors à tous vos addons WoW, et `.vscode/settings.json` reste propre quelle que soit la façon d'ouvrir le projet.

### En jeu

Liez le dépôt dans le dossier `Interface/AddOns/` du jeu, pour que le jeu charge votre copie de travail :

```bash
# macOS (adaptez le chemin à votre installation)
ln -s "$PWD" "/Applications/World of Warcraft/_forever_/Interface/AddOns/CraftJourney"
```

```bat
:: Windows, dans une invite de commandes administrateur (adaptez les chemins)
mklink /D "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftJourney" "C:\chemin\vers\CraftJourney"
```

Puis en jeu :

- `/reload` recharge l'interface après une modification.
- `/console scriptErrors 1` affiche les erreurs Lua.

## Sécurité

Vous avez trouvé une faille ? N'ouvrez **pas** d'issue publique : signalez-la en privé, comme expliqué dans [SECURITY.md](SECURITY.md) ([version française](SECURITY.fr.md)).

## Software craftsmanship

Craft Journey est un petit addon, écrit avec soin. Nous préférons un code facile à lire, à tester et à faire évoluer à un code astucieux.

### Principes

- **Clean code** : des noms clairs tirés du domaine, des fonctions courtes qui font une seule chose, pas de code mort, pas de code commenté. Les commentaires expliquent le *pourquoi*, le code explique le *quoi*.
- **Les tests d'abord sur le domaine** : les règles métier sont écrites en Lua pur et couvertes par des tests, idéalement écrits avant le code.
- **Règle du boy-scout** : laissez le code un peu plus propre que vous ne l'avez trouvé, dans le périmètre de votre pull request.
- **Pas de sur-ingénierie** : construisez ce dont l'issue a besoin, rien de plus. Trois lignes semblables valent mieux qu'une abstraction prématurée.

### Langage ubiquitaire

Le code parle la langue des joueurs (Domain-Driven Design). Utilisez ces mots, en anglais, partout : code, tests, issues et pull requests.

| Terme | Sens |
| --- | --- |
| **Recipe** | Ce qu'un métier peut fabriquer, avec ses composants |
| **Reagent** | Un objet consommé par une recette : tissu, rouleau, fil… |
| **Order** | Une recette et une quantité que le joueur veut fabriquer |
| **Stock** | Les objets qu'un personnage possède, dans ses sacs et sa banque |
| **Track** | Un personnage suit une commande dans sa fenêtre de suivi |

### Architecture en couches

L'addon est découpé en couches. Les dépendances pointent uniquement vers l'intérieur, vers le domaine.

| Couche | Rôle | Dépend de l'API WoW | Testée par |
| --- | --- | --- | --- |
| **Domaine** | Règles métier : commandes, recettes, chaîne de composants, totaux | Non, Lua pur | Tests unitaires |
| **Contrôleurs** | Gèrent les évènements du jeu et les actions du joueur, appellent le domaine, rafraîchissent les vues (le *C* de MVC) | Oui | En jeu |
| **Adaptateurs** | Lisent le jeu : sacs, banque, métiers, variables sauvegardées | Oui | En jeu |
| **Vues** | Fenêtres affichées au joueur (le *V* de MVC) | Oui | En jeu |

Le domaine n'appelle jamais l'API WoW. Il reçoit ce dont il a besoin des adaptateurs, ce qui le garde testable hors du jeu.

### SOLID en Lua

Lua n'a ni classes ni interfaces, mais les principes s'appliquent quand même :

- **Responsabilité unique** : un module, une seule raison de changer. Calculer la chaîne de composants et dessiner la fenêtre de suivi sont deux modules.
- **Ouvert/fermé** : ajoutez un comportement avec de nouveaux modules ou de nouvelles tables, pas en empilant des `if` dans les modules existants.
- **Substitution de Liskov** : un objet qui en remplace un autre (un faux stock dans les tests, par exemple) respecte le même contrat : mêmes fonctions, mêmes valeurs de retour.
- **Ségrégation des interfaces** : passez une fonction ou une petite table avec seulement ce qui est nécessaire, pas l'addon entier.
- **Inversion des dépendances** : le domaine dépend de contrats, les adaptateurs les fournissent. Injectez les dépendances, ne les récupérez jamais dans une variable globale.

Exemple : le domaine reçoit le stock par son constructeur, les tests peuvent donc injecter un faux.

```lua
-- Domain/Order.lua (pure Lua)
local _, ns = ...

local Order = {}
Order.__index = Order

--- Creates an order.
-- @param recipe   the recipe to craft
-- @param quantity how many times to craft it
-- @param stock    any object with a count(itemId) function
function Order.new(recipe, quantity, stock)
  return setmetatable({ recipe = recipe, quantity = quantity, stock = stock }, Order)
end

--- Returns how many of a reagent are still missing.
function Order:missing(reagent)
  local needed = reagent.count * self.quantity
  return math.max(needed - self.stock:count(reagent.itemId), 0)
end

ns.Order = Order
```

```lua
-- In a test: a fake stock, no game needed
local wool = { itemId = 2592, count = 3 }
local stock = { count = function() return 5 end }
local order = Order.new({ reagents = { wool } }, 4, stock)
assert(order:missing(wool) == 7) -- 4 × 3 needed, 5 owned
```

En jeu, un adaptateur fournit le vrai stock en lisant les sacs et la banque.

### Pas de variable globale

WoW partage un seul environnement global entre tous les addons. Chaque fichier commence par :

```lua
local addonName, ns = ...
```

et partage ses modules via la table d'espace de noms `ns`, jamais via des variables globales.

## Conventions

- **Anglais** dans le code, les commentaires et les messages de commit. Les issues peuvent être écrites en anglais ou en français.
- **Lua 5.1**, la version embarquée dans le jeu.
- **Textes affichés au joueur** : toujours via les tables de traduction, jamais en chaîne littérale dans le code.

## Licence

En contribuant, vous acceptez que votre contribution soit publiée sous la [GNU General Public License v3.0](LICENSE), comme le reste du projet.
