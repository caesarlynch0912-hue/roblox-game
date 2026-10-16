# my-roblox-game

Starter Roblox game synced into Studio with [Rojo](https://rojo.space).

## What's in it
- Coins spawn around the map and spin
- Touching a coin gives you coins (shown on the leaderboard)
- Coins save between sessions with a DataStore
- A "+1" popup on screen when you collect one

## Files
| File | Where it goes in Studio | What it does |
|---|---|---|
| `src/server/init.server.luau` | ServerScriptService.Server | Starts the server systems |
| `src/server/PlayerData.luau` | ServerScriptService.Server | Leaderboard + saving |
| `src/server/CoinSpawner.luau` | ServerScriptService.Server | Spawns coins, handles pickup |
| `src/client/init.client.luau` | StarterPlayerScripts.Client | "+1" popup UI |
| `src/shared/Config.luau` | ReplicatedStorage.Shared | Settings for both sides |

## Running it
1. In this folder, run `rojo serve`
2. Open Roblox Studio and make a new Baseplate place
3. Plugins tab → Rojo → Connect
4. Press Play

To test saving in Studio: Home → Game Settings → Security → turn on "Enable Studio Access to API Services" (game must be published first).
