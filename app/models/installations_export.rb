class InstallationsExport

  def initialize
    @installations = Installation.
      select([
        'project_instances.name', 'projects.title',
        'servers.name', 'servers.domain',
        'installations.role', 'installations.closing',
        'installations.description',
        "to_char(installations.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(installations.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:server, :project_instance => :project).
      order('servers.name, role')
    @columns = [
      'Instance', 'Project',
      'Server', 'Domain',
      'Role', 'Closing',
      'Description',
      'Created_at', 'Updated_at'
    ]
    @file_name = "public/downloads/installations_#{Date.today}.csv"
  end

  def export
    PgCsv.new(
      sql: @installations.to_sql,
      columns: @columns
    ).export(@file_name)
    @file_name
  end

end
