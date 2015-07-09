SELECT
  projects.id,
  projects.title,
  projects.url,
  projects.description,
  projects.internal_description,
  ARRAY_TO_STRING(external_clients, ', ') AS external_clients,
  ARRAY_TO_STRING(internal_clients, ', ') AS internal_clients,
  ARRAY_TO_STRING(project_leads, ', ') AS project_leads,
  projects.current_lead,
  ARRAY_TO_STRING(developers, ', ') AS developers,
  projects.expected_release_date,
  projects.state,
  projects.user_access,
  COUNT(project_instances.id) AS instances,
  projects.github_identifier,
  projects.rails_version,
  projects.ruby_version,
  projects.postgresql_version,
  ARRAY_TO_STRING(other_technologies, ', ') AS other_technologies,
  projects.dependencies,
  projects.background_jobs,
  projects.cron_jobs,
  projects.hacks,
  ARRAY_TO_STRING(slave_projects.master_names, ', ') AS master_projects,
  ARRAY_TO_STRING(master_projects.slave_names, ', ') AS slave_projects,
  to_char(projects.created_at,'YYYY-MM-DD HH:MM') AS created_at,
  to_char(projects.updated_at,'YYYY-MM-DD HH:MM') AS updated_at
FROM projects
LEFT OUTER JOIN project_instances ON project_instances.project_id = projects.id AND project_instances.deleted_at IS NULL
LEFT JOIN (
  SELECT d.sub_project_id AS slave_id,
  ARRAY_AGG(p.title) AS master_names
  FROM dependencies d JOIN projects p ON p.id = d.master_project_id
  GROUP BY d.sub_project_id
) slave_projects ON slave_projects.slave_id = projects.id
LEFT JOIN (
  SELECT d.master_project_id AS master_id,
  ARRAY_AGG(p.title) AS slave_names
  FROM dependencies d JOIN projects p ON p.id = d.sub_project_id
  GROUP BY d.master_project_id
) master_projects ON master_projects.master_id = projects.id
GROUP BY projects.id, slave_projects.master_names, master_projects.slave_names
ORDER BY projects.title