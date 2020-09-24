class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
   include CarrierWave::MiniMagick#リサイズ、画像形式を変更に必要。MiniMagickを使う事を宣言。

  # Choose what kind of storage to use for this uploader:
  #storage :file
  #上記でpublic配下に保存させる
  # storage :fog

  #if Rails.env.development?
    #storage :file
  #elsif Rails.env.test?
    #storage :file
  #else
    storage :fog
  #end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #以下、アップロード先"uploads/モデル/カラム/id"
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  #上記で保存されるディレクトリを設定する
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #process resize_to_limit: [600,800]
  
  #version :thumb do
   #process resize_to_fit: [50,50]#もしくは、process :resize_to_limit[50,50]サムネイル生成時。limitはサイズ以下の場合は、リサイズしない。
   #process quality: 90
  #end


  version :thumb, if: :is_thumb?
  version :thumb do
    process resize_to_limit: [600, 800]
  end

  #process quality: 95
  
  ###参考 https://srcw.net/wiki/?CarrierWave
  # version :m do
  #   process resize_to_limit: [600, 800]
  #   process quality: 90
  #   process :unsharp_mask => [2, 1.4, 0.5, 0]
  # end

  #process :optimize => [{ quality: 90 }]
  
  #上限変更process :resize_to_limit => [700, 700]#fitは画像比を維持したまま,limitは上限までは同じ比率で

    #携帯は375＊667
  #以下、画質
  # if File.extname(original_filename) == '.pdf'
  #   process :quality => 95
  # end
  #version :small do
    #process resize_to_fill: [150, 150]#切り抜きfill(width,height,gravity)画像一覧向き
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_whitelist#添付可能な拡張子
     %w(jpg jpeg gif png pdf)
   end
  # 拡張子をjpg,jpeg,gif,png、pdfのみに制限
  
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
     #"something.jpg" if original_filename
    "#{original_filename}" if original_filename.present?
    #{original_filename}.#{file.extension}" if original_filename.present?
  end


#JPGで保存 (注)ここをjpg指定しているとpdf指定されない
  #process :convert => 'jpg'
  #process convert: 'jpg'

#ファイル名を変更し拡張子を同じにする
  #def filename
    #super.chomp(File.extname(super)) + '.jpg' 
  #end

#アップロードの日付で保存
  #def filename
    #if original_filename.present?
      #time = Time.now
      #name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
      #name.downcase
    #end
  #end
  
  #def filename#オリジナルファイル名
    #"#{secure_token}.#{file.extension}" if original_filename.present?
  #end


#5MB以下での画像添付制限  
  def size_range
    1..5.megabytes
  end

  #protected
  #def secure_token
    #var = :"@#{mounted_as}_secure_token"
    #model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  #end

private
  def is_thumb? image
    image.content_type.include?("image/")
  end

end
