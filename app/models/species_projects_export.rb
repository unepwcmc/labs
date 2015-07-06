class SpeciesProjectsExport
  include CsvExportable

  def initialize
    @relation = Project.from('species_projects_export AS projects')

    @columns = [
      'Name',
      'External clients',
      'Instance URL',
      'Instance Stage',
      'Instance closing',
      'Web Server',
      'Web Server notes',
      'Web closing',
      'DB Server',
      'DB Server notes',
      'DB closing',
      'Project leads',
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
      'Projects this p. depends on',
      'Projects that depend on this p.'
    ]
    @file_name = "#{Rails.root}/public/downloads/species_projects_#{Date.today}.csv"
  end

end