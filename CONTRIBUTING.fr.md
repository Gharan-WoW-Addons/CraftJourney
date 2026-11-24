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
