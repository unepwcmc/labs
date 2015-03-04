class ProjectsExport
  def initialize
    @projects = Project.select([
      'id','title', 'url', 'description',
      'internal_description', 'external_clients', 'internal_clients',
      'current_lead', 'expected_release_date', 'state',
      'count("project_instances".id) AS instances',
      'github_identifier', 'dependencies',
      'ruby_version', 'rails_version', 'postgresql_version',
      'other_technologies', 'cron_jobs', 'background_jobs',
      'hacks', "to_char(projects.created_at,'YYYY-MM-DD HH:MM') AS created_at"
    ]).
    joins("LEFT OUTER JOIN project_instances ON project_instances.project_id = projects.id").
    order('projects.title').
    group('projects.id')
    @file_name = "#{Rails.root}/public/downloads/projects_#{Date.today}.csv"
  end

  def export
    @projects.copy_to @file_name
    @file_name
  end
end