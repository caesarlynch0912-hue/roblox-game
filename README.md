# my-roblox-game

Starter Roblox game synced into Studio with [Rojo](https://rojo.space).

## What's in it
- Coins spawn around the map and spin: Gold (1), Silver (3) and rare glowing Diamond (10), up to 80 at once
- Touching a coin gives you coins (shown on the leaderboard)
- A shop button to buy speed upgrades with coins (10 levels, each costs more)
- Coins and speed level save between sessions with a DataStore
- A "+N" popup in the coin's color when you collect one
- A custom shift lock: press Left Shift to lock the camera over your shoulder (Roblox's built-in one is turned off)

All the numbers (coin values, spawn rate, upgrade costs) are in `src/shared/Config.luau`.

## Files
| File | Where it goes in Studio | What it does |
|---|---|---|
| `src/server/init.server.luau` | ServerScriptService.Server | Starts the server systems |
| `src/server/PlayerData.luau` | ServerScriptService.Server | Leaderboard + saving |
| `src/server/CoinSpawner.luau` | ServerScriptService.Server | Spawns coins, handles pickup |
| `src/server/Shop.luau` | ServerScriptService.Server | Buying speed upgrades |
| `src/client/init.client.luau` | StarterPlayerScripts.Client | Starts the client UI |
| `src/client/CoinPopups.luau` | StarterPlayerScripts.Client | "+N" popups |
| `src/client/ShopButton.luau` | StarterPlayerScripts.Client | Speed upgrade button |
| `src/client/ShiftLock.luau` | StarterPlayerScripts.Client | Custom shift lock |
| `src/shared/Config.luau` | ReplicatedStorage.Shared | Settings for both sides |

Other files in the repo:

| File | What it's for |
|---|---|
| `default.project.json` | Tells Rojo how the files map into Studio |
| `rokit.toml` | Pins the tool versions (Rojo, StyLua, selene, Wally, Lune) |
| `selene.toml` | Linter settings |
| `stylua.toml` | Formatter settings |
| `CLAUDE.md` | Project guide for Claude Code, including which skill to use when |
| `.claude/skills/` | Roblox skills for Claude Code, from [EL4CTEO/roblox-skills](https://github.com/EL4CTEO/roblox-skills) |

## Setup (once)
1. Install [Rokit](https://github.com/rojo-rbx/rokit)
2. In this folder, run `rokit install` to get the pinned tools
3. In Roblox Studio, install the Rojo plugin (`rojo plugin install`)

## Running it
1. In this folder, run `rojo serve`
2. Open Roblox Studio and make a new Baseplate place
3. Plugins tab → Rojo → Connect
4. Press Play

To test saving in Studio: Home → Game Settings → Security → turn on "Enable Studio Access to API Services" (game must be published first).

## Checking your code
- `selene src` — finds mistakes and bad patterns
- `stylua src` — formats the code (`stylua --check src` only checks)
- `rojo build -o build.rbxlx` — makes sure the project builds
