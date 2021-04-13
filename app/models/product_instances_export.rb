class ProductInstancesExport
  include CsvExportable

  def initialize
    @relation = ProductInstance.
      select([
        'id',
        'name', 'url',
        'products.title',
        'backup_information', 'stage',
        'branch', 'closing', 'description',
        'COUNT("installations".id) AS installations',
        "to_char(product_instances.created_at,'YYYY-MM-DD HH:MM')",
        "to_char(product_instances.updated_at,'YYYY-MM-DD HH:MM')"
      ]).
      joins(:product).
      joins('LEFT OUTER JOIN installations ON installations.product_instance_id = product_instances.id').
      order('product_instances.created_at').
      group('product_instances.id', 'products.title')
    @columns = [
      'ID',
      'Name', 'URL',
      'Product',
      'Backup Information', 'Stage',
      'Branch', 'Closing', 'Description',
      '# of installations',
      'Created at', 'Updated at'
    ]
  end

  def collection_name; 'product_instances'; end

end