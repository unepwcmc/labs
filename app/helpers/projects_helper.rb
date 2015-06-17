module ProjectsHelper
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

  def review_score(review)
    return '' unless review
    link_to review_path(review) do
      if review.result == 1.0
        content_tag(:div, class: 'review-success') do
          content_tag(:span, review.result_formatted,
            {class: 'glyphicon glyphicon-ok-sign', 'aria-hidden' => true}
          ) +
          content_tag(:span, 'success', class: 'sr-only')
        end
      else
        content_tag(:div, class: 'review-error') do
          content_tag(:span, review.result_formatted,
            {class: 'glyphicon glyphicon-exclamation-sign', 'aria-hidden' => true}
          ) +
          content_tag(:span, 'error', class: 'sr-only')
        end
      end
    end
  end
end
