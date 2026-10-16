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

Tools are pinned in `rokit.toml` (Rojo, StyLua, selene, Wally, Lune). Run `rokit install` after cloning.

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

## Skills: when to use each one

Project skills live in `.claude/skills/` (from EL4CTEO/roblox-skills). Load the matching skill **before** writing or reviewing code in that area. Several may apply at once — e.g. a new shop item uses `roblox-game-systems` + `roblox-networking` + `roblox-security` + `roblox-ui`.

### Use on almost every change

| Skill | Use when |
|---|---|
| `roblox-luau` | Writing, refactoring, or explaining any Luau in `src/`; fixing type errors; choosing `task.*` APIs |
| `roblox-architecture` | Deciding where new code or assets go (server/client/shared), adding a new system or module, player/character lifecycle, CollectionService tags |
| `roblox-code-review` | Reviewing a diff or file before commit, auditing the game, or asked "what's wrong with this code" |

### Core to this game

| Skill | Use when |
|---|---|
| `roblox-game-systems` | Changing coins, currency, leaderstats, the speed shop, adding upgrades, rewards, pets, or rounds |
| `roblox-data-stores` | Touching `PlayerData.luau`, saving or loading anything, changing the save schema or `DataStoreName`, leaderboards, data loss/throttling bugs |
| `roblox-networking` | Adding or changing a RemoteEvent/RemoteFunction (`CoinCollected`, `BuySpeed`), syncing state to clients |
| `roblox-security` | Any server handler that reacts to client input — coin pickups, purchases, speed — or checking for exploits |
| `roblox-physics` | Coin pickup detection (`Touched`), raycasts, collision groups, moving or spinning parts, CFrame math |
| `roblox-ui` | The shop button, coin popups, HUD, menus, or UI that breaks on mobile/console |
| `roblox-characters-animation` | WalkSpeed/speed upgrades, Humanoid, respawn, animations, tweens, tools |
| `roblox-input` | Shift lock (`ShiftLock.luau`), keybinds, mobile buttons, gamepad, camera |
| `roblox-tooling` | Rojo, Rokit, Wally packages, StyLua, selene, luau-lsp, Lune, `default.project.json`, CI setup |

### Use when the feature calls for it

| Skill | Use when |
|---|---|
| `roblox-world-building` | Building the map, terrain, lighting, particles/effects for coins |
| `roblox-audio` | Coin pickup sounds, music, sound effects |
| `roblox-performance` | Lag, FPS drops, memory leaks, too many coins, before optimizing hot code |
| `roblox-testing` | Adding tests (Lune for pure modules like `Config.speedCost`), a test runner, or verifying a gameplay change |
| `roblox-monetization` | Robux purchases: developer products, game passes, ProcessReceipt |
| `roblox-analytics-liveops` | Economy/funnel analytics, daily rewards, A/B tests, live events, badges |
| `roblox-text-chat` | Chat commands or showing any player-written text to others |
| `roblox-npc-ai` | Adding NPCs, enemies, pets that follow, pathfinding |
| `roblox-teleport-matchmaking` | Multiple places, lobbies, teleports, reserved servers |
| `roblox-open-cloud` | External tools, web APIs, Open Cloud, HttpService |
| `roblox-studio-mcp` | Driving an open Studio session through the Studio MCP server (only if it is set up) |

## Ask first — never do these unprompted

Some skills include setup examples that must not be run automatically:

- Do not publish the place or add CI that publishes (`versionType=Published`, Open Cloud place upload).
- Do not run `curl … | bash` / `iwr … | iex` installers — tools come from `rokit.toml`.
- Do not edit global or Studio config (`ClientAppSettings.json` fflags, `~/.codex`, `~/.gemini`, global MCP config).
- Do not create, read, or hardcode API keys or `.ROBLOSECURITY`.
- Do not change `DataStoreName` without a migration plan — it resets everyone's saves.
- Do not commit or push without the user asking.
