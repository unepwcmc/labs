require 'test_helper'

class CrudProductsTest < ActionDispatch::IntegrationTest
  def setup
    @user = FactoryGirl.build(:user)
    @product = FactoryGirl.create(:product)
    @draft_product = FactoryGirl.create(:draft_product)

    stub_request(:get, Rails.application.secrets.employees_endpoint_url).
    to_return(:status => 200, :body => {"employees" => ['Test','Test']}.to_json,
      :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby', :content_type => "application/json"})
  end

  test "index page shows public products to public user" do
    visit root_path
    page.has_content? @product.title
    page.has_no_text? @draft_product.title
  end

  test "index page shows all products to logged in user" do
    sign_in_with_github @user, true
    visit root_path
    page.has_content? @product.title
    page.has_content? @draft_product.title
  end

  test "creating a new product adds it to the database" do
    sign_in_with_github @user, true
    visit root_path
    assert_difference 'Product.count', +1 do
      click_button "Add a new Product"
      @new_product = FactoryGirl.build(:product)
      within("#new_product") do
        fill_in 'Title', :with => @product.title
        fill_in 'Description', :with => @product.description
        fill_in 'Url', :with => @product.url
        fill_in 'Github identifier', :with => @product.github_identifier
        select @product.state, :from => 'State'
        fill_in 'product_internal_clients_array', :with => @product.internal_clients.join("\n")
        fill_in 'Current lead', :with => @product.current_lead
        fill_in 'product_external_clients_array', :with => @product.external_clients.join("\n")
        fill_in 'product_product_leads_array', :with => @product.product_leads.join("\n")
        fill_in 'product_developers_array', :with => @product.developers.join("\n")
        check 'Published'
      end
      click_button "Create Product"
    end
  end

  test "products have edit, show, and destroy options when logged in" do
    sign_in_with_github @user, true
    visit root_path
    page.has_content? 'Show | Edit | Delete'
  end

  test "products do not have edit, show and destroy options when not logged in" do
    visit root_path
    page.has_no_text? 'Show | Edit | Delete'
  end

  test "editing a product updates its attributes in database" do
    sign_in_with_github @user, true
    visit root_path
    first('.product').has_content? @product.title
    @new_product = FactoryGirl.build(:product) # Use string instead of object
    first('.product').click_link("Edit")
    within('.form-horizontal') do
      fill_in 'Title', :with => @new_product.title
      click_button 'Update Product'
    end
    @product.reload
    assert_match @product.title, @new_product.title
  end

  test "destroying a product removes it from the database" do
    sign_in_with_github @user, true
    visit root_path
    assert_difference 'Product.count', -1 do
      first('.product').click_link('Delete')
      # Need to accept js confirmation here?
    end
  end
end
