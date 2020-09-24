class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception#自動的にセキュリティートークンを含める
  include SessionsHelper
  $days_of_the_week = %w{日 月 火 水 木 金 土}#%w{}はリテラス表記で配列と同じなので、["月","火",・・・,"土"]と同じ意味
  
  def set_user
    @user = User.find(params[:id])#パラメータからユーザーを取得する
  end
  
  def logged_in_user
    unless logged_in?#ログインしてなければtrue
      store_location#sessionヘルパー参照
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  def correct_user
    unless current_user?(@user)
      flash[:danger]="権限がありません"
      redirect_to(root_url)
    end
  end

  def admin_user
    if !current_user.admin?
      flash[:danger]="権限がありません"
      redirect_to root_url
    end
  end
  
  def admin_user_exit
    if current_user.admin?#管理者ならば、ホームへ
      flash[:danger]="権限がありません"
      redirect_to root_url
    end
  end
  
  def self_user#他人のidページには移れない 
    if @user.id != current_user.id
      flash[:danger]="権限がありません"
      redirect_to root_url
    end
  end
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    #三項演算子パラメータdateキーが空なら、月初をとるもしくはとってきたパラメータキーをfirstdayにする
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
  
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    #where(カラム: 条件)で検索つまりユーザーにひもづく1ヶ月分のデータを検索、1対多なので、attendancesは複数形※user.rbファイルで定義している。
    unless one_month.count == @attendances.count#unlessはfalseの場合だけ内部処理をする。ユーザーの勤務データと一ヶ月の日数が一致しないなら
      ActiveRecord::Base.transaction do#例外処理をする
        one_month.each { |day| @user.attendances.create!(worked_on: day) }#one_monthからdayに1日ずつ入ってworkded_onに入ったAttendanceモデルのデータがcreateで生成される
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

  def set_attendance
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
  end
  
  def hello  
    render html: "hello, world!"  
  end  
end