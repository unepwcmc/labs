module ProjectInstancesHelper
  def display_info instance
    content_tag(:i, "Description: ", style: 'color: #00BFFF') +
    content_tag(:span, instance.description.presence || "-") +
    content_tag(:br) +
    content_tag(:i, "Backup Information: ", style: 'color: #00BFFF') +
    content_tag(:span, instance.backup_information.presence || "-")
  end
end
