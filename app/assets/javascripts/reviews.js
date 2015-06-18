$(document).ready(function(){
  $('.review-answer').change(function(){
    var el = $(this);
    var reviewId = el.data('review-id');
    var questionId = el.data('question-id');
    var done = el.val();
    $.ajax({
      type: 'POST',
      url: '/reviews/' + reviewId + '/answers',
      data: {
        answer: {
          review_question_id: questionId,
          done: done
        }
      },
      dataType: 'JSON',
      success: function(answer) {
        var feedbackEl = el.closest('div').next('.feedback');
        if (answer.is_acceptable == true) {
          feedbackEl.addClass('success').removeClass('error');
        }
        else {
          feedbackEl.addClass('error').removeClass('success');
        }
      }
    });
  });
});