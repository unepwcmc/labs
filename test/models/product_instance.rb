require 'test_helper'

class ProductInstanceTest < ActiveSupport::TestCase
  should validate_presence_of :product_id
  should validate_presence_of :url

  test "with a valid url" do
    @product = FactoryGirl.build(:product_instance, url: "http://www.google.com")
    assert_not @product.valid?
  end

  test "with an invalid url" do
    @product = FactoryGirl.build(:product_instance, url: "1234")
    assert_not @product.valid?
  end

  test "should initialize product_instance with production as default stage" do
    attrs = FactoryGirl.attributes_for(:product_instance).except(:stage)
    @product_instance = ProductInstance.build(attrs)
    assert_equal "Production", @product_instance.stage
  end

  test "should create product_instance with production as default stage" do
    attrs = FactoryGirl.attributes_for(:product_instance).except(:stage)
    @product_instance = ProductInstance.create(attrs)
    assert_equal "Production", @product_instance.stage
  end

end