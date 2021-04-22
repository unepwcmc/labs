class CombinedProductsExport
  include CsvExportable

  def initialize
    @relation = Product.from('combined_products_export AS products')

    @columns = [
      'Name',
      'Internal clients',
      'External clients',
      'Instance URL',
      'Instance Stage',
      'Instance notes',
      'Instance closing',
      'Web Server',
      'Web Server notes',
      'Web closing',
      'DB Server',
      'DB Server notes',
      'DB closing',
      'Product leads',
      'Current lead',
      'State',
      'User access',
      'Github ID',
      'Rails version',
      'Ruby version',
      'PostgreSQL version',
      'Other technologies',
      'System dependencies',
      'Background jobs',
      'Cron jobs',
      'Hacks',
      'Products this p. depends on',
      'Products that depend on this p.'
    ]
  end

  def collection_name; 'combined_products'; end

end