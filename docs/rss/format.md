# Buildy用のフィードについて

Buildyでは、RSSフィードを用いることで、
コンテンツをアプリに同期できるようになっています。
本ページでは、Buildy用RSSフィードの仕様について説明いたします。

Buildy用RSSフィードはRSS 2.0を元に作成しております。
近日中にAtomにも対応する予定ですので、少しばかりお待ちください。

サンプルフィードは[こちら](./sample.md)をご覧ください。

## XMLネームスペース

RSSドキュメントが以下の２つのネームスペースを定義する必要があります。

* `xmlns:bdy="https://docs.buildy.jp/rss/format/"`
* `xmlns:content="http://purl.org/rss/1.0/modules/content/"`

追加方法について、[サンプル](./sample)をご確認ください。

## RSS 2.0からBuildy用RSSフィードへの変更手順

### `<item>`の変更

1. 各`<item>`に`<bdy:thumbnail>`を追加

    `bdy:thumbnail`は記事一覧ページで表示される画像のURLになります。

2. 各`<item>`に`<bdy:category>`を追加

    記事のカテゴリになります。
    `category`が既にある場合、`category`の一番最初のカテゴリが利用されます。
    `category`と別のカテゴリを指定したい場合、`<bdy:category>カテゴリの名前</bdy:category>`を追加してください。

3. 任意: 各`<item>`に`<bdy:image>`を追加

    記事閲覧ページの上部に表示されるトップ画像です。
    このタグがない場合は、`bdy:thumbnail`が利用されます。

4. 任意: 各`<item>`に`<bdy:relatedLink>`を追加

    記事閲覧ページの下部に関連記事を表示する場合、`bdy:relatedLink`を追加してください。

```xml
<bdy:relatedLink title="関連記事1" link="https://example.com/path/to/article" thumbnail="https://example.com/article/image.jpg" />
<bdy:relatedLink title="関連記事2" link="https://example.com/path/to/other/article" thumbnail="https://example.com/article/image.jpg" />
```

### `<channel>`の変更

1. 任意: `channel`の下に`<bdy:tab>`を追加

    `channel`直下に`<bdy:tab>`を追加することで
    記事一覧ページでのタブ（上部にある「トップ」「エンタメ」等）を定義することができます。
    基本的にダッシュボードからこの設定ができるようになりますが、
    動的にこれらのタブを変えたい場合は、以下のように設定ができます。


```html
  <!-- channelの下 -->
  <bdy:tab>
    <title>トップ</title>
  </bdy:tab>
  <bdy:tab>
    <title>新規情報</title>
    <filter operator="eq">
      <field>bdy:category</field>
      <value>新規情報</value>
    </filter>
  </bdy:tab>
```


## ドキュメンテーション

以下の表に入っていない要素は無視されます。

### `<channel>`タグ

#### 要素一覧

要素           | 必須 | 複数 | 説明                                            | 例
---------------|------|------|-------------------------------------------------|------------------------
`title`        | ○   |      | RSSフィードのタイトル                           | クロードテック最新情報
`link`         |      |      | RSSフィードのウェブサイト                       | http://claudetech.com
`description`  |      |      | RSSフィードについての説明                       | クロードテックの最新情報をお届けします
`language`     |      |      | RSSフィードの言語                               | ja
`ttl`          |      |      | RSSフィードにアクセスしてコンテンツをアプリに同期する頻度（単位は分） | 60
`pubDate`      |      |      | 最終更新日時                                    | Thu, 30 Jun 2016 10:33:06 +0000
`bdy:tab     ` |      | ○   | アプリ内の記事一覧ページで表示されるタブ名      | 以下参照
`item`         |      | ○   | アプリ内の記事一覧ページに表示されるコンテンツ  | 以下参照

### `<bdy:tab>`タグ

`<bdy:tab>`はアプリ内の記事一覧ページの上部で表示されるタブを表します。
`<bdy:tab>`が入ってる順番がアプリ内のタブの順番になります。

下の画像のアプリでは、「ニュース」、「エンタメ」、「スポーツ」などのタブが含まれています。

![Tabs](https://images.buildy.jp/app_owner-1/IMG_0748-GWVjBQU.jpg)

##### `<bdy:tab>`タグ内の要素一覧

要素         | 必須   | 複数 | 説明                                 | 例
-------------|--------|------|--------------------------------------|----------------
`name`       | ○     |      | タブに表示される名前                 | 新着情報
`filter`     |        | ○   | タブに表示される記事のフィルタ | 以下参照

### `filter`タグ

フィルタはタブに表示される記事を制限するために使用します。
フィルタが１つもない場合は、すべてのコンテンツが表示されます。

##### 属性一覧

要素         | 必須   | 説明                                 | 例
-------------|--------|--------------------------------------|----------------
`operator`   | ○     | フィルタリングに使うオペレーター     | eq

##### 要素一覧

要素         | 必須   | 複数 | 説明                                 | 例
-------------|--------|------|--------------------------------------|----------------
`field`      | ○     |      | フィルタリングに使う`item`の要素     | bdy:category
`value`      | ○     | ○   | `field`と比較するための値            | ニュース

###### `value`の数について

* `operator`が`eq`の場合は、１つだけ必要
* `operator`が`in`の場合は、１つ以上が必要

###### 例

`bdy:category`が`ニュース`の記事のみ表示する場合は、以下のフィルタが用いられます。

```
<filter operator="eq">
  <field>bdy:category</field>
  <value>ニュース</value>
</filter>
```

### `item`タグ

##### `item`タグの要素一覧

要素                   | 必須   | 複数 | 説明                                   | 例
-----------------------|--------|------|----------------------------------------|----------------
`title`                | ○     |      | 記事のタイトル                         | 新機能を追加しました
`content:encoded`      | ○     |      | エンコードされた記事のHTMLコンテンツ   | `<![CDATA[<h1>記事の中身</h1>]]>`
`description`          |        |      | 記事閲覧ページの上部に表示される概要   | `<![CDATA[<h3>8月10日を持って、検索機能を追加しました</h3>]]>。`
`link`                 | ○     |      | 記事のURL                            | http://blog.claudetech.com/?p=38
`bdy:category`         |        |      | 記事のカテゴリの名前                 | ニュース
`bdy:thumbnail`        |        |      | 記事一覧ページで表示される画像             | https://example.com/thumbnail.png
`bdy:image`            |        |      | 記事閲覧ページで表示される画像       | https://example.com/large-image.png
`bdy:relatedLink`      |        | ○   | 記事閲覧ページに表示される関連記事   | 以下参照


### `bdy:relatedLink`タグ

`bdy:relatedLink`を用いることで記事閲覧ページの下部に表示する関連記事を指定できます。

##### 属性一覧

属性                   | 必須 | 説明                                 | 例
-----------------------|------|--------------------------------------|----------------
`title`                | ○   | 関連記事のタイトル                   | 新機能を追加しました
`thumbnail`            | ○   | 関連記事のサムネイル画像             | https://example.com/thumbnail.png
`link`                 | ○   | 関連記事のリンク                     | http://blog.claudetech.com/articles/2
