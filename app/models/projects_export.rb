class ProjectsExport
  def initialize
    @projects = Project.select([
      'id','title', 'url', 'description',
      'internal_description',
      'ARRAY_TO_STRING(external_clients, \', \')',
      'ARRAY_TO_STRING(internal_clients, \', \')',
      'ARRAY_TO_STRING(project_leads, \', \')',
      'current_lead', 'expected_release_date', 'state',
      'COUNT("project_instances".id) AS instances',
      'github_identifier', 'dependencies',
      'ruby_version', 'rails_version', 'postgresql_version',
      'ARRAY_TO_STRING(other_technologies, \', \')',
      'cron_jobs', 'background_jobs',
      'hacks',
      "to_char(projects.created_at,'YYYY-MM-DD HH:MM') AS created_at",
      "to_char(projects.updated_at,'YYYY-MM-DD HH:MM') AS updated_at"
    ]).
    joins('LEFT OUTER JOIN project_instances ON project_instances.project_id = projects.id').
    order('projects.title').
    group('projects.id')
    @columns = [
      'ID', 'Name', 'URL', 'Description',
      'Internal description',
      'External clients',
      'Internal clients',
      'Project leads',
      'Current lead', 'Expected release date', 'State',
      '# of instances',
      'Github ID', 'System dependencies',
      # 'Projects this p. depends on',
      # 'Projects that depend on this p.',
      'Ruby version', 'Rails version', 'PostgreSQL version',
      'Other technologies',
      'Cron jobs', 'Background jobs',
      'Hacks', 'Created at', 'Updated at'
    ]
    @file_name = "#{Rails.root}/public/downloads/projects_#{Date.today}.csv"
  end

  def export
    File.open(@file_name, 'w') do |f|
      f.write PgCsv.new(
        sql: @projects.to_sql,
        columns: @columns,
        encoding: 'UTF8',
        type: :plain
      ).export
    end
    @file_name
  end
end