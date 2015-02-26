module ProjectInstancesHelper
  def display_info instance
    "<i style='color: #00BFFF'>Description:</i> #{instance.description.presence || "-"}<br/><i style='color: #00BFFF'>Backup Information:</i> #{instance.backup_information.presence || "-"}"
  end
end
