module CsvExportable

  def export
    file_name = "#{Rails.root}/public/downloads/#{collection_name}_#{Date.today}.csv"
    File.open(file_name, 'w') do |f|
      f.write PgCsv.new(
        sql: @relation.to_sql,
        columns: @columns,
        encoding: 'UTF8',
        type: :plain
      ).export
    end
    Pathname.new(file_name).realpath
  end

end
