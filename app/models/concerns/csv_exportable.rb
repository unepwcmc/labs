module CsvExportable

  def export
    File.open(@file_name, 'w') do |f|
      f.write PgCsv.new(
        sql: @relation.to_sql,
        columns: @columns,
        encoding: 'UTF8',
        type: :plain
      ).export
    end
    @file_name
  end

end
