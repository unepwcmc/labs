class ReviewAnswersController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def create_or_update
    @review = Review.find(params[:review_id])
    p = answer_params
    @answer = @review.answers.where(review_question_id: p[:review_question_id]).first
    unless @answer
      @answer = @review.answers.create(p)
    else
      @answer.update_attributes(p)
    end
    respond_with(@review, @answer)
  end

  def show
  end

  private

  def answer_params
    params.require(:answer).permit(:selected_option, :review_question_id).tap do |p|
      case p[:selected_option]
      when 'yes'
        p[:selected_option] = true
        p[:skipped] = false
      else
        p[:selected_option] = false
        p[:skipped] = true
      end
    end
  end
end
