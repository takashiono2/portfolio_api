class PostsController < ApplicationController
  #before_action :correct_user, only: [:show]
  #before_action :admin_user, only: [:index,:create,:edit,:update]#管理者ではないなら

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    if @post
      @post = Post.find(params[:id])
    else
      flash[:danger]="ページは存在しません"
      redirect_to posts_url
    end
  end  
  
  def new
    #@post = Post.new
###以下,複数画像を添付する時
    #@PICTURE_COUNT = 3
    @post = Post.new(create_params)
    #@thumbnails = @post.thumbnails.new
    3.times { @post.thumbnails.build }#紐づいたサムネイルをビルドする3枚投稿するので、3times
  end

  def create
    @post = Post.new(post_params)
    if post_params[:post_title].length>30
      flash[:danger] = "タイトルは30文字以内で登録してください"
      render :new
    elsif @post.save
      flash[:success] = "登録しました！"
      redirect_to posts_url
    else 
      flash[:danger] = "登録し直してください"
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @thumbnail_ids = Thumbnail.where(post_id: @post.id).pluck(:id)#[配列でidがとれる]
    #↑https://qiita.com/_Yasuun_/items/a7e4a2e44c3c27ec3ba2
  end
  
  def update
      @post = Post.find(params[:id])
    if params[:check].present?
      @post.update_attributes(post_params)#falseは来ない、存在したらtrue # blankを前に持ってこないとnilclassになる
        if (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]].blank? && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]].blank? && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]][0] == "true")
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["2"]["id"]).update(image: nil)
        
        elsif (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]].blank? && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]][0] == "true" && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]].blank?)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["1"]["id"]).update(image: nil)
          
        elsif (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]][0] == "true" && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]].blank? && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]].blank?)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["0"]["id"]).update(image: nil)
        
        elsif (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]][0] == "true" && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]].blank? && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]][0] == "true")
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["0"]["id"]).update(image: nil)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["2"]["id"]).update(image: nil)

        elsif (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]][0] == "true" && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]][0] == "true" && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]].blank?)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["0"]["id"]).update(image: nil)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["1"]["id"]).update(image: nil)

        elsif (params[:check][params[:post]["thumbnails_attributes"]["0"]["id"]][0] == "true"  && params[:check][params[:post]["thumbnails_attributes"]["1"]["id"]][0] == "true"  && params[:check][params[:post]["thumbnails_attributes"]["2"]["id"]][0] == "true" )
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["0"]["id"]).update(image: nil)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["1"]["id"]).update(image: nil)
          @post.thumbnails.find(params[:post]["thumbnails_attributes"]["2"]["id"]).update(image: nil)
        end
        @post.save!
        #@post.update_attributes!(post_params)
        flash[:success] = "修正しました！"
        redirect_to action: 'index'
    elsif params[:check].blank?
        if params[:post]["post_title"].length>30
          flash[:danger] = "修正できません。タイトルは30文字以内で入力してください"
          redirect_to action: 'index'
        elsif @post.update_attributes(post_params)
          flash[:success] = "修正しました！"
          redirect_to action: 'index'
        end
    else
      flash[:danger] = "修正できません"
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      flash[:success] = "削除しました！"
      redirect_to action: 'index'
    else
      flash[:danger] = "削除できません"
      render :index
    end
  end
  
  private

    def post_params
      params.require(:post).permit(:post_num, :post_title, :post_note,thumbnails_attributes:[:id,:image])
    end
    
    def create_params
      params.permit(thumbnails_attributes: [:image])
    end
end
#サムネイルをフォームから投稿するためにストロングパラメータを指定。
#fields_forは [引数に与えた名前]_attributes というname属性でフォームを作成するので、今回は thumbnails_attributesとします。

#上記は、thumbnails_attributes:がimage属性キーを持つ状態
##メモ
#params[:post][:thumbnails_attributes]["0"][:image].tempfile.path
#=> "/tmp/RackMultipart20200730-7883-10c162b.jpg"

## 1回ネストするパターン
# def item_params
#   params.require(:item).permit(:name, :description, images: [])
# end
#imagesが何らかの属性キーを持つ。
##以下,参考例
# {
#   "name": "Foo Bar",
#   "address": {
#     "prefecture": "Kanagawa",
#     "city": "Yokohama"
#   }
# }

# params.permit(:name, address: [:prefecture, :city])
#つまり、adressが2つの属性キーを持っている状態