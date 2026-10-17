# roblox-game

A Roblox coin-collecting game written in Luau and synced into Studio with Rojo. Coins (Gold 1, Silver 3, Diamond 10) spawn around the map; players collect them by touching them, spend them on speed upgrades in a shop, and progress saves in a DataStore.

## Layout

| Path | In Studio | Purpose |
|---|---|---|
| `src/server/init.server.luau` | ServerScriptService.Server | Entry point; creates the `CoinCollected` RemoteEvent and starts the systems |
| `src/server/PlayerData.luau` | ServerScriptService.Server | leaderstats + DataStore load/save |
| `src/server/CoinSpawner.luau` | ServerScriptService.Server | Spawns coins, handles pickup |
| `src/server/Shop.luau` | ServerScriptService.Server | `BuySpeed` RemoteFunction, speed upgrades |
| `src/client/init.client.luau` | StarterPlayerScripts.Client | Client entry point |
| `src/client/CoinPopups.luau` | StarterPlayerScripts.Client | "+N" popups |
| `src/client/ShopButton.luau` | StarterPlayerScripts.Client | Speed upgrade button |
| `src/client/ShiftLock.luau` | StarterPlayerScripts.Client | Custom shift lock (built-in one is disabled in `default.project.json`) |
| `src/shared/Config.luau` | ReplicatedStorage.Shared | All tunable numbers for both sides |

The Studio tree is defined in `default.project.json`.

## Tools and commands

Tools are pinned in `rokit.toml` (Rojo, StyLua, selene, Wally, Lune, luau-lsp). Run `rokit install` after cloning.

- `rojo serve` — live-sync into Studio (Plugins → Rojo → Connect)
- `rojo build -o build.rbxlx` — build a place file to check the project compiles
- `selene src` — lint (Roblox std, `selene.toml`)
- `stylua src` / `stylua --check src` — format / check formatting (`stylua.toml`)

Run `selene src` and `stylua --check src` before committing Luau changes.

## Code conventions

- Server is authoritative: the client only asks, the server validates and decides (coins, purchases, speed).
- Gameplay numbers live in `src/shared/Config.luau`, not hardcoded in systems.
- Wrap every DataStore call in `pcall`; the game must still run unpublished or without API access.
- Each system is a module with a `start(...)` function wired up from the `init` script.
- Tabs for indentation; files are checked out with CRLF (`core.autocrlf=true`), which `stylua.toml` matches.
- Short comments that explain why, written for a beginner reading the code.

## Skill and MCP servers

### Skill: `roblox-dev-skill`

The one Roblox skill is [MSayib/roblox-dev-skill](https://github.com/MSayib/roblox-dev-skill), installed per user in `~/.claude/skills/roblox-dev-skill` (not in this repo). Load it **before** writing, reviewing, or explaining any Luau or Roblox code, then read the reference that matches the area:

| Area in this game | Reference in the skill |
|---|---|
| Any Luau in `src/`, `--!strict`, type errors | `references/luau-fundamentals.md` |
| Where code goes (server/client/shared), new systems, Rojo layout | `references/project-structure.md` |
| `CoinCollected`, `BuySpeed`, or any new remote | `references/networking.md` + `references/security-hardening.md` |
| Coin pickups, purchases, speed — anything reacting to client input | `references/security-hardening.md` |
| `PlayerData.luau`, save schema, `DataStoreName`, leaderboards | `references/datastore-persistence.md` |
| Shop button, coin popups, HUD | `references/ui-systems.md` |
| Robux purchases (developer products, passes) | `references/monetization.md` |
| Lag, too many coins, memory | `references/performance-optimization.md` |
| Old patterns (`wait`, `spawn`, deprecated APIs) | `references/legacy-migration.md` |
| Driving Studio through MCP | `references/mcp-integration.md` + `references/agent-safety.md` |
| End-to-end feature or debugging walkthroughs | `references/worked-examples.md` |

The skill must not update its own knowledge or download the API dump (`~/RobloxDocs`) without asking.

### MCP servers (`.mcp.json`)

| Server | What it does |
|---|---|
| `Roblox_Studio` | Roblox's built-in Studio MCP (`%LOCALAPPDATA%\Roblox\mcp.bat`). Needs Studio open with **Assistant → … → Manage MCP Servers → Enable Studio as MCP server**. It edits the open place with no undo: confirm which place is open before writing, and prefer editing files in `src/` and syncing with Rojo over editing scripts in Studio. |
| `roblox-docs` | API reference lookups (`uvx mcp-roblox-docs`, run with `mcp<2` because 3.3.1 breaks on mcp 2.x). Check classes, members, enums, and deprecations here before relying on memory. |

## Ask first — never do these unprompted

The skill and MCP docs include setup examples that must not be run automatically:

- Do not publish the place or add CI that publishes (`versionType=Published`, Open Cloud place upload).
- Do not run `curl … | bash` / `iwr … | iex` installers — tools come from `rokit.toml`.
- Do not edit global or Studio config (`ClientAppSettings.json` fflags, `~/.codex`, `~/.gemini`, global MCP config).
- Do not create, read, or hardcode API keys or `.ROBLOSECURITY`.
- Do not change `DataStoreName` without a migration plan — it resets everyone's saves.
- Do not commit or push without the user asking.
