class InstallationsExport
  include CsvExportable

  def initialize
    @relation = Installation.
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
  end

  def collection_name; 'installations'; end

end
