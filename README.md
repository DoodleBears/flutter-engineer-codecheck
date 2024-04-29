# 取り組み説明
## [Video Demos](https://drive.google.com/drive/folders/1VXvK5dELFEW-RD6UB0F6Yxy36O4wF7V9?usp=sharing)

## 概要
- Prototype UI/UX design is done using Figma
- Git branching rule
   - Issue with corresponding feature branch (or "..." branch)
- Commit rule
  - atomic commit (as small as possible)
  - feature based (new feature)
  - file based (small fix)
  - message follow template: `tag(range): message`
- Issue description includes
  - prototype design image
  - todo (check list for key implementation)
  - reference for execute and development
- Pull request description includes
  - related issue
  - what have been done
  - video demo (if needed)
- Dependency
  - `http` for network request
  - `flutter_riverpod` for state management
  - `json_annotation` for dataclass generation
  - `logger` for logging
- Dev dependency
  - `mockito` for test
  - `json_serializable` for dataclass generation
  - `build_runner` for l10n and dataclass generation

## Folder Structure
- `l10n/`: for localization
- `models/`: for dataclass
- `pages/`: for View (UI)
- `state/`: for state management
- `api/`: for requesting backend
- `test/`: for test
- `test_resource/`: for test resource

## About AI Service
- 50% ~ code is written by `Cursor` (w/gpt-4-turbo-2024-04-09 and claude-3-opus-20240229)
- ChatGPT (GPT-4) also be used in

## Time Spent (**16 hours**)

### Coding: 13.5 hours

- Unit Test: **6 hours**
- View (UI) and Logic (API): **4.5 hours**
- l10n: **1 hour**
- Config: **1 hour**
- Refactor: **1 hour**

### Search & Learn: 2.5 hours


# 株式会社ゆめみ Flutter エンジニアコードチェック課題

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に Flutter エンジニアを希望する方に出す課題用のプロジェクトです。 本課題が与えられた方は、以下を詳しく読んだ上で課題に取り組んでください。

## 概要

以下の要件を満たす、Android・iOS で動作するアプリを Flutter で作成してください。

## 要件

### 環境

- IDE・SDK・プログラミング言語については、基本的に最新の安定版を利用すること
- 最新の安定版以外を利用する場合は、理由も含めて README に記載すること
- 状態管理パッケージには Provider/Riverpod のいずれかを使うこと
- サードパーティーライブラリについては、オープンソースのものに限り制限しない

### 対象 OS バージョン

基本的に Flutter プロジェクト作成時のバージョンにすること

|         | OS Version |
|---------|------------|
| iOS     | 9.0 ~ 15.2 |
| Android | 4.1 ~ 12   |

※ 本プロジェクト更新時点

### 動作

- 何かしらのキーワードを入力できる
- 入力したキーワードで GitHub のリポジトリを検索できる
- GitHub のリポジトリを検索する際、GitHub API（[`search/repositories`](https://docs.github.com/ja/rest/reference/search#search-repositories)）を利用する
  - [github | Dart Package](https://pub.dev/packages/github) のようなパッケージは利用せず、API を呼ぶ処理を自分で実装すること
- 検索結果は一覧で概要（リポジトリ名）を表示する
- 検索結果のアイテムをタップしたら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示する

### デザイン

マテリアルデザインに準拠すること

## 提出方法

- GitHub の public リポジトリの URL をお知らせください
- 別の方法で提出する場合はご相談ください（Git のコミット履歴が分かる形式が望ましいです）
- この課題とは別のコード(ご自身で公開されているOSS等)をもって課題の提出とすることをご希望の場合はご相談ください

## 評価ポイント

- レビューのしやすさ
  - README の充実
  - 適切なコメント
  - GitHub のプルリクエスト機能などの利用
- Git
  - 適切な gitignore の設定
  - 適切なコミット粒度
  - 適切なブランチ運用
- 簡潔性・可読性・安全性・保守性の高いコード
- Dart の言語機能を適切に使いこなせているか
- テスト
  - テストが導入しやすい構成
  - Unit・UI テストがある
- UI/UX
  - エラー発生時の処理
  - 画面回転・様々な画面サイズ対応
  - Theme の適切な利用・ダークモードの対応
  - 多言語対応
  - アニメーションなど
- CI/CD
  - ビルド
  - テスト
  - リント
  - フォーマット
  - 仮のデプロイ環境

上記以外でも高く評価できるポイントがあれば同等に考慮します。

アピールする点があれば、README に箇条書きなどで記載してください。

## 参考記事

評価ポイントについて詳しくまとめた記事がありますので、ぜひご覧ください。

- [私が（iOS エンジニアの）採用でコードチェックする時何を見ているのか](https://qiita.com/lovee/items/d76c68341ec3e7beb611)
- [ゆめみの Android の採用コーディング試験を公開しました](https://qiita.com/blendthink/items/aa70b8b3106fb4e3555f)

## AI サービスの利用について

ChatGPT等のAIサービスを利用することは、禁止しておりません。

利用にあたって工夫したプロンプトやソースコメント等をご提出頂くことで、加点評価する場合もあります。(減点評価はありません)

また、弊社コードチェック担当者もAIサービスを利用させていただく場合があります。
AIサービスの利用は差し控えてもらいたい等のご要望があれば、お気軽にお知らせください。

## Mac をお持ちでない場合について

Mac をお持ちでない場合は課題提出時にその旨お伝えください。
iOS に関連するコード、動作をレビュー対象から除外いたします。
