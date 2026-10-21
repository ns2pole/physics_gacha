# 英語対応チェックリスト

端末が `ja` → 日本語、それ以外 → 英語。完了したら `[x]`。

## 基盤

- [x] `l10n.yaml` / `generate: true` / `flutter_localizations`
- [x] `lib/l10n/app_ja.arb` + `app_en.arb`（キー同数）
- [x] `lib/utils/locale_utils.dart`（`resolveAppLocale`）
- [x] `MaterialApp` に delegates / `localeResolutionCallback` / `onGenerateTitle`

## UI 画面

- [x] ガチャ画面（タイトル、問題一覧、ガチャを回す、ヒント／答え／AI、電卓、空プール）
- [x] アカウントメニュー（ログイン、同期、削除、ログアウト、SnackBar）
- [x] フィルタバー（単元名、除外なし／最新N回…）
- [x] 問題一覧（単元チップ、除外、該当なし、詳細）
- [x] 問題詳細（答え／ヒント／方針／最初の一手／解説）
- [x] 数値・単位・記号キーパッド
- [x] アカウント削除フロー・クラウドログインダイアログ
- [x] AI チャット文言（greeting / placeholder / starters / 上限 / 音声）

## 問題コンテンツ（29問）

各問: statement / hint / approach / firstStep / explanation / theme
必要なら answerDisplay / symbolChoices / symbolOrder

- [x] sample-mechanics
- [x] sample-electromagnetism
- [x] sample-waves
- [x] sample-thermodynamics
- [x] sample-atom
- [x] sample-fusion
- [x] sample-sliding
- [x] sample-electrons
- [x] sample-free-end
- [x] sample-fixed-end
- [x] sample-spectrum（名称を並べる）
- [x] sample-spring-pulleys
- [x] sample-air-resistance
- [x] sample-ac-power
- [x] sample-incline
- [x] a3ed863f-73f0-4ba2-977a-268f464df3ad
- [x] b6cb0c9c-869b-44b0-a121-e28b7bca1597
- [x] 4f9096d1-35ee-49ee-b4c9-48041c56cdee
- [x] 5adf49b5-0a92-439b-9f65-88ad58a94bc3
- [x] 059e9128-3c09-4e75-9a6b-8c401a807e7c
- [x] 62dce096-726f-4a28-8139-de3eff094793
- [x] bf43572d-42ac-4b81-9dce-85c4a71ee6d7
- [x] 2eef6ac4-67da-439f-b4fa-d6436a743eb8
- [x] 6dbf478a-bb30-40a4-bacb-c7c1ddd5b550
- [x] c6d333a8-fdff-45e6-ae3d-d576394a8f58
- [x] 680f161b-8039-4d8b-97ac-54d641bf875e
- [x] 63f5a83f-3152-4583-8c46-67bc2e33d8bc
- [x] 11cf8d71-4c2b-45ed-bb3e-3718131609c2
- [x] 94b33f1d-6d59-425c-9481-9b73a8686890

## 図ラベル

- [x] stackedBlocks（物体A/B/C、外力）
- [x] slidingComparison（初速）
- [x] openPipe（腹、開管）
- [x] freeEndReflection（壁、腹、節）
- [x] fixedEndReflection（壁、節）
- [x] springPulleys（ばね）
- [x] inclinePull（小物体、糸）
- [x] gasCylinders（はじめ／あと、等温／等圧／等積／断熱圧縮）
- [x] verticalSpringOscillation（数値のみ）
- [x] simplePendulum（数値のみ）
- [x] keplerOrbits（太陽）
- [x] beats（440 Hz / 442 Hz、数値のみ）

## その他アプリ内

- [x] 無次元の表示ラベル（採点キーは変更しない）
- [x] `getLocalizedAnswerUnitLabel`
- [x] AI セッション title / category / question / explanation のローカライズ
- [x] ドメイン・除外・履歴ラベル

## ネイティブ

- [x] Android `app_name`（values / values-en）
- [x] iOS InfoPlist.strings（ja / en）表示名
- [x] iOS マイク・音声認識の usage 文言（日英）

## ストア掲載

- [x] `docs/store/listing-ja.md`
- [x] `docs/store/listing-en.md`

## 対象外（ユーザー担当）

- [ ] （対象外）`docs/privacy-policy.html`
- [ ] （対象外）サポートページ
- [ ] （対象外）`theme_catalog` / 開発者向け docs

## 検証

- [x] `flutter gen-l10n` / `flutter test`（55 passed）
- [ ] 実機・シミュレータで locale=ja / en の目視（任意）
- [x] `lib` のユーザー向けハードコード日本語を確認（正本・採点キー・コメント以外は除去）
