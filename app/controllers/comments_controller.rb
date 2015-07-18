class CommentsController < ApplicationController
  before_action :require_user
  before_action :require_same_user, only: [:edit, :destroy]
  
  def new
    @comment = Comment.new
  end
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_user
    @paged_comments = Recipe.find(params[:recipe_id]).comments.paginate(page: params[:page], per_page: 4)

    if @comment.save
      flash[:success] = "Your comment has been added"
      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Your comment could not be added"
      redirect_to :back
    end
  end

  def edit
    @recipe = Recipe.find(params[:recipe_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:recipe_id])
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:success] = "Your comment was updated successfully"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id]).destroy
    flash[:success] = "Your comment was deleted"
    redirect_to recipes_path(@recipe)
  end

  private
    def comment_params
      params.require(:comment).permit(:recipe_id, :body)
    end

  def require_same_user
    @recipe = Recipe.find(params[:recipe_id])
    if current_user != Comment.find(params[:id]).chef && !current_user.admin?
      flash[:danger] = "You can only edit your own comments"
      redirect_to recipe_path(@recipe)
    end
  end

end