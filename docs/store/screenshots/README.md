# App Store screenshots

4 combinations × 6 screens = 24 PNGs.

| Device | Locale | Size | Path |
|--------|--------|------|------|
| iPhone 16 Pro Max (6.9") | ja | 1320×2868 | `iphone/ja/` |
| iPhone 16 Pro Max (6.9") | en | 1320×2868 | `iphone/en/` |
| iPad Pro 13" (M4) | ja | 2064×2752 | `ipad13/ja/` |
| iPad Pro 13" (M4) | en | 2064×2752 | `ipad13/en/` |

## Screen IDs

1. `01_home` — gacha + domain filters + problem (no chapter name)
2. `02_calculator` — numeric keypad answer entry
3. `03_hint` — hint revealed
4. `04_answer` — approach / solution
5. `05_problem_list` — history / problem list
6. `06_ask_ai` — AI chat for the current problem

## Re-capture

```bash
# iPhone JA / EN
./tools/capture_store_shots.sh 3B56C1F3-F081-4246-AB02-F78AFFCBC4E9 iphone ja
./tools/capture_store_shots.sh 3B56C1F3-F081-4246-AB02-F78AFFCBC4E9 iphone en

# iPad Pro 13"
./tools/capture_store_shots.sh BE62F501-E688-4B46-9273-ED1770A6AC8F ipad13 ja
./tools/capture_store_shots.sh BE62F501-E688-4B46-9273-ED1770A6AC8F ipad13 en
```

Uses `--dart-define=STORE_SHOTS=true` (auto UI tour) and hides the DEBUG banner.
