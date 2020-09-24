class LinebotController < ApplicationController  
  require 'line/bot'  # gem 'line-bot-api'  

  # callbackアクションのCSRFトークン認証を無効 （偽装防止要求）（決まり）
  protect_from_forgery :except => [:callback]  
##以下、友達登録
  def client#Line Deveroper登録完成後に作成される環境変数の認証
    @client ||= Line::Bot::Client.new { |config|  
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]  
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]  
    }
  end

  def callback#ルーティング post '/callback' => 'linebot#callback'
    body = request.body.read#リクエストモジュールの説明https://www.sejuku.net/blog/73698
    
    signature = request.env['HTTP_X_LINE_SIGNATURE']#署名検証（決まり）
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)#リクエストボディをパース（解釈）する。つまり、リクエストから必要な情報を取得し、以下でレスポンス文字列の作成

    events.each { |event|
      case event#case変数1 when値1 つまり、event変数が指定した値1の時に　プログラムを実行。「Message」（メッセージ受信）「unfollow」(ブロック)「follow」（友達追加）「postback」（ボタン 操作）
      when Line::Bot::Event::Message
        case event.type#メッセージタイプは、「Text」「sticker」「image」「video」など
        when Line::Bot::Event::MessageType::Text
          if event.message['text']=="1"# 外部から（event）送られてきたメッセージevent.messageが'1'なら、templateを返す
            client.reply_message(event['replyToken'], template)#返信時に第2引数を実行
          elsif event.message['text']=='2'# 外部から（event）送られてきたメッセージevent.messageが'2'なら、messageを返す
            client.reply_message(event['replyToken'], message)
          end
        end
      end
    }
    head :ok
  end

  private

  def template
     {
      "type": "template",
      "altText": "This is a buttons template",
      "template": {
            "type": "buttons",
            "imageBackgroundColor": "#FFFFFF",
            "title": "メニュー",
            "text": "選んでください",
            "actions":[ 
              {
                "type": "uri",
                "label": "スケジュール",
                "uri": "https://calendar.google.com/calendar/embed?src=20gta0oth9rl0djd22rljileu4%40group.calendar.google.com&ctz=Asia%2FTokyo"
              },
              {
                "type": "uri",
                "label": "道場通信ログイン",
                "uri": "https://dry-wildwood-10347.herokuapp.com/login"
              },
              {
                "type": "uri",
                "label": "京都南支部ホームページ",
                "uri": "https://www.kyotokarate.com/"
              },
              {
                "type": "uri",
                "label": "稽古場所アクセス",
                "uri": "https://dry-wildwood-10347.herokuapp.com/access"
              }
              # {
              #   "type": "uri",
              #   "label": "本部公式ホームページ",
              #   "uri": "http://www.shinkyokushinkai.co.jp/"
              # }#4つまでしか登録できない
            ]
          }
        }
  end

  def message
      {
        type: "text",
        text: "http://www.shinkyokushinkai.co.jp/"
      }
  end
end