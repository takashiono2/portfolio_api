# アプリ名  
道場通信  

# アプリURL    
https://dry-wildwood-10347.herokuapp.com/  
### 使用詳細ドキュメント  
https://docs.google.com/spreadsheets/d/1b1urKRVy7GcrPkJ4GEUTF7rCPK5M1E8eNIGnyLw9fnI/edit?usp=sharing  

# 概要  
習い事管理アプリ  
（空手や柔道、剣道など習い事の自己管理と簡単なお知らせ機能をつけたアプリ。今回は過去に通っていた事もある空手を題材にした）  
### top画面（誰でもスケジュールが見れる）
![top](https://user-images.githubusercontent.com/32084488/95010596-83585580-0665-11eb-99be-f63bd94a537a.jpg)  
### 会報画面（管理者は会員に会報が通知できる）  
![会報](https://user-images.githubusercontent.com/32084488/95010748-cd8e0680-0666-11eb-9447-c1c8bd21e900.jpg)  
### 出席画面（管理者ログインで稽古出席者をチェックすれば会員画面に反映される） 
![出席ボタン](https://user-images.githubusercontent.com/32084488/95010778-0af29400-0667-11eb-9d39-f2f83578fa4f.jpg)  
### 会員画面（出席チェックで出席記録が残る）  
![出席管理](https://user-images.githubusercontent.com/32084488/95010814-59a02e00-0667-11eb-99ae-9664d7d9a7df.jpg)  
### 会員画面（チャートグラフでも出席記録が残る）  
![出席グラフ](https://user-images.githubusercontent.com/32084488/95010864-b13e9980-0667-11eb-95d7-605d34b79ddb.jpg)

# 説明
10年以上前に学生の時に通っていた空手道場。現在も毎月、イベントのお知らせや出来事の感想、稽古スケジュールを道場通信として封筒・紙で郵送されていた事をきっかけに、プリント・印刷・郵送の手間を省くために制作。  
毎月の道場通信の履歴、生徒自身も出席状況の確認ができ、イベントの出席希望確認や、googleカレンダーとの連携で、スケジュールも見開きで確認できる。

# 開発環境　
* Ruby
* Rails
* Github(HTTPSからSSH通信へ変更)
* PostgreSQL(Heroku)  

# 主な使用言語  
Ruby,HTML,CSS,JavaScript

# 使用フレームワーク、ライブラリ、gem 等  
Ruby on Rails  
Jquery
chart-js-rails →グラフ作成のため  
carrierwave →ファイルのアップロードのため  
line-bot-api →LINEのMessageApi使用のため  
aws-sdk →ファイルを保存するawsのS3バケット使用のため  
fog-aws → ファイルをAWSのS3へアップロードするため  
mini_magick →画像のリサイズのため 
  
# バージョン    
Rails 5.1.7  
ruby 2.6.3

# 実装機能  
ログイン機能  
パスワードリセット機能  
稽古スケジュール表示機能（googleカレンダー紐付け）  
稽古場アクセス表示機能  
稽古出席ボタン機能（管理者画面のみ）  
稽古出席ランキング機能（管理者画面のみ）  
イベント通知機能、pdf添付（管理者画面のみ）  
イベント返信者一覧、csv書き出し可（管理者画面のみ）→誰が参加予定か確認できる  
会員一覧編集/削除 機能、csv読み込み可（管理者画面のみ）  
会報新規作成機能、画像添付可（管理者画面のみ）  
会報編集機能（管理者画面のみ）  
会報一覧機能（管理者画面のみ）  
会員キーワード検索機能（管理者画面のみ）  
イベント通知返信機能（一般ユーザー画面のみ）  
イベント資料pdfダウンロード機能  
稽古出席チャート機能（一般ユーザー画面のみ）  
キーワード検索機能  
LINE message Api機能（登録するとLINEから連絡を受けれる、現時点はアプリへのショートカットメニュー掲載）
