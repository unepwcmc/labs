class ApplicationController < ActionController::Base
  include Formatter

  protect_from_forgery

  helper_method :kramdown

  def kramdown text
    Kramdown::Document.new(text).to_html
  end

  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end

  def after_sign_in_path_for(resource)
    products_path(user: resource)
  end

end
