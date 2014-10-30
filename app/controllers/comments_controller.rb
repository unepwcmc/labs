class CommentsController < ApplicationController
  
  before_filter :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        #format.html { redirect_to @commentable, notice: "Comment created."}
        format.json { render :json => {content: @comment.content, created_at: @comment.created_at.to_s(:db), 
          gravatar_id: Digest::MD5.hexdigest(current_user.email.downcase), github: current_user.github}, :status => :created}
      else
        format.html {
          available_developers
          render :action => "new"
        }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end