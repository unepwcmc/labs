SELECT
projects.title,
external_clients,
project_instances.url,
project_instances.stage,
CASE WHEN project_instances.closing THEN '[x]' ELSE NULL END AS instance_closing,
web_servers.name AS web_server,
web.description AS web_server_notes,
CASE WHEN web.closing THEN '[x]' ELSE NULL END AS web_closing,
db_servers.name AS db_server,
db.description AS db_server_notes,
CASE WHEN db.closing THEN '[x]' ELSE NULL END AS db_closing,
projects.project_leads,
projects.current_lead,
projects.state,
projects.user_access,
projects.github_identifier,
projects.rails_version,
projects.ruby_version,
postgresql_version,
projects.other_technologies,
projects.dependencies,
projects.background_jobs,
projects.cron_jobs,
projects.hacks,
projects.master_projects,
projects.slave_projects
FROM projects_export projects
LEFT JOIN project_instances ON project_instances.project_id = projects.id
LEFT JOIN installations web ON web.project_instance_id = project_instances.id AND web.role ~* 'web'
LEFT JOIN servers web_servers ON web.server_id = web_servers.id
LEFT JOIN installations db ON db.project_instance_id = project_instances.id AND db.role ~* 'database'
LEFT JOIN servers db_servers ON db.server_id = db_servers.id
WHERE internal_clients ~* 'species'
AND project_instances.deleted_at IS NULL
AND web.deleted_at IS NULL
AND db.deleted_at IS NULL
ORDER BY projects.title, CASE WHEN project_instances.stage ~* 'production' THEN 1 ELSE 2 END
