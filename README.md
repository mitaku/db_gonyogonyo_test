# Railsじゃない環境でいろいろな構想を試すためのリポジトリ

## やりたいこと
 * RailsWayにのってないDBを管理したい => ridgepole
 * rails console的なの欲しい(readonlyでいいけどそこはリテラシーにまかせる)
  * Schemaからモデルを生成する
  * ついでにannotateしたい

基本的に１ショットで終わりなのでこのリポジトリでは雑に作る

## きっかけ
 * Railsのルールにそってない以前からあるシステムのDBをそこそこイジる必要があった
 * ActiveRecordつかってやったほうが楽そうだと判断したため

## 使い方

### 準備

```
bundle install
cp config/database.yml{.example,}
vi config/database.yml
```

### DBのスキーマを作る(Schemafile)

`bundle exec ridgepole -c config/database.yml -E development --export -o Schemafile`

### Schemafileからモデルを生成する

`bundle exec ruby script/model_generator.rb`

app/models配下に作られる

※複数形と単数形が混ざってたりするのでそこは上手くやる...このリポジトリ上では単数形のつもりで扱ってる(init.rb)


### modelにannotateつける

`bundle exec annotate -i -k -f markdown --model-dir app/models -R ./init.rb`

オプションは好みで

### consoleでイジる

`bundle exec ruby script/console.rb`
