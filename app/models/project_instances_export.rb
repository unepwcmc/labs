class ProjectInstancesExport
  def initialize
    @project_instances = ProjectInstance.
      select([
        'id',
        'name', 'url',
        'projects.title',
        'backup_information', 'stage',
        'branch', 'closing', 'description',
        "to_char(project_instances.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(project_instances.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:project).
      order('project_instances.created_at')
    @columns = [
      'ID',
      'Name', 'Url',
      'Project',
      'Backup Information', 'Stage',
      'Branch', 'Closing', 'Description',
      'Created At', 'Updated At'
    ]
    @file_name = "#{Rails.root}/public/downloads/project_instances_#{Date.today}.csv"
  end

  def export
    @project_instances.copy_to @file_name
    @file_name
  end
end