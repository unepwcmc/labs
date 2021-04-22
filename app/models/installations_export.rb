class InstallationsExport
  include CsvExportable

  def initialize
    @relation = Installation.
      select([
        'installations.id',
        'product_instances.name', 'products.title',
        'servers.name', 'servers.domain',
        "ARRAY_TO_STRING(servers.open_ports, ', ') AS open_ports",
        'installations.role', 'installations.closing',
        'installations.description',
        "to_char(installations.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(installations.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:server, :product_instance => :product).
      order('servers.name, role')
    @columns = [
      'ID',
      'Instance', 'Product',
      'Server', 'Domain',
      'Open ports',
      'Role', 'Closing',
      'Description',
      'Created at', 'Updated at'
    ]
  end

  def collection_name; 'installations'; end

end
