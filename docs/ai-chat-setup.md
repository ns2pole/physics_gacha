# AIチャット（物理ガチャ）セットアップ

iOS 向け。Android は後で `google-services.json` と `firebase_options.android` を埋める。

## すでに済んでいること（ローカル）

- Firebase プロジェクト `physicsgacha`
- iOS アプリ `com.joyphysics.physicsGacha`
- App Check（App Attest）

## クローン後のローカル設定

`GoogleService-Info.plist` は git に含めない。Firebase Console からダウンロードして置く:

```bash
cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
# 中身を Console の実ファイルで置き換える
```

`lib/firebase_options.dart` はプレースホルダ／dart-define 用。プレースホルダのときは iOS は plist から初期化する。

## Cloud Functions デプロイ

```bash
cd functions
npm install
firebase use physicsgacha
firebase functions:secrets:set GEMINI_API_KEY
npm run deploy
```

エンドポイント例:

`https://asia-northeast1-physicsgacha.cloudfunctions.net/aiChat`

## アプリの起動

```bash
flutter run --dart-define=AI_CHAT_ENDPOINT=https://asia-northeast1-physicsgacha.cloudfunctions.net/aiChat
```

`AI_CHAT_ENDPOINT` を付けないと Stub クライアントになり、ネット通信はしない。

## App Check Debug トークン（開発時）

1. デバッグビルドでアプリを起動する
2. Xcode / コンソールログに Debug token が出る
3. Firebase Console → App Check → アプリ → オーバーフロー → Debug トークンを管理 → 追加

## Android を足すとき

1. Firebase に Android アプリ `com.joyphysics.physics_gacha` を追加
2. `google-services.json` を `android/app/` に置く
3. `lib/firebase_options.dart` の `android` を実値に置き換える
4. App Check で Play Integrity（本番）/ Debug（開発）を登録
