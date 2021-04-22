# == Schema Information
#
# Table name: products
#
#  id                    :integer          not null, primary key
#  title                 :string(255)      not null
#  description           :text             not null
#  url                   :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  published             :boolean          default(FALSE)
#  screenshot            :string(255)
#  github_identifier     :string(255)
#  dependencies          :text
#  state                 :string(255)      not null
#  current_lead          :string(255)
#  hacks                 :text
#  external_clients      :text             default([]), is an Array
#  product_leads         :text             default([]), is an Array
#  developers            :text             default([]), is an Array
#  pdrive_folders        :text             default([]), is an Array
#  dropbox_folders       :text             default([]), is an Array
#  pivotal_tracker_ids   :text             default([]), is an Array
#  trello_ids            :text             default([]), is an Array
#  expected_release_date :date
#  rails_version         :string(255)
#  ruby_version          :string(255)
#  postgresql_version    :string(255)
#  other_technologies    :text             default([]), is an Array
#  internal_clients      :text             default([]), is an Array
#  internal_description  :text
#  background_jobs       :text
#  cron_jobs             :text
#  user_access           :text
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :state
  should validate_inclusion_of(:state).in_array(['Under Development', 'Delivered', 'Project Development'])
 
  test "responds to metaprogrammed array methods" do
    @product = FactoryGirl.build(:product)
    assert @product.respond_to?(:developers)
    assert @product.respond_to?(:internal_clients)
    assert @product.respond_to?(:external_clients)
    assert @product.respond_to?(:product_leads)
    assert @product.respond_to?(:pdrive_folders)
    assert @product.respond_to?(:dropbox_folders)
  end
 
  context "Product NOT published" do
    should_not validate_presence_of :url
  end
 
  context "Product published" do
    subject do
      Product.new(:title => 'Valid Title', :description => 'Valid Description', :state => 'Delivered', :published => true)
    end
    should validate_presence_of(:url)
  end

  def test_team_members_auto_check
    @product1 = FactoryGirl.create(:product, current_lead: 'Dev 1')
    @product2 = FactoryGirl.create(:product, current_lead: nil)
    assert @product1.team_members?
    assert !@product2.team_members?
  end

  def test_production_instance_auto_check
    @product1 = FactoryGirl.create(:product)
    @instance1 = FactoryGirl.create(:product_instance, product: @product1, stage: 'Production')
    FactoryGirl.create(:installation, product_instance: @instance1)
    @product2 = FactoryGirl.create(:product)
    assert @product1.production_instance?
    assert !@product2.production_instance?
  end

  def test_staging_instance_auto_check
    @product1 = FactoryGirl.create(:product)
    @instance1 = FactoryGirl.create(:product_instance, product: @product1, stage: 'Staging')
    FactoryGirl.create(:installation, product_instance: @instance1)
    @product2 = FactoryGirl.create(:product)
    assert @product1.staging_instance?
    assert !@product2.staging_instance?
  end

  def test_production_backups_auto_check
    @product1 = FactoryGirl.create(:product)
    @instance1 = FactoryGirl.create(:product_instance,
      product: @product1, stage: 'Production', backup_information: 'loads of backup'
    )
    FactoryGirl.create(:installation, product_instance: @instance1)
    @product2 = FactoryGirl.create(:product)
    assert @product1.production_backups?
    assert !@product2.production_backups?
  end

end
