module ProjectsHelper
  delegate :url_helpers, to: 'Rails.application.routes'

  def project_preview project
    source = project.screenshot.thumb.url.blank? ? "http://placehold.it/320x200" : project.screenshot.thumb.url
    image_tag(source)
  end

  def project_mini_preview project
    source = project.screenshot.mini.url.blank? ? "http://placehold.it/200x120" : project.screenshot.mini.url
    image_tag(source)
  end

  def project_style project
    if !project.published?
      "unpublished-project"
    end
  end

  def display_text project, field, display_text=nil
    content_tag(:p, content_tag(:strong, (display || field.to_s.titleize)+":")) +
      content_tag(:div, simple_format(h project.send(field)), class: "block-of-text")
  end

  PASS_THRESHOLD = 1.0
  SATISFACTORY_THRESHOLD = 0.8

  def review_score(review)
    return '' unless review
    link_to review_path(review) do
      if review.result >= PASS_THRESHOLD
        content_tag(:div, class: 'review-success') do
          fa_icon_in_span('check-circle', 'success', review.result_formatted)
        end
      elsif review.result >= SATISFACTORY_THRESHOLD
        content_tag(:div, class: 'review-warning') do
          fa_icon_in_span('exclamation-circle', 'warning', review.result_formatted)
        end
      else
        content_tag(:div, class: 'review-error') do
          fa_icon_in_span('minus-circle', 'error', review.result_formatted)
        end
      end
    end
  end

  def review_jumbotron
    if @project.reviews.empty?
      content_tag(:div, class: 'jumbotron') do
        content_tag(:h2, 'This project has not been reviewed!') +
        content_tag(:p) do
          start_review_button(@project)
        end
      end
    end
  end

  def start_review_button(project)
    link_to('Start review', url_helpers.new_review_path(project_id: project.id), class: 'btn btn-primary btn-sm', role: 'button')
  end

end
