# Poggy Crafting

A crafting system for RedM, built on [poggy_core](https://github.com/RosewoodRidge/-Poggy-Scripts-).
Benches, campfires and world props open a recipe browser that shows the whole
tree behind an item: what it takes, what makes those, what they are used in, and
where in the world each ingredient comes from.

Runs on **VORP**, **RSG** and **QBR** — every framework call goes through
poggy_core, so there is one copy of this script and it does not care which one
you run.

---

## What it does

**A recipe browser, not a list.** Categories down the side, a search that matches
recipe names, ingredients and rewards, and two filters: *materials only* (things
you can make right now) and *only accessible* (hide what your job cannot touch).
A recipe you have not unlocked still appears, greyed out under **Requires
Access**, so people can see what a job would open up.

**Recipe chains.** Open a recipe and the browser draws the tree beneath it: each
ingredient, whether it can itself be crafted, and how far you are from having
enough. **Used In** shows the other way — what this item feeds into.

**Where do I get this?** Hover any ingredient and a card says how it is obtained,
from `config/item_sources.lua`. Fill that in once and your Discord stops getting
asked where sulfur comes from.

**A shopping list and a gathering tracker.** Add a recipe's ingredients to a
per-character list. Tick one off, or pin the list to a small draggable window
that stays on screen while you go and collect them — the counts fill in as items
land in your inventory.

**Skillchecks, optionally.** A recipe can ask for timed rounds instead of a
progress bar (needs [poggy_skillcheck](https://rosewoodridge.xyz/store/poggy-skillcheck), free).
Pass them all for the full reward, pass some for a share of it, hit the clean
band for a bonus. A recipe can be dangerous: miss a round on dynamite and it goes
off in your hands; miss one on a moonshine run and you catch fire.

**Craft what you were never taught.** A recipe locked to a job can be left open
to everyone through `jobSkillcheck` — the tradesman crafts it straight away,
anyone else has to earn it on a much harder skillcheck. Nobody is locked out of
your economy; they just find it hard.

**Alternative ingredients.** One slot can accept a list of items — "any fish",
"any pelt" — and `AltRewards` pays out by which one was actually used.

**Currency recipes.** A recipe can charge money, pay money, or both, in cash,
gold or role tokens.

---

## Requirements

| | |
|---|---|
| **poggy_core** | 0.16.0 or newer. Install this first. |
| **Framework** | VORP, RSG or QBR. |
| **oxmysql** | For the shopping list. |
| **poggy_skillcheck** | Optional, free. Only needed if your recipes use `skillcheck` or `jobSkillcheck`. |

No progress bar resource. No `uiprompt`. No menu resource. The script draws its
own.

---

## Install

1. Drop `poggy_crafting` in your resources folder.
2. `ensure poggy_crafting` in your `server.cfg`, **after** `poggy_core`.
3. Copy `docs/item_images/campfire.png` into your inventory's item icon folder
   (`vorp_inventory/html/img/items/`, or your framework's equivalent).

There is no SQL to import. poggy_core creates the table and adds the campfire
item the first time the script starts. To manage the database yourself instead,
set `PoggyCoreConfig.Sql.AutoInstall = false` in poggy_core's config and import
`sql/install.sql`.

Then open `config/recipes.lua` and write your recipes. The ones that ship are
examples — thirteen of them, each showing off one feature, using stock item
names. They are meant to be deleted.

---

## Commands

| Command | What it does |
|---|---|
| `/craft` | Opens the browser anywhere. Recipes that need a bench are still out of reach. |
| `/gt` | Lends the mouse to the gathering tracker so you can drag it somewhere else. |
| `/gthide` | Hides or shows the tracker. |
| `/extinguish` | Puts out the campfire you placed. |

Every command name is set in `Config.Commands`; set one to `false` to remove it.

---

## Configuration

| File | What is in it |
|---|---|
| `config/config.lua` | Benches, world props, campfires, timing, categories, animations, skillcheck difficulty, the progress bar. |
| `config/recipes.lua` | `Config.Crafting` — every recipe, with the full field reference at the top. |
| `config/item_sources.lua` | The "where do I get this?" tooltip. |
| `translations.lua` | Every string a player can see, including the browser. |

All four are readable and editable, and the updater merges them forward: your
values survive an update and new settings appear alongside them.

### Where people craft

Three things can open the browser, and a recipe can require any of them:

- **Benches** in `Config.Locations` — a fixed point with a name, an optional
  blip, an optional job lock, and optionally only certain categories.
- **World props** in `Config.CraftingProps` — every campfire, oven and forge the
  game already places. Walk up to one and the prompt appears.
- **A placed campfire** — the `campfire` item, used from the inventory.

`Config.CraftingPropsEnabled = false` turns the prop scan off. It is the most
expensive thing this script does, and a server that only crafts at fixed benches
should switch it off.

### Recipe fields

Documented in full at the top of `config/recipes.lua`. The short version:
`Items` in, `Reward` out, `Job` and `Location` decide who and where, `Category`
decides where it appears, and the skillcheck fields decide how hard it is.

---

## Notes

**`canUseDecay` is VORP-only.** It refuses an ingredient below a condition
threshold. VORP tracks item condition; RSG and QBR do not, so the check passes
and the item is accepted there. Note also that the *acceptance* is per-stack but
the *removal* is by item name — on a mixed inventory the game may consume a
different stack of the same item than the one that passed the check.

**Recipe names are identities.** The server matches a craft request on a
recipe's `Text`, and the shopping list stores it. Renaming a recipe orphans
anything already on a list. Treat it as an id.

**Nothing the browser sends is trusted.** The page sends a recipe name and a
quantity. The server looks the recipe up in its own config, reads the job again,
counts the real inventory, and only then takes anything. Everything the browser
greys out is checked again before it matters.

**Materials are taken before a skillcheck.** That is deliberate: a failed craft
has to cost something or there is no reason to aim.

---

## Credits and licence

The original `vorp_crafting` was written by the VORP team (@blue) and is
distributed under the **GNU General Public License v2** — see `LICENSE`. This is
a fork of it: the interface, the shopping list, the gathering tracker, the
skillcheck system, the chain view and the poggy_core layer are new, and the
licence carries over to the whole of it.

Redesign and rework by **Poggy** / [Rosewood Ridge](https://rosewoodridge.xyz).
