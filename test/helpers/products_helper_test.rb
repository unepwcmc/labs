class ProductsHelperTest < ActionView::TestCase

  def test_jumbotron_present_when_no_review
    @product = FactoryGirl.create(:product)
    assert_match /^<div.* class=".*jumbotron.*">/, review_jumbotron
  end

  def test_jumbotron_absent_when_review
    @product = FactoryGirl.create(:product)
    @review = FactoryGirl.create(:review, product: @product)
    assert_no_match /^<div.* class=".*jumbotron.*">/, review_jumbotron
  end

end
