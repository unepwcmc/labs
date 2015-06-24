class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, except: [:index, :new, :create]
  before_action :set_projects, only: [:new, :edit]
  before_action :set_sections, only: [:edit, :show]

  respond_to :html, :json

  def index
    @reviews = Review.includes(:project, :reviewer).order("created_at DESC")
    respond_with(@reviews)
  end

  def new
    @review = Review.new(reviewer_id: current_user.id)
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:notice] = "Review was successfully created."
      redirect_to edit_review_url(@review)
    else
      flash[:error] = "Create failed"
      set_projects
      set_sections
      respond_with(@review)
    end
  end

  def edit
  end

  def update
    if @review.update_attributes(review_params)
      flash[:notice] = "Review was successfully updated."
    else
      flash[:error] = "Update failed"
      set_projects
      set_sections
    end
    respond_with(@review)
  end

  def show
    @comments = @review.comments.order(:created_at)
    @comment = Comment.new
    respond_with(@review)
  end

  def destroy
    @review.destroy
    flash[:notice] = 'Review was successfully deleted.'
    respond_with(@review)
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_projects
    @projects = Project.order(:title)
    @reviewers = User.order(:name)
  end

  def set_sections
    @sections = ReviewSection.order(:sort_order)
    @sections = if @review.nil? || @review.new_record?
      @sections.includes(:questions)
    else
      @sections.includes(:questions => :answers)
    end
    @sections = @sections.references(:questions).
      order('review_sections.sort_order, review_questions.sort_order')
  end

  def review_params
    params.require(:review).permit(:project_id, :reviewer_id)
  end

end
