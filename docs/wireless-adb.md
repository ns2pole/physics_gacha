# 無線デバッグ（ADB）

Android 実機を Wi‑Fi で繋ぐとき。

## 手順

1. 端末: 開発者向けオプション → **ワイヤレスデバッグ** をオン
2. **ペアリングコードでデバイスをペア設定** を開き、表示された値を控える
   - ペア用 IP:ポート（例 `192.168.188.186:39383`）
   - 6桁コード
3. 同じ画面の上の方にある **接続用** IP:ポートも控える（例 `192.168.188.186:37197`）
4. Mac で:

```bash
adb pair <ペア用IP>:<ポート> <6桁コード>
adb connect <接続用IP>:<ポート>
adb devices
```

例:

```bash
adb pair 192.168.188.186:39383 623408
adb connect 192.168.188.186:37197
```

5. `device` と出たら:

```bash
cd /path/to/physicsGacha
flutter run -d <adb devices のシリアル> \
  --dart-define=AI_CHAT_ENDPOINT=https://asia-northeast1-physicsgacha.cloudfunctions.net/aiChat
```

シリアルは `adb-….._adb-tls-connect._tcp` 形式のこともある。そのときは `-d` にそれをそのまま渡す。

## 注意

- ペア用ポートとコードはすぐ期限切れになる。失敗したら画面で新しい値を出す
- すでにペア済みで mDNS に出ているときは `adb pair` なしで `adb devices` に載ることがある
- `adb pair` が `protocol fault` なら、だいたいポート／コード期限切れ
