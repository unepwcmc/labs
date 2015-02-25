class ProjectInstancesExport
  def initialize
    @project_instances = ProjectInstance.
      select([
        'id', 'project_id',
        'name', 'url',
        'backup_information', 'stage',
        'branch', 'closing', 'description',
        "to_char(project_instances.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(project_instances.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:project).
      order('project_instances.created_at')
    @columns = [
      'ID', 'Project ID',
      'Name', 'Url',
      'Backup Information', 'Stage',
      'Branch', 'Closing', 'Description',
      'Created At', 'Updated At'
    ]
    @file_name = "public/downloads/project_instances_#{Date.today}.csv"
  end

  def export
    PgCsv.new(
      sql: @project_instances.to_sql,
      columns: @columns
    ).export(@file_name)
    @file_name
  end
end