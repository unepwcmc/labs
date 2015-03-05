class InstallationsExport

  def initialize
    @installations = Installation.
      select([
        'installations.id',
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
      'ID',
      'Instance', 'Project',
      'Server', 'Domain',
      'Role', 'Closing',
      'Description',
      'Created at', 'Updated at'
    ]
    @file_name = "#{Rails.root}/public/downloads/installations_#{Date.today}.csv"
  end

  def export
    File.open(@file_name, 'w') do |f|
      f.write PgCsv.new(
        sql: @installations.to_sql,
        columns: @columns,
        encoding: 'UTF8',
        type: :plain
      ).export
    end
    @file_name
  end

end
