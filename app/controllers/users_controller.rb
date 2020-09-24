class UsersController < ApplicationController
  before_action :set_user, only: [:show,:edit,:destroy,:update,:confirm_approval,:csv_index]
  before_action :logged_in_user, only: [:edit, :index,:destroy, :approval_work_info_upate,:index_attendance,:show]#この中に入れていると入れなくなる,:update
  before_action :correct_user, only: [:approval_work_info_update,:edit]#この中に入れていると入れなくなる:show,
  before_action :admin_user, only: [:destroy, :index_attendance,:index]#,管理者でなければ入れない,:update
  before_action :set_one_month, only: [:show, :confirm_approval,:csv_index]
  #before_action :admin_user_exit,only: [:show]#管理者は入れない
  before_action :self_user,only: [:show]
  
  def index
    if params["name"].blank?
      @users = User.all
      @user = User.find(current_user.id)
###########以下、検索フォーム
    elsif params["name"].present?
      @user = User.where('name LIKE?',"%#{params["name"]}%")
      @users = @user.all
        if @users.blank? 
          flash.now[:danger]="該当者はいません"
          render 'index'
        end
      #redirect_to users_url
    end
  end

  def show
    @worked_sum = @attendances.where.not(keiko_place: nil).count#各々月の合計
    @worked_sums = @user.attendances.where.not(keiko_place: nil).count#総数
###########以下、chart.jsの表示変数
    @month=[]
    (1..12).each do |num|  
      @month << "#{num}月"
    end
###########以下、chart.jsの表示変数
    if params[:date].nil? || (params[:date].to_date.strftime('%Y') == Date.current.strftime('%Y'))
        #@worked_sums_1 = @user.attendances.where("worked_on Like?", "%Date.current.strftime('%Y-01')%").where.not(keiko_place: nil).count
        @worked_sum9 = []
        (1..9).each do |i|
           #@worked_sum9 << "#{@user.attendances.where("worked_on LIKE?", "%#{Date.current.strftime('%Y-'"0#{i}")}%").where.not(keiko_place: nil).count}"
           @worked_sum9 << "#{@user.attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-'"0#{i}")}%").where.not(keiko_place: nil).count}"
           #@worked_sum9 << "%#{Date.current.strftime('%Y-'"0#{i}")}%"
        end
        
        @worked_sum12 = []
        (10..12).each do |i|
          #@worked_sum12 << "#{@user.attendances.where("worked_on LIKE?", "%#{Date.current.strftime('%Y-'"#{i}")}%").where.not(keiko_place: nil).count}"
          @worked_sum12 << "#{@user.attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-'"#{i}")}%").where.not(keiko_place: nil).count}"
          #@worked_sum12 << "%#{Date.current.strftime('%Y-'"#{i}")}%"
        end
        
        @worked_sum_month = @worked_sum9.concat(@worked_sum12)#配列を結合
    elsif (params[:date].to_date.strftime('%Y') != Date.current.strftime('%Y'))
        @worked_sum9 = []
          (1..9).each do |i|
          @worked_sum9 << "#{@user.attendances.where("cast(worked_on as text) LIKE?", "%#{params[:date].to_date.strftime('%Y-'"0#{i}")}%").where.not(keiko_place: nil).count}"
          #worked_sum9 << "#{@user.attendances.where("worked_on LIKE?", "%#{params[:date].to_date.strftime('%Y-'"0#{i}")}%").where.not(keiko_place: nil).count}"
        end
        
        @worked_sum12 = []
          (10..12).each do |i|
          #@worked_sum12 << "#{@user.attendances.where("worked_on LIKE?", "%#{params[:date].to_date.strftime('%Y-'"#{i}")}%").where.not(keiko_place: nil).count}"
          @worked_sum12 << "#{@user.attendances.where("cast(worked_on as text) LIKE?"::text, "%#{params[:date].to_date.strftime('%Y-'"#{i}")}%").where.not(keiko_place: nil).count}"
        end
    
        @worked_sum_month = @worked_sum9.concat(@worked_sum12)#配列を結合
    end
#########以下、お知らせの通知
    @note_attendance =[]
    @day = []
      @note_ids = Attendance.where.not(note: nil).pluck(:id)#管理者が告知しているids
        @note_ids.each do |note_ids|
          @note_attendance << Attendance.find(note_ids)#告知の入っているAttendance
        end
        @note_attendance.each do |day|
          next if day.worked_on < Date.current
          @day << l(day.worked_on, format: :short)#イベントのある日にち
        end
#########以下、お知らせの返事の数
    #@rep_attendance_num = Attendance.where.not(applying: nil).where(worked_on: @attendance.worked_on)

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      current_user.admin?? (redirect_to users_url) : (redirect_to @user)
      #redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

