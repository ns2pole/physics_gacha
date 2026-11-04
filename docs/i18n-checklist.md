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

## 問題コンテンツ（85問）

各問: title / statement / hint / approach / firstStep / explanation / theme
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
- [x] ab68af64-b6f1-4a0b-b27d-9c8da85c2075
- [x] 355ab9b8-5510-4ab9-be24-4ffb0e0d3d2a
- [x] 16e3da14-71f7-4691-9997-ee15a8209c5e
- [x] 6970d4b5-abcd-4825-a0fd-fc210892bc2f
- [x] 3f04e9ee-5b10-44b3-959a-8066a139be9d
- [x] 3587cf2f-0e4c-44bf-a255-4413086cf0c9
- [x] 03565785-cd7a-4353-bd44-ff3879ea6935
- [x] ad238071-a49c-4825-99a7-29c217b9fd0c
- [x] 990f59e0-b900-4224-8c81-42e9d3e147c7
- [x] f5c795da-e888-4d9a-bb13-03b190638904
- [x] 2c769ccf-20fe-4de8-a0dc-f98eb5d7e824
- [x] ee55e3b5-6de2-4c75-8536-e772727beff3
- [x] ea751b97-55c2-4363-a575-5d8fdc5cc9a7
- [x] 4dc4c30e-cd7d-4453-abc4-4f653c9076f3
- [x] 1de21279-b406-41f8-a86d-4da5a47293f9
- [x] 2984b8a0-e30c-4106-8dbe-4d790b4bde61
- [x] 960df344-a24b-4174-821c-9ddbcdce5631
- [x] 12398171-259c-413a-ac28-a86b2cb81ff2
- [x] 0527566c-8c16-4294-a46c-a1acd1030f51
- [x] 6a8376a3-ce81-44e9-bc20-f12f357ee369
- [x] 66546af1-dd8b-42fd-826e-208119255735
- [x] a0c33208-8b92-4fb2-8bab-b4b7bb4190d2
- [x] 9754d70d-66f6-4c2d-b2fc-2e47ff967a8e
- [x] 385afc33-7632-45e7-b510-6a09360679d3
- [x] d2bd1250-0b63-4c72-80cb-836221903063
- [x] c903ff0f-db40-4916-8ed4-5c4a656dc9f1
- [x] 7da18bc0-3810-4a32-8930-0e17ba16efce
- [x] 19776c8b-24cd-4aaf-95ab-5a5097ed7055
- [x] 80b5bc83-b93e-402a-b658-be4cc879795a
- [x] d09b53dc-125f-4a38-8908-9911d635cb8e
- [x] b5640d96-7b77-4993-ac9a-b8969461b744
- [x] e5bc3b07-2a24-49d0-9cf3-f6e03c9b6c8f
- [x] fccf9e77-372c-4c34-b17d-9cafc2d339b5
- [x] b7c1e735-bbda-461c-a72e-eff2609a5ab1
- [x] 760c69d1-1a7e-41f8-b18f-8b7ac39735a4
- [x] 3161b116-b09a-4d0b-b92d-44cd0d46a4a4
- [x] b29b25dc-cde4-4e27-ade8-bfb66af29ad3
- [x] b775e759-f47a-40ad-9506-762bd7e1b158
- [x] 04aa630e-a4c3-46ee-918c-531536db9665
- [x] dc2ea26c-266e-4441-96b7-a9a514e3b799
- [x] 264dc236-782b-4ba0-9d39-13c94f7ea889
- [x] fb52940c-6b53-4c80-a4a3-639e2aa650ef
- [x] a9200667-eb7b-4eb0-8b3b-ecf7e4adfc0b
- [x] 5c3c97ec-01f2-4eb6-a717-6099182aa327
- [x] 6ede92dc-5a1f-45dd-8bd5-aad99c9ea5da
- [x] b2264701-1475-4352-a05d-e5271f77caff
- [x] cc8cd992-df30-4283-b758-2c7bba07336a
- [x] ebf0977f-94f9-4e30-8415-95fe3b05b3c2
- [x] 185ad466-4a2a-474a-97d8-e2635c9da116
- [x] 6302cba4-20d1-418d-bcd4-8bc9139112ef
- [x] 3ea78b46-ce98-4631-8e40-d6adaffd4c92
- [x] fec7eb08-b848-4ce9-86f1-bfcf489ed905
- [x] 4f720ff4-0c1b-47ff-baa6-70195e82f7bb
- [x] 8b3abed0-2226-49ed-9b04-7c3d63852077
- [x] cbde552e-65b9-4102-a827-92de2ea4d513
- [x] d9ed9c59-ef5b-4880-b07d-320542a4c373

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
- [x] beats（100 Hz / 104 Hz、数値のみ）
- [x] seriesSprings（数値のみ）
- [x] parallelSprings（数値のみ）
- [x] resonanceColumn（l のみ）
- [x] chargedCapacitor（1000 μF / 18 V、数値のみ）
- [x] parallelPlateCapacitor（10 cm / 1 mm、数値のみ）
- [x] dielectricCapacitor（10 cm / 0.1 mm / ε_r、数値のみ）
- [x] metalInsertCapacitor（10 cm / 0.2 mm / 0.3 mm、数値のみ）
- [x] parallelCapacitors（10 μF / 22 μF / 68 μF、数値のみ）
- [x] cavendishTorsion（置く前／置いた後、数値）
- [x] moonOrbit（地球、月）
- [x] sunOrbit（太陽、地球）
- [x] longThrow（45°、90 m、数値のみ）
- [x] evacuatedCylinder（はじめ／あと、数値）
- [x] note記事の39図（数値と単位。壁の速さ、スリット、回折格子、弦、円錐振り子、スピーカー、気柱、ばね、台車、振り子、ブロック、円盤、下敷き、滑りと傾き、浮き、山頂、摩擦、回転台、エレベーター、釘、水中、張力、階段、富士山、注射器、水深、逆さ容器、食塩水、ヘリウム、ニクロム、銅線、コイル、RC、ソレノイド、アルミ棒、立方体）

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

- [x] `flutter gen-l10n` / `flutter test`（57 passed）
- [ ] 実機・シミュレータで locale=ja / en の目視（任意）
- [x] `lib` のユーザー向けハードコード日本語を確認（正本・採点キー・コメント以外は除去）
