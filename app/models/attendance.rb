class Attendance < ApplicationRecord
  belongs_to :user#attendanceはuser配下
  mount_uploader :image, ImageUploader#ImageUploaderと紐づける#「storage:file」と指定していると、public/uploadsに保存される
  
  validates :worked_on, presence: true
  validates :note,  length: { maximum: 50 }

  enum keiko_place: %i(伏見道場 田辺道場 宇治教室 ルネサンス山科教室 出稽古), _prefix: true
  enum attendance_class: %i(少年クラス 一般クラス 選手クラス 朝稽古), _prefix: true
  enum applying: %i(出場選手 会場スタッフ), _prefix: true
end