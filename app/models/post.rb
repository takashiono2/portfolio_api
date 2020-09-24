class Post < ApplicationRecord
  has_many :thumbnails, dependent: :destroy
  #has_many_attached :thumbnails
  accepts_nested_attributes_for :thumbnails,allow_destroy: true#ネスとされたサムネイルを投稿できる様になる
  mount_uploader :image, ImageUploader
  #belongs_to :user,optional: true
  #VALID_NUM_REGEX = /\A[0-9]+\z/
  validates :post_num, presence: true,uniqueness: true#, length: { maximum: 3 }, numericality: { only_integer: true},format: { with: VALID_NUM_REGEX }
  validates :post_title, presence: true,length: { maximum: 30 }
  validates :post_note, presence: true
  serialize :image#テーブルやカラムを追加しなくても自由に保存できる
  #serialize :image, JSON
end