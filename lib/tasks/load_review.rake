namespace :review do
  task :load => :environment do
    section_ids = ReviewSection.pluck(:id)
    new_section_ids = []
    question_ids = ReviewQuestion.pluck(:id)
    new_question_ids = []
    review_template_file = Rails.root.join('db/review_template.json')
    review_template = JSON.parse(File.read(review_template_file))
    review_template['sections'].each_with_index do |s, i|
      s_code = s['code']
      puts s['title']
      section = ReviewSection.find_by_code(s_code)
      section ||= ReviewSection.new(
        code: s_code
      )
      section.title = s['title']
      section.sort_order = i
      section.save!
      new_section_ids << section.id
      s['questions'].each_with_index do |q, j|
        q_code = q['code']
        puts q['title']
        question = ReviewQuestion.find_by_code(q_code)
        question ||= ReviewQuestion.new(
          code: q_code
        )
        question.review_section_id = section.id
        question.title = q['title']
        question.description = q['description']
        question.skippable = q['skippable'] || false
        question.auto_check = q['auto_check']
        question.sort_order = j
        question.save!
        new_question_ids << question.id
      end
    end
    ReviewSection.where(id: (section_ids - new_section_ids)).each(&:destroy)
    new_question_ids = ReviewQuestion.pluck(:id)
    ReviewQuestion.where(id: (question_ids - new_question_ids)).each(&:destroy)
    Review.all.each{ |r| r.respond_to_project_update }
  end
end
