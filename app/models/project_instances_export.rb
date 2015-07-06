class ProjectInstancesExport
  include CsvExportable

  def initialize
    @relation = ProjectInstance.
      select([
        'id',
        'name', 'url',
        'projects.title',
        'backup_information', 'stage',
        'branch', 'closing', 'description',
        'COUNT("installations".id) AS installations',
        "to_char(project_instances.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(project_instances.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:project).
      joins('LEFT OUTER JOIN installations ON installations.project_instance_id = project_instances.id').
      order('project_instances.created_at').
      group('project_instances.id', 'projects.title')
    @columns = [
      'ID',
      'Name', 'URL',
      'Project',
      'Backup Information', 'Stage',
      'Branch', 'Closing', 'Description',
      '# of installations',
      'Created at', 'Updated at'
    ]
    @file_name = "#{Rails.root}/public/downloads/project_instances_#{Date.today}.csv"
  end

end