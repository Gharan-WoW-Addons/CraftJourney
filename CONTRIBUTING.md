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
| Refinement | Backlog | Maintainers clarify the scope and the acceptance criteria. For a bug, they only check that it is complete (steps to reproduce, versions, logs) and not a duplicate. An **Urgent** bug skips refinement |
| Accepted | Todo | Label `accepted`: the issue is ready to be worked on |
| Started | In progress | Someone is assigned: they work on it |
| Pull request | In review | A pull request linked to the issue is ready for review |
| Merged | Done | The issue is closed by the pull request |

The status changes automatically. **Wait for the `accepted` label before you start coding**, and leave a comment on the issue so that a maintainer can assign it to you. This way nobody works on something that will not be merged, and two people never work on the same issue.

### Priority and effort

Each issue gets a priority and an effort during refinement. They tell you when it will be worked on.

| Priority | Bug | Feature / Task |
| --- | --- | --- |
| Urgent | Breaks a released version or is a security flaw: taken at once, without refinement, hotfix from `main` | Not used |
| High | Annoying bug in game: fixed after the feature in progress, in a patch version (hotfix) | Blocks other issues of the milestone: taken first |
| Medium | Annoying, but no released version is affected (tooling, development): fixed in the current milestone | Core of the milestone |
| Low | Not annoying: fixed in a later milestone | Optional: moved out of the milestone if time runs short |

The effort is relative to the complexity, not a number of hours:

| Effort | Meaning |
| --- | --- |
| Low | Simple and known change, few files, no unknowns |
| Medium | Several files or parts, or one unknown to clear up |
| High | Many unknowns or a big piece of work: split it if possible |

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

## Continuous integration

Every pull request to `develop` or `main` runs these checks. They are all **required**: a single red check blocks the merge.

| Check | What it verifies |
| --- | --- |
| `lint` | Luacheck and `stylua --check`: no warning, code formatted |
| `test` | busted tests, with the coverage summary in the job summary |
| `pr-title` | The title follows Conventional Commits (see above) |
| `Analyze (actions)` | CodeQL security analysis of the GitHub Actions workflows |

Run `luacheck .`, `stylua --check .` and `busted` locally before you push: the CI installs the same tools, at the same versions (pinned in `.github/workflows/ci.yml`: a version changes in both places).

The branch must also be **up to date** with its base branch: what the CI tested is exactly what gets merged. If `develop` moved on since you opened your pull request, click **Update branch** on the pull request (or merge `develop` into your branch and push).

After a merge into `develop`, only CodeQL runs again, to keep the *Security* tab up to date. Dependabot opens pull requests to update the GitHub Actions used by the workflows.

## Development tools

Everything specific to the project lives in the project: Lua, its packages and the formatter are installed in `lua_modules/` (ignored by Git), nothing is installed globally except `pipx`.

