class ProductsExport
  include CsvExportable

  def initialize
    @relation = Product.from('products_export AS products').
    order('products.title')

    @columns = [
      'ID',
      'Name',
      'URL',
      'Description',
      'Internal description',
      'External clients',
      'Internal clients',
      'Product leads',
      'Current lead',
      'Developers',
      'Expected release date',
      'State',
      'User access',
      '# of instances',
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
      'Products that depend on this p.',
      'Created at',
      'Updated at'
    ]
  end

  def collection_name; 'products'; end

end