###csv出力
  def csv_index#csv出力
    @attendance = Attendance.find(params[:attendance_id])#@attendance を定義
    @rep_attendance = []
    @rep_attendance = Attendance.where.not(applying: nil).where(worked_on: @attendance.worked_on)
    #上記csvボタン押した時の返事した人のattendance.id
    @at1 = []
    @at2 = []
    @rep_attendance.each do |rep_attendance|
      if rep_attendance.applying == "出場選手"
        @at1 << rep_attendance.user_id
      else
        @at2 << rep_attendance.user_id
      end
    end
   
    respond_to do |format|#ファイルの出力処理
      format.html do#html用の処理を書く
      end 
      format.csv do#csv用の処理を書く
        filename = ERB::Util.url_encode("#{@attendance.worked_on}#{@attendance.note}.csv")#引数に渡された文字列をURLエンコード
        send_data render_to_string, filename: filename, type: :csv#csvデータに変換し、ダウンロードできる
      end
    end
  end

  def csv_import#csvのインポート
    if !params[:file]
      flash[:danger]="ファイルが添付されていません"
      redirect_back(fallback_location: root_path)
    elsif !(params[:file].present? && params[:file].original_filename && File.extname(params[:file].original_filename) == ".csv")
      flash[:danger]="csvファイルを添付してください"
      redirect_back(fallback_location: root_path) and return
    else
    @lists,@csv_success,@csv_fail_emails,@csv_fail_passes,@csv_fail_uids = User.csv_import(params[:file])

      if @csv_success.nil?
        @csv_fail_attri = User.csv_import(params[:file])
          if @csv_fail_attri == ["会員番号は不正な値です"]
            flash[:danger]="登録できません。#{@csv_fail_attri} 入力の値が、半角英数字かどうか確認してください。"
          elsif @csv_fail_emails.blank? && @csv_fail_uids.present? && (@lists.count != @csv_success.count)
            flash[:danger] = "#{@csv_fail_uids} は、すでに、登録もしくは半角数字ではないので、登録できません"#１つ登録
          else
            flash[:danger]="登録できません。#{@csv_fail_attri}が入力ミスです。入力内容が選択肢と同じか,半角数字かどうか確認してください"
          end
        redirect_to users_url and return
      elsif User.get_csv_fail.nil? && @csv_success.class == String#間違い箇所が2つ以上あると、User.csv_import(params[:file])の時、@csv_successに値が入ってしまう。
        @csv_fail_attri = User.csv_import(params[:file])
        flash[:danger]="登録できません。#{@csv_fail_attri}が入力ミスです。入力内容が選択肢と同じか、半角数字かどうか確認してください"
        redirect_to users_url and return
      elsif @csv_success.present? && @csv_success.class == Array
      flash[:success] = "#{@lists.count}件中、#{@csv_success.count}件ユーザー情報をインポートしました"#成功0件
        if @csv_fail_attri == ["会員番号は不正な値です"]
          flash[:danger]="登録できません。#{@csv_fail_attri} 入力の値が、半角英数字かどうか確認してください。"
        elsif @csv_fail_passes.present? && @csv_fail_emails.present? && (@lists.count != @csv_success.count)
          flash[:danger] = "#{@csv_fail_passes}は、パスワード記入がないので登録できません。#{@csv_fail_emails} は、すでに、登録されているので、登録できません"
        elsif @csv_fail_passes.present? && @csv_fail_emails.blank? && (@lists.count != @csv_success.count)
          flash[:danger] = "#{@csv_fail_passes}は、パスワード記入がないので保存できません."
        elsif @csv_fail_emails.present? && @csv_fail_passes.blank? && (@lists.count != @csv_success.count)
          if @csv_fail_uids.blank?
            flash[:danger] = "#{@csv_fail_emails} は、すでに、登録されているので、登録できません"#１つ登録
          end
        elsif @csv_fail_emails.blank? && @csv_fail_uids.present? && (@lists.count != @csv_success.count)
          flash[:danger] = "会員番号の#{@csv_fail_uids} は、すでに、登録されているので、登録できません"#１つ登録
        end
      elsif @csv_success.blank?
        flash[:success] = "#{@lists.count}件、全てインポートできませんでした"
        if @csv_fail_emails.present? && @csv_fail_passes.blank? && (@lists.count != @csv_success.count)
          if @csv_fail_uids.present?
            flash[:danger] = "#{@csv_fail_emails} 、会員番号の#{@csv_fail_uids} は、すでに、登録されているので、登録できません"#１つ登録
          elsif @csv_fail_uids.blank?
            flash[:danger] = "#{@csv_fail_emails} は、すでに、登録されているので、登録できません"#１つ登録
          end
        #elsif @csv_fail_emails.blank? && @csv_fail_uids.present? && (@lists.count != @csv_success.count)
          #if
            #flash[:danger] = "#{@csv_fail_uids} は、すでに、登録もしくは半角数字ではないので、登録できません"#１つ登録
          #end
        end
      end
      redirect_to users_url and return
    end
  end
