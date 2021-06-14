module ProductsHelper
  delegate :url_helpers, to: 'Rails.application.routes'

  def product_preview product
    source = product.screenshot.thumb.url.blank? ? "http://placehold.it/320x200" : product.screenshot.thumb.url
    image_tag(source)
  end

  def product_mini_preview product
    source = product.screenshot.mini.url.blank? ? "http://placehold.it/200x120" : product.screenshot.mini.url
    image_tag(source)
  end

  def product_style product
    if !product.published?
      "unpublished-product"
    end
  end

  def display_text product, field, display_text=nil
    content_tag(:p, content_tag(:strong, (display || field.to_s.titleize)+":")) +
      content_tag(:div, simple_format(h product.send(field)), class: "block-of-text")
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
    if @product.reviews.empty?
      content_tag(:div, class: 'jumbotron') do
        content_tag(:h2, 'This product has not been reviewed!') +
        content_tag(:p) do
          start_review_button(@product)
        end
      end
    end
  end

  def start_review_button(product)
    link_to('Start review', url_helpers.new_review_path(product_id: product.id), class: 'btn btn-primary btn-sm', role: 'button')
  end

end
