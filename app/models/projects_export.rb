class ProjectsExport
  include CsvExportable

  def initialize
    @relation = Project.from('projects_export AS projects').
    order('projects.title')

    @columns = [
      'ID',
      'Name',
      'URL',
      'Description',
      'Internal description',
      'External clients',
      'Internal clients',
      'Project leads',
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
      'Projects this p. depends on',
      'Projects that depend on this p.',
      'Created at',
      'Updated at'
    ]
  end

  def collection_name; 'projects'; end

end