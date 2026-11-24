# Contributing to Craft Journey

*[Version française](CONTRIBUTING.fr.md)*

Thanks for your interest in Craft Journey! This guide explains how to report a problem, suggest an idea and contribute code.

## Ways to contribute

- **Report a bug**: open an issue with the *Bug report* form. Wrong or missing translations are bugs too.
- **Suggest a feature**: open an issue with the *Feature request* form, starting from your use case.
- **Translate**: once the addon has its locale files, translations are contributed by pull request.
- **Write code or documentation**: pick an issue labeled `accepted` (see below) and open a pull request.

Please search the [existing issues](https://github.com/Gharan-WoW-Addons/CraftJourney/issues) first: your problem or idea may already be there.

## Issue lifecycle

| Step | Status | How |
| --- | --- | --- |
| New issue | Backlog | Labeled `needs-triage` by the issue forms |
| Refinement | Backlog | Maintainers clarify the scope and the acceptance criteria |
| Accepted | Todo | Label `accepted`: the issue is ready to be worked on |
| Started | In progress | Someone is assigned: they work on it |
| Pull request | In review | A pull request linked to the issue is ready for review |
| Merged | Done | The issue is closed by the pull request |

The status changes automatically. **Wait for the `accepted` label before you start coding**, and leave a comment on the issue so that a maintainer can assign it to you. This way nobody works on something that will not be merged, and two people never work on the same issue.

## Git workflow

The repository follows a light gitflow:

- `develop` is the default branch: it gathers the next version.
- `main` holds the released versions, one tag `vX.Y.Z` per release.

To contribute:

1. Fork the repository (maintainers work on branches of the repository itself).
2. Create a branch from `develop`, named after the issue: `feature/<issue number>-<topic>`, for example `feature/12-reagent-chain`.
3. Commit as you like on your branch: commits are squashed when merged.
4. Open a pull request to `develop`, fill in the template and add `Closes #<issue number>` to its description.
5. A code owner reviews it. Once approved, the pull request is squash-merged.

### Pull request title

The pull request title becomes the commit on `develop`, so it follows [Conventional Commits](https://www.conventionalcommits.org/): `<type>: <summary>`, in English, imperative, lowercase.

| Type | Use it for |
| --- | --- |
| `feat` | A new feature for the player |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `test` | Adding or fixing tests |
| `refactor` | A code change that neither fixes a bug nor adds a feature |
| `perf` | A performance improvement |
| `build` | Repository configuration, tooling, packaging |
| `ci` | Continuous integration workflows |

Examples: `feat: track orders across characters`, `fix: wrong wool count for bags`.

## Software craftsmanship

Craft Journey is a small addon, written with care. We value code that is easy to read, to test and to change, more than code that is clever.

### Principles

- **Clean code**: clear names from the domain, short functions that do one thing, no dead code, no commented-out code. Comments explain *why*, the code explains *what*.
- **Tests first on the domain**: the business rules are written in pure Lua and covered by tests, ideally written before the code.
- **Boy scout rule**: leave the code a little cleaner than you found it, within the scope of your pull request.
- **No over-engineering**: build what the issue needs, nothing more. Three similar lines are better than a premature abstraction.

### Ubiquitous language

The code speaks the language of the players (Domain-Driven Design). Use these words, in English, everywhere: code, tests, issues and pull requests.

| Term | Meaning |
| --- | --- |
| **Recipe** | What a profession can craft, with its reagents |
| **Reagent** | An item consumed by a recipe: cloth, bolt, thread… |
| **Order** | A recipe and a quantity the player wants to craft |
| **Stock** | The items a character holds, in bags and bank |
| **Track** | A character follows an order in its tracker window |

### Layered architecture

The addon is split into layers. Dependencies only point inwards, towards the domain.

| Layer | Role | Depends on the WoW API | Tested with |
| --- | --- | --- | --- |
| **Domain** | Business rules: orders, recipes, reagent chain, totals | No, pure Lua | Unit tests |
| **Controllers** | Handle game events and user actions, call the domain, refresh the views (the *C* of MVC) | Yes | In game |
| **Adapters** | Read the game: bags, bank, professions, saved variables | Yes | In game |
| **Views** | Frames shown to the player (the *V* of MVC) | Yes | In game |

The domain never calls the WoW API. It receives what it needs from the adapters, which keeps it testable outside the game.

### SOLID in Lua

Lua has no classes or interfaces, but the principles still apply:

- **Single responsibility**: one module, one reason to change. Computing the reagent chain and drawing the tracker are two modules.
- **Open/closed**: add behavior with new modules or tables, not by piling `if` statements in existing ones.
- **Liskov substitution**: an object that replaces another (a fake stock in tests, for example) honors the same contract: same functions, same return values.
- **Interface segregation**: pass a function or a small table with only what is needed, not the whole addon.
- **Dependency inversion**: the domain depends on contracts, the adapters provide them. Inject dependencies, never fetch them from a global.

Example: the domain receives the stock through a constructor, so tests can inject a fake.

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

In game, an adapter provides the real stock by reading the bags and the bank.

### No globals

WoW shares one global environment between all addons. Every file starts with:

```lua
local addonName, ns = ...
```

and shares its modules through the `ns` namespace table, never through globals.

## Conventions

- **English** in the code, comments and commit messages. Issues can be written in English or French.
- **Lua 5.1**, the version embedded in the game.
- **User-facing texts** always go through the translation tables, never as literal strings in the code.

## License

By contributing, you agree that your contribution is released under the [GNU General Public License v3.0](LICENSE), like the rest of the project.
