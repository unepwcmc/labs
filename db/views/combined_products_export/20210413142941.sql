SELECT
products.title,
internal_clients,
external_clients,
product_instances.url,
product_instances.stage,
product_instances.description,
CASE WHEN product_instances.closing THEN '[x]' ELSE NULL END AS instance_closing,
web_servers.name AS web_server,
web.description AS web_server_notes,
CASE WHEN web.closing THEN '[x]' ELSE NULL END AS web_closing,
db_servers.name AS db_server,
db.description AS db_server_notes,
CASE WHEN db.closing THEN '[x]' ELSE NULL END AS db_closing,
products.product_leads,
products.current_lead,
products.state,
products.user_access,
products.github_identifier,
products.rails_version,
products.ruby_version,
postgresql_version,
products.other_technologies,
products.dependencies,
products.background_jobs,
products.cron_jobs,
products.hacks,
products.master_products,
products.slave_products
FROM products_export products
LEFT JOIN product_instances ON product_instances.product_id = products.id
LEFT JOIN installations web ON web.product_instance_id = product_instances.id AND web.role ~* 'web'
LEFT JOIN servers web_servers ON web.server_id = web_servers.id
LEFT JOIN installations db ON db.product_instance_id = product_instances.id AND db.role ~* 'database'
LEFT JOIN servers db_servers ON db.server_id = db_servers.id
WHERE product_instances.deleted_at IS NULL
AND web.deleted_at IS NULL
AND db.deleted_at IS NULL
ORDER BY products.title, CASE WHEN product_instances.stage ~* 'production' THEN 1 ELSE 2 END
