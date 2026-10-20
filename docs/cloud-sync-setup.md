# ログイン＋クラウド同期（Console 手順）

アプリ実装は済んでいる。利用前に Firebase Console とデプロイを済ませる。

## Authentication

1. Firebase Console → プロジェクト `physicsgacha` → Authentication → Sign-in method
2. **Google** を有効化
3. **Apple** を有効化（iOS Bundle ID: `com.joyphysics.physicsGacha`）

メール／電話は使わない。

## Android（Google）

- デバッグ／リリースの SHA-1 を Firebase アプリ設定に登録する（AI セットアップで debug は済みの想定）
- `google-services.json` を再ダウンロードして置く必要がある場合は従前どおり

## iOS（Apple）

- App ID に Sign in with Apple Capability（Xcode の `Runner.entitlements` も追加済み）
- Apple Developer / Firebase の Apple プロバイダ設定を揃える

## Firestore Rules

リポジトリの [`firestore.rules`](../firestore.rules) をデプロイ:

```bash
npx firebase-tools deploy --only firestore:rules --project physicsgacha
```

## Cloud Function（アカウント削除）

`deleteMyAccount` をデプロイ（AI の `aiChat` と同じプロジェクト）:

```bash
cd functions && npm run build
npx firebase-tools deploy --only functions:deleteMyAccount --project physicsgacha
```

クライアントは `AI_CHAT_ENDPOINT` の兄弟 URL として  
`.../deleteMyAccount` を自動導出する（上書きは `--dart-define=ACCOUNT_DELETION_ENDPOINT=...`）。

## 動作確認

1. 未ログイン: ローカルのみ（クラウドアイコン）
2. iOS は Apple／Android は Google でログイン → 同期オン
3. 履歴が Firestore `users/{uid}/learning_records` と  
   `users/{uid}/settings/gacha_settings/gacha_types/physics` に出る
4. ログアウトしても端末データは残る
5. 別アカウントでログインすると端末のガチャ snapshot は付け替わる
6. アカウント削除 → Auth ユーザーと `users/{uid}` が消える

## プライバシー

文面の更新はアプリ外で行う（Apple／Google・アプリ内削除に合わせる）。
