module ProjectsHelper
  def project_preview project
    source = project.screenshot.thumb.url.blank? ? "http://placehold.it/320x200" : project.screenshot.thumb.url
    image_tag(source)
  end
end
