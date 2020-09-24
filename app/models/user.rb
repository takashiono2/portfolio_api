class User < ApplicationRecord
  has_many :attendances, dependent: :destroy#Userに属するattendanceたちなので、attendances
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..50 }, allow_blank: true#allow_nil: nillと似ているが、空白でも通す
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 },allow_nil: true#対象がnillの場合通す
  VALID_UID_REGEX = /\A[a-z0-9]+\z/i
  validates :uid,format: { with: VALID_UID_REGEX}, uniqueness:true ,presence: true#allow_blank: true#
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

############以下、importメソッド やり直し
  # def validate_each(record, attribute, value)
  #   unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #     record.errors[attribute] << (options[:message] || "はメールアドレスではありません")
  #   end
  # end

  def self.csv_import(file)
    @csv_success=[]
    @csv_fail_email=[]
    @csv_fail_pass=[]
    @csv_fail_attri=[]
    @csv_fail_attri_blank=[]
    @csv_fail_uid=[]
    @csv_fails=[]

    #@lists=CSV.read(file.path,encoding: 'BOM|UTF-8', headers: true)#ファイルをShift_JISからUTF-8に変換し、headers: trueはcsvファイルの1行目生かし,'r:BOM|UTF-8'
    @lists=CSV.read(file.path,encoding: 'BOM|UTF-8''Shift_JIS:UTF-8', headers: true)#ファイルをShift_JISからUTF-8に変換し、headers: trueはcsvファイルの1行目生かし,'r:BOM|UTF-8'
    @lists.each do |row|
      user = User.new
#binding.pry
#(User.statuses.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["status"].include?(t)})がnil（空）の場合
      if row.to_hash.slice(*updatable_attributes)["gender"].nil? || row.to_hash.slice(*updatable_attributes)["affiliation"].nil? || row.to_hash.slice(*updatable_attributes)["department"].nil? || row.to_hash.slice(*updatable_attributes)["status"].nil? || row.to_hash.slice(*updatable_attributes)["registration_day"].nil?
        @csv_fail_attri_blank << "(空欄)"
      elsif user.invalid? && !(User.genders.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["gender"].include?(t)})
        @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["gender"]
      elsif user.invalid? && !(User.affiliations.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["affiliation"].include?(t)})
        @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["affiliation"]
      elsif user.invalid? && !(User.departments.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["department"].include?(t)})
        @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["department"]
      elsif user.invalid? && !(User.statuses.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["status"].include?(t)})
        @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["status"]
      #elsif user.invalid? && !(User.registration_days.keys.any?{ |t| row.to_hash.slice(*updatable_attributes)["registration_day"].include?(t)})
      elsif user.invalid? && (row.to_hash.slice(*updatable_attributes)["registration_day"].to_s.length != 8)
        @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["registration_day"]
      elsif user.invalid? && (row.to_hash.slice(*updatable_attributes)["registration_day"].to_s.length == 8)
        if !(Date.parse(row.to_hash.slice(*updatable_attributes)["registration_day"]) rescue false) || !Date.parse(row.to_hash.slice(*updatable_attributes)["registration_day"]).year.between?(1990,Time.now.year)
          @csv_fail_attri << row.to_hash.slice(*updatable_attributes)["registration_day"]
        end
      end
    #階級があっていて、メールアドレスがかぶる時、ここでreturnしないと下のuser.attributesで引っかかる
    end
#binding.pry
    if @csv_fail_attri.present?
      return @csv_fail_attri
    elsif @csv_fail_attri_blank.present?
      return @csv_fail_attri_blank
    end
#binding.pry
    #user = User.new
    @lists.each do |row|
      user = User.new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      if User.where(email: user.attributes["email"]).present?#すでにメールアドレスが存在していたら
        @csv_fail_email << user.attributes
      elsif row.to_hash.slice(*updatable_attributes)["password"]==nil
        @csv_fail_pass << user.attributes
      #elsif row.to_hash.slice(*updatable_attributes)["uid"]==row.to_hash.slice(*updatable_attributes)["uid"].upcase
        #@csv_fail_uid << user.attributes
      #elsif row.to_hash.slice(*updatable_attributes)["uid"] != ~ /^[0-9A-Za-z]+$/
        #@csv_fail_uid << user.attributes
      elsif User.where(uid: user.attributes["uid"]).present?
        @csv_fail_uid << user.attributes
      #elsif row.to_hash.slice(*updatable_attributes)["uid"].class == String
        #if User.where(uid: user.attributes["uid"].tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z')).present?
      else
        @csv_success << user.attributes
        begin
          user.save!
        rescue
          return user.errors.full_messages
        end
      end
