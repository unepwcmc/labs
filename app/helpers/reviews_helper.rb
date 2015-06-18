module ReviewsHelper
  def answer_for_display(question)
    answer = @review.try(:answer, question)
    answer_text = if answer
      answer.selected_option ? 'yes' : 'no'
    else
      '(empty)'
    end
    content_tag(:span, answer_text, class: 'col-sm-2')
  end

  def review_radio_button(question, value, is_checked, is_disabled)
    content_tag(:label, class: 'radio-inline') do
      radio_properties = {
        type: 'radio', value: value, name: "answer[#{question.id}][selected_option]",
        class: 'review-answer',
        'data-question-id' => question.id,
        'data-review-id' => @review.id
      }
      radio_properties['checked'] = 'checked' if is_checked
      radio_properties['disabled'] = 'disabled' if is_disabled
      content_tag(:input, value, radio_properties)
    end
  end

  def review_checkbox(question, value, is_checked, is_disabled)
    content_tag(:label, class: 'checkbox-inline') do
      checkbox_properties = {
        type: 'checkbox', value: value, name: "answer[#{question.id}][selected_option]",
        class: 'review-answer',
        'data-question-id' => question.id,
        'data-review-id' => @review.id
      }
      checkbox_properties['checked'] = 'checked' if is_checked
      checkbox_properties['disabled'] = 'disabled' if is_disabled
      content_tag(:input, value, checkbox_properties)
    end
  end

  def review_input_group(question)
    answer = @review.try(:answer, question)
    disabled = question.auto_check.present?
    if question.skippable?
      capture do
        concat review_radio_button(question, 'yes', answer.try(:done?), disabled)
        if question.skippable
          concat review_radio_button(question, 'skip', answer.try(:skipped?), disabled)
        end
      end
    else
      review_checkbox(question, 'yes', answer.try(:done?), disabled)
    end
  end

  def feedback(question)
    answer = @review.try(:answer, question)
    feedback = answer && answer.is_acceptable?(question) ? 'success' : 'error'
    content_tag(:div, class: "col-sm-2 feedback #{feedback}") do
      content_tag(:div, class: 'error-feedback') do
        content_tag(:span, nil,
          {class: 'glyphicon glyphicon-exclamation-sign', 'aria-hidden' => true}
        ) +
        content_tag(:span, 'error', class: 'sr-only')
      end +
      content_tag(:div, class: 'success-feedback') do
        content_tag(:span, nil,
          {class: 'glyphicon glyphicon-ok-sign', 'aria-hidden' => true}
        ) +
        content_tag(:span, 'success', class: 'sr-only')
      end
    end
  end

end