###稽古出席ページ
  def index_attendance
    #@users = User.all
    if params[:user].blank?
      #@users = User.all
      @users = User.all.where.not(admin: true)
      #@users = User.where.not(admin: true)
    elsif params[:user].present? && params[:user]["name"].blank?
      @users = User.where(affiliation: params[:user]["affiliation"],department: params[:user]["department"])
    elsif params[:user]["name"].present?
      @users = User.where('name LIKE ?', "%#{params[:user]["name"]}%")
    else
      @users = User.where.not(admin: true)
    end
  end

###出席ランキングページ表示
  def index_rank#.limit(10)を最後に入れる
      array = User.where.not(admin: true)#管理者以外で総数を
      users = Hash[ array.map { |user| [user.id,user.attendances.where.not(keiko_place: nil).count] }.to_h.sort_by{ |_, v| -v } ]#降順でハッシュ化{ユーザーid=>総数}
    if params[:user].blank? && params["num"]== "1"#今月
      @users_m = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#降順ハッシュ化{user.id=>今月数}
      @params = params["num"]
      return
    elsif params[:user].blank? && params["num"]== "2"#先月
      @users_lastm = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.last_month.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#降順ハッシュ化{user.id=>先月数}
      @params = params["num"]
      return
    elsif params[:user].blank? && params["num"]== "3"#総数
      @users_sum= users 
      @params = params["num"]
      return
    elsif params[:user].blank?#デフォルトは今月としておく
      @users_m = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}#今月がデフォルト
      @params == "1"
    end
###以下、検索パラメータ
    if params[:user].present? && params[:user]["affiliation"].present? && params[:user]["department"].blank?
      array = User.where.not(admin: true).where(affiliation: params[:user]["affiliation"])#id順にUserが抜粋される。
      users = Hash[ array.map { |user| [user.id,user.attendances.where.not(keiko_place: nil).count] }.to_h.sort_by{ |_, v| -v } ]#(id=>出席数、降順にする)
      if params["num"] == "1"#今月の場合
        @users_m = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "2"#先月の場合
        @users_lastm = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.last_month.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "3"#総数の場合 
        @users_sum = users
      elsif params["num"] == ""
        flash[:danger] = "切り替えを選択してください"
        redirect_to index_rank_users_url and return
      end
    elsif params[:user].present? && params[:user]["affiliation"].blank? && params[:user]["department"].present?
      array = User.where.not(admin: true).where(department: params[:user]["department"])
      users = Hash[ array.map { |user| [user.id,user.attendances.where.not(keiko_place: nil).count] }.to_h.sort_by{ |_, v| -v } ]
      if params["num"] == "1"
        @users_m = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "2"
        @users_lastm = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.last_month.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "3"
        @users_sum = users
      elsif params["num"] == ""
        flash[:danger] = "切り替えを選択してください"
        redirect_to index_rank_users_url and return
      end
    elsif params[:user].present? && params[:user]["affiliation"].present? && params[:user]["department"].present?
      array = User.where.not(admin: true).where(affiliation: params[:user]["affiliation"],department: params[:user]["department"])
      users = Hash[ array.map { |user| [user.id,user.attendances.where.not(keiko_place: nil).count] }.to_h.sort_by{ |_, v| -v } ]
      if params["num"] == "1"
        @users_m = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "2"
        @users_lastm = Hash[ users.map {|user| [user[0],User.find(user[0]).attendances.where("cast(worked_on as text) LIKE?", "%#{Date.current.last_month.strftime('%Y-%m')}%").where.not(keiko_place: nil).count]}.to_h.sort_by{ |_, v| -v }]#ハッシュ化{user.id=>今月数}
      elsif params["num"] == "3"
        @users_sum = users
      elsif params["num"] == ""
        flash[:danger] = "切り替えを選択してください"
        redirect_to index_rank_users_url and return
      end
    elsif params[:user].present? && params[:user]["affiliation"].blank? && params[:user]["department"].blank?
        flash[:danger] = "切り替えと検索項目を選択してください"
        redirect_to index_rank_users_url and return
    else
      @users = []
    end
  end

###出席モーダルページ表示
  def join
    @user = User.find(params[:id])
  end
###モーダルで出席登録ボタンを押したら
  def join_create
    @user = User.find(params[:id])
    attendance_ids = Attendance.where(user_id: @user.id,worked_on: Date.current).ids
    attendance = Attendance.find(attendance_ids[0])
    attendance.update_attributes!(join_params)
    flash[:success]="#{@user.name}さんの #{params["keiko_place"]} の #{params["attendance_class"]} を出席登録しました。"
    redirect_to index_attendance_users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email,:uid,:affiliation,:department,:registration_day,:status,:gender,:password, :password_confirmation)
    end
    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    def join_params
      params.permit(:attendance_class,:keiko_place)
    end
end