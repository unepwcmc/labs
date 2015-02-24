class InstallationsExport

  def initialize
    @installations = Installation.
      select([
        'servers.name', 'servers.domain',
        'installations.role',
        'projects.title', 'projects.github_identifier',
        'installations.description'
      ]).
      joins(:project, :server).
      order('servers.name, role, projects.title')
    @columns = [
      'Server', 'Domain',
      'Project', 'Github id',
      'Notes'
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
