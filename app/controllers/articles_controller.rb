class ArticlesController < ApplicationController
  before_action :set_current_user
  before_action :find_article, only: [:show]
  def index
    @articles = @current_user.articles
    render json: @articles, each_serializer: ArticleSerializer
  end

  def create
    @article = Article.new(articles_params)
    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @article, include: ['comments']
  end

  def update
    if @article.update(articles_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end


  def destroy
    if @article.destroy
      render json: { message: "Article deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete article" }, status: :unprocessable_entity
    end
  end

  private

  def find_article
    byebug
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Article not found" }, status: :not_found
  end

  def set_current_user
    @current_user = current_user
  end

  def articles_params
    user = authentication
    return {} unless user
    params.require(:article).permit(:title, :body).merge(user_id: user.id)
  end
end
