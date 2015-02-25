class ProjectInstancesExport
  def initialize
    @project_instances = ProjectInstance.
      select([
        'id', 'project_id',
        'name', 'url',
        'backup_information', 'stage',
        'branch', 'closing', 'description',
        'created_at', 'updated_at'
      ]).
      joins(:project).
      order('created_at')
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