| Tool | Version | Role |
| --- | --- | --- |
| [Lua](https://www.lua.org/) | 5.1.5 | The version embedded in the game |
| [LuaRocks](https://luarocks.org/) | 3.13.0 | Lua package manager |
| [busted](https://lunarmodules.github.io/busted/) | 2.3.0 | Unit tests |
| [LuaCov](https://lunarmodules.github.io/luacov/) | 0.17.0 | Test coverage |
| [Luacheck](https://luacheck.readthedocs.io/) | 1.2.0 | Static analysis (undefined or unused variables, globals…) |
| [StyLua](https://github.com/JohnnyMorganz/StyLua) | 2.6.0 | Code formatter |

### Install

Requirements: Git, Python 3, a C compiler (on macOS: `xcode-select --install`) and [pipx](https://pipx.pypa.io/) (on macOS: `brew install pipx`).

From the repository root:

```bash
# Lua 5.1 (with its official bug fixes) and LuaRocks, isolated in lua_modules/
pipx run hererocks==0.25.1 lua_modules -l5.1 --patch -r@v3.13.0

# Activate the environment (like a Python venv), then install the tools
source lua_modules/bin/activate
luarocks install busted 2.3.0-1
luarocks install luacov 0.17.0-1
luarocks install luacheck 1.2.0-1

# StyLua: binary of the GitHub release, in the same folder
# (macOS Intel: stylua-macos-x86_64.zip, Linux: stylua-linux-x86_64.zip)
curl -L -o /tmp/stylua.zip https://github.com/JohnnyMorganz/StyLua/releases/download/v2.6.0/stylua-macos-aarch64.zip
unzip -o /tmp/stylua.zip -d lua_modules/bin && chmod +x lua_modules/bin/stylua
```

On Windows, [hererocks](https://github.com/luarocks/hererocks) needs MinGW or Visual Studio, the environment is activated with `lua_modules\bin\activate.bat` (or `activate.ps1`), and StyLua comes from `stylua-windows-x86_64.zip`.

[hererocks](https://github.com/luarocks/hererocks) is run with `pipx run`: it is not installed, it is only needed to create `lua_modules/`.

### Daily use

```bash
source lua_modules/bin/activate   # once per terminal; leave with deactivate-lua

busted                            # tests, with coverage data
luacov                            # coverage report in luacov.report.out
luacheck .                        # static analysis
stylua .                          # format the code (stylua --check . only checks)
```

Configuration files: `.busted`, `.luacov`, `.luacheckrc`, `stylua.toml`.

### Tests

Tests live in `spec/` and end with `_spec.lua`. They cover the domain, in pure Lua. To load an addon file the way the game does (with `local addonName, ns = ...`), use the test helper:

```lua
local Addon = require("spec.support.addon")

local ns = Addon.load("Domain/Order.lua")
```

### VS Code

Open the repository folder: VS Code suggests the recommended extensions (`.vscode/extensions.json`):

- [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) (LuaLS): completion and errors in the editor.
- [WoW API](https://marketplace.visualstudio.com/items?itemName=ketho.wow-api): documentation of the game API for LuaLS.
- [WoW TOC](https://marketplace.visualstudio.com/items?itemName=stanzilla.vscode-wow-toc): colors the `.toc` file (directives, comments, files).
- [StyLua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua): formats Lua files on save, with the StyLua of `lua_modules/`.
- [Run on Save](https://marketplace.visualstudio.com/items?itemName=emeraldwalk.RunOnSave): copies the addon into the game on save (see *In game*).

The shared settings are in `.vscode/settings.json`. They tell the WoW API extension to write its LuaLS settings (Lua 5.1, game API annotations) in your **user** settings, not in the repository: they then apply to all your WoW addons, and `.vscode/settings.json` stays clean whatever way you open the project.

### In game

Copy the addon into the `Interface/AddOns/` folder of the game with the sync script. It copies only the files the game needs, and removes from the game folder the files you deleted:

```bash
# Adapt the path to your installation
scripts/sync-to-game.sh "/Applications/World of Warcraft/_forever_/Interface/AddOns"
```

Do not link the repository with a symbolic link: it breaks the game updates in Battle.net.

The script copies the working copy into its own `CraftJourney-dev` folder, with its `.toc` file renamed `CraftJourney-dev.toc` (the game only loads a `.toc` file named after its folder) and *(dev)* added to its title. The released version, installed from CurseForge or Wago, keeps the `CraftJourney` folder: both stay installed side by side, so you can reproduce a bug on the released version, then fix it on the working copy. **Enable only one of them at a time** in the AddOns list of the game: they share the same commands and global variables. Each one keeps its own saved variables.

To copy on every save, install the recommended **Run on Save** extension and add this block to your **user** settings (*Preferences: Open User Settings (JSON)*), with your own path. The extension reads its settings at the window level only, so this block does not work from `.vscode/settings.json` in a multi-root workspace.

```json
"emeraldwalk.runonsave": {
  "commands": [
    {
      "match": "/CraftJourney/.*\\.(lua|toc)$",
      "notMatch": "/CraftJourney/(spec|lua_modules)/",
      "cmd": "\"${workspaceFolder}/scripts/sync-to-game.sh\" \"/Applications/World of Warcraft/_forever_/Interface/AddOns\""
    }
  ]
}
```

Deleting a file does not trigger the copy: it is removed from the game folder at the next save, or when you run the script by hand.

On Windows, run the same copy with `robocopy` (adapt the paths and add the exclusions of the script):

```bat
robocopy "C:\path\to\CraftJourney" "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftJourney-dev" /MIR /XD .git .github .vscode lua_modules spec docs scripts /XF *.md LICENSE stylua.toml luacov.* CraftJourney.toc CraftJourney-dev.toc
copy "C:\path\to\CraftJourney\CraftJourney.toc" "C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftJourney-dev\CraftJourney-dev.toc"
```

Then in game:

- `/reload` reloads the interface after a change.
- `/console scriptErrors 1` shows Lua errors.

## Security

Found a vulnerability? Do **not** open a public issue: report it privately, as explained in [SECURITY.md](SECURITY.md).

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
