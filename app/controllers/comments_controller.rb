class CommentsController < ApplicationController
  include Formatter
  before_filter :load_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id


    respond_to do |format|
      if @comment.save
        SlackChannel.post("#labs", "New comments in Labs", @comment.content, ":envelope:")
        format.json { render :json => {content: format(@comment.content), comment_id: @comment.id, created_at: @comment.created_at.to_s(:db),
          gravatar_id: Digest::MD5.hexdigest(current_user.email.downcase), github: current_user.github}, :status => :created}
      else
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end

  private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    klass = resource.singularize.classify.constantize
    if [Installation, Server, ProjectInstance].include? klass
      @commentable = klass.with_deleted.find(id)
    else
      @commentable = klass.find(id)
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