#binding.pry
    end
#binding.pry
      if @csv_fail_email.present? && @csv_fail_pass.present? && @csv_fail_uid.present?
        @csv_fail_emails = @csv_fail_email.map.with_index(0) {|csv_fail,i| "#{@csv_fail_email[i]["email"]}"}
        @csv_fail_passes = @csv_fail_pass.map.with_index(0) {|csv_fail,i| "#{@csv_fail_pass[i]["name"]}"}
        @csv_fail_uids = @csv_fail_uid.map.with_index(0) {|csv_fail,i| "#{@csv_fail_uid[i]["uid"]}"}
      elsif @csv_fail_email.present? && @csv_fail_pass.blank? && @csv_fail_uid.present?
        @csv_fail_emails = @csv_fail_email.map.with_index(0) {|csv_fail,i| "#{@csv_fail_email[i]["email"]}"}
        @csv_fail_uids = @csv_fail_uid.map.with_index(0) {|csv_fail,i| "#{@csv_fail_uid[i]["uid"]}"}
      elsif @csv_fail_email.blank? && @csv_fail_pass.present? && @csv_fail_uid.present?
        @csv_fail_passes = @csv_fail_pass.map.with_index(0) {|csv_fail,i| "#{@csv_fail_pass[i]["name"]}"}
        @csv_fail_uids = @csv_fail_uid.map.with_index(0) {|csv_fail,i| "#{@csv_fail_uid[i]["uid"]}"}
      elsif @csv_fail_email.present? && @csv_fail_pass.blank? && @csv_fail_uid.blank?
        @csv_fail_emails = @csv_fail_email.map.with_index(0) {|csv_fail,i| "#{@csv_fail_email[i]["email"]}"}
      elsif @csv_fail_email.blank? && @csv_fail_pass.present? && @csv_fail_pass.blank?
        @csv_fail_passes = @csv_fail_pass.map.with_index(0) {|csv_fail,i| "#{@csv_fail_pass[i]["name"]}"}
      elsif @csv_fail_uid.present? && @csv_fail_email.blank? && @csv_fail_pass.blank?
        @csv_fail_uids = @csv_fail_uid.map.with_index(0) {|csv_fail,i| "#{@csv_fail_uid[i]["uid"]}"}
      end
#binding.pry#[@lists,@csv_success,@csv_fail_emails,@csv_fail_passes,@csv_fail_uids]が保たれていない
    return [@lists,@csv_success,@csv_fail_emails,@csv_fail_passes,@csv_fail_uids]
  end

  def self.get_csv#上記でreturnすると取得できない？？
    return [@lists,@csv_success,@csv_fail_emails,@csv_fail_passes,@csv_fail_uids]
  end

  def self.get_csv_fail
    return @get_csv_fail
  end

  def self.get_csv_fail_attri
    return @csv_fail_attri
  end

  def self.get_csv_fail_attri_blank
    return @csv_fail_attri_blank
  end

  def self.updatable_attributes#許可するカラム#2011年1月1日を登録する場合、20110101で登録。３段の数字は半角数字、全角数字は通らない。選択文字は正確に入れないと通らない。
    ["name","email","password","uid","affiliation","department","registration_day","status","gender"]
    #adminはどうする？
  end

###以下、検索フォーム
  def self.search(search)
    return User.all unless search
    User.where(['content LIKE ?', "%#{search}%"])
  end

###以下、enum設定
  enum gender: %i(男性 女性), _prefix: true
  enum affiliation:  %i(伏見道場 田辺道場 宇治教室 ルネサンス山科教室), _prefix: true
  enum department:  %i(一般クラス 少年クラス), _prefix: true
  enum status:  %i(3段 2段 初段 1級 2級 3級 4級 5級 6級 7級 8級 9級 10級), _prefix: true
  enum attendance_class: %i(一般クラス 少年クラス 選手クラス 朝稽古), _prefix: true
  #enum keiko_place: %i(伏見道場 田辺道場 宇治教室 ルネサンス山科教室 出稽古 試合), _prefix: true

###auth0用のtoken
  def self.from_token_payload(payload)
      find_by(sub: payload['sub']) || create!(sub: payload['sub'])
  end
end