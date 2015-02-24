class InstallationsExport

  def initialize
    @installations = Installation.
      select([
        'servers.name', 'servers.domain',
        'installations.role',
        'installations.description'
      ]).
      joins(:server).
      order('servers.name, role')
    @columns = [
      'Server', 'Domain',
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
