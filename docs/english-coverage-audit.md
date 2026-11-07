# 英語対応 全体精査（2026-11-07）

端末が `ja` → 日本語、それ以外 → 英語（[`lib/utils/locale_utils.dart`](../lib/utils/locale_utils.dart)）。

## できている

| 領域 | 状態 |
| --- | --- |
| ARB `app_ja` / `app_en` | キー同数。画面シェルは l10n |
| 問題本文 85問 | EN オーバーレイ完備（theme〜explanation） |
| ドメイン名・キーパッド文言 | ARB |
| ネイティブ表示名 | Android `values-en` / iOS `en.lproj` |

## 今回直したギャップ

| 項目 | 対応 |
| --- | --- |
| 図ラベル直書き（空気／自然長／直径／巻数／電流／1年） | `FigureLabels` + ARB |
| 単位表示 `個` / `年` | 表示のみ `count` / `yr`（採点キーは変更なし） |
| 公式集 | 英語時はガチャのアイコン導線を非表示 |
| AI チャット文言 | 起動時の `AppLocalizations` を `PhysicsAiChatPorts` に渡す |
| ドメイン結合 | 英語は `, ` |

図ラベルの目視トラッカー: [`figure-en-checklist.md`](figure-en-checklist.md)

## 残（意図的／低優先）

| 項目 | 扱い |
| --- | --- |
| 公式集 PDF 本体 | 日本語のみ。英語導線なし |
| カタログ PDF（`tool/export_problem_catalog.dart`） | 開発用・ユーザー画面外 |
| プライバシー／サポート HTML | 既存どおり対象外 |
| 採点キー `無次元` / `個` / `年` | 内部キー。表示は l10n |

## 関連

- [`i18n-checklist.md`](i18n-checklist.md)
- [`figure-en-checklist.md`](figure-en-checklist.md)
