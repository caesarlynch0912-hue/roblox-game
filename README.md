# my-roblox-game

Starter Roblox game synced into Studio with [Rojo](https://rojo.space).

## What's in it
- Coins spawn around the map and spin: Gold (1), Silver (3) and rare glowing Diamond (10)
- Touching a coin gives you coins (shown on the leaderboard)
- A shop button to buy speed upgrades with coins (10 levels, each costs more)
- Coins and speed level save between sessions with a DataStore
- A "+N" popup in the coin's color when you collect one

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
| `src/shared/Config.luau` | ReplicatedStorage.Shared | Settings for both sides |

## Running it
1. In this folder, run `rojo serve`
2. Open Roblox Studio and make a new Baseplate place
3. Plugins tab → Rojo → Connect
4. Press Play

To test saving in Studio: Home → Game Settings → Security → turn on "Enable Studio Access to API Services" (game must be published first).
