class AttendancesController < ApplicationController
  include AttendancesHelper
  #protect_from_forgery except: :attendance_params
  before_action :set_attendance, only: [:request_work_info,:request_work_info_update]
  before_action :logged_in_user, only: [:update]
  before_action :set_one_month, only: [:log]
  before_action :correct_user, only: [:edit_one_month]#この中に入れていると入れなくなる:edit,:update,:request_work_info_update
  require 'aws-sdk'
  
  def update
  end

##########

  def request_work_info
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
  end

  def request_work_info_update#参加募集イベントボタン押した時
    if params["check"].present?#@attendance.id ユーザーは誰でもいい。Attendance.where.not(worked_on: @attendance.worked_on)
      @attendance.note = nil#管理者のイベント名を削除
      @attendance.remove_image!
      @attendance_ids = []
      @attendance_ids = Attendance.where(worked_on: @attendance.worked_on).where.not(applying: nil).pluck(:id)#参加申請したユーザーのid
        @attendance_ids.each do |attendance_ids|
          @attendance_applying = Attendance.find(attendance_ids)
          @attendance_applying.applying = nil#ユーザー側を削除
          @attendance_applying.save
        end
      @attendance.save       
      flash[:success] = "#{@attendance.worked_on}の予定は「削除」しました。"
    elsif request_params["note"].present? && params[:attendance]["check"].blank? && request_params["image"].present?
      @attendance.update_attributes!(note: request_params["note"],image: request_params["image"])
      flash[:success] = "#{@attendance.worked_on}の予定を「登録」しました。"  
    elsif request_params["note"].present? && (request_params["note"].length >= 50) && params[:attendance]["check"].blank?
      flash[:danger] = "登録できませんでした、50文字以内で入力してください"
    elsif request_params["note"].present? && params[:attendance]["check"].blank?
      @attendance.update_attributes(note: request_params["note"])
      flash[:success] = "#{@attendance.worked_on}の予定を「登録」しました。"
    else
      flash[:danger] = "登録できませんでした、入力し直してください"
    end
  redirect_to @user
  end

  def approval_work_info#通知のお知らせ押したら
    @note_attendance =[]
      @note_ids = Attendance.where.not(note: nil).pluck(:id)#管理者が告知しているids
      @note_ids.each do |note_ids|
        @note_attendance << Attendance.find(note_ids)
      end
    @day = []  
    @note_attendance.each do |day|
      @day << l(day.worked_on, format: :short)#イベントのある日にち(管理者が告知している日)
    end
    
###以下、表示制限条件  
    @attendance = Attendance.find(params[:day_id])#ユーザーが表示しているattendance
    @user_admin_id = User.find_by(admin: true).id#管理者id
    @attendance_day_id = Attendance.where(worked_on: @attendance.worked_on,user_id: @user_admin_id).ids[0]#ここでフィルタリング、管理者イベントattendance.id
  end
    
  def approval_work_info_update#通知ボタン押したら参加申請
    if params[:attendances].values[0]["applying"].present?
        @user = User.find(params[:id])
        params[:attendances].each do |id, item|#id:イベントの日にちの管理者のid、item:参加内容
          #next if params[:check][id] != ["true"]
          attendance = Attendance.find(id)
          @attendance_id = @user.attendances.where(worked_on: attendance.worked_on).pluck(:id)#申請者のattendance.id
          @attendance = Attendance.find(@attendance_id[0])
          @attendance.applying = params[:attendances].values[0]["applying"]
          @attendance.save
          flash[:success]="通知しました。" 
          redirect_to user_url
        end
    elsif params[:attendances].values[0]["applying"].blank?
      flash[:danger]="登録できません、選択して送信してください。" 
      redirect_to user_url and return
    end
  end

  def download#アップロードしたpdfをダウンロード
    @attendance = Attendance.find(params[:id])
    data = open(URI.encode("https://dojoportfolio.s3-us-west-2.amazonaws.com/#{@attendance.image.path}"))
    
    #File.open(@attendance.image.identifier, "wb+") do |f|
      #f.puts Base64.decode64(URI.encode("https://dojoportfolio.s3-us-west-2.amazonaws.com/#{@attendance.image.path}"))
    #end

    #@file = File.open(@attendance.image.identifier, 'rb')
    #@file = "https://dojoportfolio.s3-us-west-2.amazonaws.com/#{@attendance.image.path}"
    
    #send_file @file, :filename => @report_name, :type => "application/pdf; charset=utf-8", :disposition => "attachment"
    send_data data.read,filename: "#{@attendance.image.identifier}", type: "application/pdf",disposition: 'attachment', stream: 'true', buffer_size: '4096'

  end
   
  def confirm_approval#返事人数確認モダールページ
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:user_id])
    @rep_attendance = []
    #@rep_attendance = Attendance.where.not(applying: nil)#返事のattendanceたち
    @rep_attendance = Attendance.where.not(applying: nil).where(worked_on: @attendance.worked_on)#返事で日にちが同じattendanceたち
  end

  def destroy#イベント削除時（attendance.id残し）
    # @user = User.find(params[:user_id])
    # @attendance = Attendance.find(params[:id])
    # @attendance.update_attributes(note: nil)
    # flash[:success] = "#{@attendance.worked_on}の予定を削除しました。"
    # redirect_to user_url
  end

  private

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?#@userは空ではないならユーザーidを持って
      unless current_user?(@user) || current_user.admin?#今ログインユーザーが入っていきたユーザーならtrueもしくは管理者ならtrueでないなら（どっちもtrueでないなら）
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
    
    def request_params
      params.require(:attendance).permit(:note,:image)
    end
  
    # def s3_client
    #   Aws::S3::Client.new(
    #     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    #     secret_access_key: ENV['AWS_SECRET_KEY_ID'],
    #     region: ENV['AWS_REGION']
    # )
    # end
end