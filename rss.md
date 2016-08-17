---
title: Buildy用のフィード
date: 17 Aug 2016
---

Buildy用のフィードはRSS 2.0の方言を使用している。
近日中にAtomに対応する予定なので、もう少々お待ちください。

## RSS 2.0からBuildyのフィードへ

1. 各`<item>`に`<bdy:thumbnail>`を追加

  `bdy:thumbnail`はリストで表示される画像のURLである。

2. 任意: 各`<item>`に`<bdy:image>`を追加

  記事を閲覧する時に表示されるトップ画像である。
  ない場合は、`bdy:thumbnail`が利用される。

3. 任意: 各`<item>`に`<bdy:category>`を追加

  `bdy:category`が既にある場合、一番最初のカテゴリが利用される。
  別のカテゴリを指定したい場合、`<bdy:category>カテゴリの名前</bdy:category>`を追加する。

4. 任意: 各`<item>`に`<bdy:related>`を追加

  関連記事を表示したい場合、`bdy:related`を追加する。

  ```
  <bdy:relatedLink title="関連記事1" link="https://example.com/path/to/article" thumbnail="https://example.com/article/image.jpg" />
  <bdy:relatedLink title="関連記事1" link="https://example.com/path/to/other/article" thumbnail="https://example.com/article/image.jpg" />
  ```

5. 任意: `channel`の下にタブとして表示したいカテゴリを`<bdy:tab>`として追加

  ダッシュボードからこの設定ができるようになるが、動的にアプリのタブを変えたい場合は
  以下の設定が可能となっている。


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

以下の表に入っていない要素が無視される。

### `<channel>`タグ

#### 要素一覧

要素           | 必須 | 複数 | 説明                            | 例
---------------|------|------|---------------------------------|------------------------
`title`        | ○   |      | フィードのタイトル              | クロードテック最新情報
`link`         |      |      | フィードのウェブサイト          | http://claudetech.com
`description`  |      |      | フィードについての説明          | クロードテックの最新情報をお届けします
`language`     |      |      | フィードの言語                  | ja
`ttl`          |      |      | 更新頻度（単位は分）            | 60
`bdy:tab     ` | ○   | ○   | アプリで表示されるカテゴリ      | 以下参照
`item`         |      | ○   | フィードに表示されるコンテンツ  | 以下参照

### `<bdy:tab>`タグ

`<bdy:tab>`はBuildyで表示されるカテゴリを表す。
`<bdy:tab>`が入ってる順番でアプリ内でタブが表示される。

以下の画像のでは、「ニュース」、「エンタメ」、「スポーツ」などのカテゴリが含まれている。

![Tabs](https://images.buildy.jp/app_owner-1/IMG_0748-GWVjBQU.jpg)

##### 要素一覧

要素         | 必須   | 複数 | 説明                                 | 例
-------------|--------|------|--------------------------------------|----------------
`name`       | ○     |      | タブに表示される名前                 | 新着情報
`filter`     |        | ○   | タブに表示されるコンテントのフィルタ | 以下参照

### `filter`タグ

フィルタはカテゴリのタブに表示されるものを制限する。
フィルタが１つもない場合は、すべてのコンテンツが表示される。

##### 属性一覧

要素         | 必須   | 説明                                 | 例
-------------|--------|--------------------------------------|----------------
`operator`   | ○     | フィルタリングに使うオペレーター     | eq

##### 要素一覧

要素         | 必須   | 複数 | 説明                                 | 例
-------------|--------|------|--------------------------------------|----------------
`field`      | ○     |      | フィルタリングに使う`item`の要素     | bdy:category
`value`      | ○     | ○   | `field`と比較するための値            | ニュース

###### `value`について

* `operator`が`eq`の場合は、１つが必要
* `operator`が`in`の場合は、１つ以上が必要

###### 例

`bdy:category`が`ニュース`のもののみ表示する場合は、以下のフィルタが用いられる。

```
<filter operator="eq">
  <field>bdy:category</field>
  <value>ニュース</value>
</filter>
```

### `item`タグ

##### 要素一覧

要素                   | 必須   | 複数 | 説明                                 | 例
-----------------------|--------|------|--------------------------------------|----------------
`title`                | ○     |      | 記事のタイトル                       | 新機能を追加しました
`content:encoded`      | ○     |      | CDATAに入った記事のHTMLコンテンツ    | `<![CDATA[<h1>記事の中身</h1>]]>`
`description`          |        |      | 記事のトップに表示される概要         | `<![CDATA[<h3>8月10日を持って、検索機能を追加しました</h3>]]>。`
`link`                 | ○     |      | 記事のURL                            | http://blog.claudetech.com/?p=38
`bdy:category`         |        |      | 記事のカテゴリの名前                 | ニュース
`bdy:thumbnail`        |        |      | 記事一覧で表示される画像             | https://example.com/thumbnail.png
`bdy:image`            |        |      | 記事閲覧ページで表示される画像       | https://example.com/large-image.png
`bdy:relatedLink`      |        | ○   | 記事閲覧ページに表示される関連記事   | 以下参照


### `bdy:relatedLink`

`bdy:relatedLink`は閲覧ページの下に表示される関連記事を指定する。

##### 属性一覧

属性                   | 必須 | 説明                                 | 例
-----------------------|------|--------------------------------------|----------------
`title`                | ○   | 関連記事のタイトル                   | 新機能を追加しました
`thumbnail`            | ○   | 関連記事のサムネイル画像             | https://example.com/thumbnail.png
`link`                 | ○   | 関連記事のリンク                     | http://blog.claudetech.com/articles/2
