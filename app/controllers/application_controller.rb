class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :kramdown

  def kramdown text
    Kramdown::Document.new(text).to_html
  end
end
