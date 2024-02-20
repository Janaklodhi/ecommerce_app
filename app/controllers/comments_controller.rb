class CommentsController < ApplicationController
  # load_and_authorize_resource
  before_action :set_current_user, only: [:create, :index, :update, :destroy]
  def index
    byebug
    @comments = @current_user.comments.all
    render json: @comments, each_serializer: CommentSerializer
  end

  def create
    begin
      @article = @current_user.articles.find(params[:comment][:article_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Article not found" }, status: :not_found
      return
    end

    @comment = @article.comments.new(comments_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(articles_params)
      render json: @article, status: :ok
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.comments.destroy
      render json: { message: "comments deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete article's comments" }, status: :unprocessable_entity
    end
  end

  private

  def comments_params
    user = authentication
    return {} unless user
    params.require(:comment).permit(:commenter, :body, :article_id).merge(user_id: user.id)
  end
end
