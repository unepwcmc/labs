class InstallationsExport

  def initialize
    @installations = Installation.
      select([
        'servers.name', 'servers.domain',
        'installations.stage', 'installations.role',
        'projects.title', 'projects.github_identifier',
        'installations.branch', 'installations.url',
        'installations.description'
      ]).
      joins(:project, :server).
      order('servers.name, role, projects.title')
    @columns = [
      'Server', 'Domain',
      'Stage', 'Role',
      'Project', 'Github id',
      'Branch', 'URL',
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
