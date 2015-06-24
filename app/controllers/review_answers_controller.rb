class ReviewAnswersController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create_or_update
    @review = Review.find(params[:review_id])
    p = answer_params
    @answer = @review.answers.where(review_question_id: p[:review_question_id]).first
    if @answer
      @answer.update_attributes(p)
    else
      @answer = @review.answers.create(p)
    end
    respond_with(@review, @answer)
  end

  def show
  end

  private

  def answer_params
    params.require(:answer).permit(:done, :review_question_id).tap do |p|
      if p[:done] == 'yes'
        p[:done] = true
        p[:skipped] = false
      else
        p[:done] = false
        p[:skipped] = true
      end
    end
  end
end
