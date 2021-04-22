# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  product_id  :integer          not null
#  reviewer_id :integer          not null
#  result      :decimal(, )      not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  def test_result_formatted
    @question = FactoryGirl.create(:review_question)
    @product = FactoryGirl.create(:product, title: 'AAA')
    @review = FactoryGirl.create(:review, product: @product)
    assert @review.result_formatted == '0%'
  end

  def test_reviews_refreshed_after_product_update
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'ruby_version?')
    @product = FactoryGirl.create(:product, ruby_version: nil)
    @review = FactoryGirl.create(:review, product: @product)
    assert @review.reload.result == 0.0
    old_result = @review.result
    @product.update_attributes(ruby_version: '2.0.0')
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_instance_update
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_backups?')
    @product = FactoryGirl.create(:product)
    @instance = FactoryGirl.create(:product_instance, product: @product, stage: 'Production', backup_information: nil)
    FactoryGirl.create(:installation, product_instance: @instance)
    @review = FactoryGirl.create(:review, product: @product)
    @product.reviews.reload
    assert @review.reload.result == 0.0
    old_result = @review.result
    @instance.update_attributes(backup_information: 'loads of backup')
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_installation_create
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_instance?')
    @product = FactoryGirl.create(:product)
    @instance = FactoryGirl.create(:product_instance, product: @product, stage: 'Production')
    @review = FactoryGirl.create(:review, product: @product)
    assert @review.reload.result == 0.0
    old_result = @review.result
    i = FactoryGirl.create(:installation, product_instance: @instance)
    assert old_result < @review.reload.result
  end

  def test_reviews_refreshed_after_installation_destroy
    @question = FactoryGirl.create(:review_question)
    @auto_question = FactoryGirl.create(:review_question, skippable: false, auto_check: 'production_instance?')
    @product = FactoryGirl.create(:product)
    @instance = FactoryGirl.create(:product_instance, product: @product, stage: 'Production')
    FactoryGirl.create(:installation, product_instance: @instance)
    @review = FactoryGirl.create(:review, product: @product)
    assert @review.reload.result > 0.0
    old_result = @review.result
    @instance.destroy
    assert old_result > @review.reload.result
  end

end
