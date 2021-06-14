SELECT
  products.id,
  products.title,
  products.url,
  products.description,
  products.internal_description,
  ARRAY_TO_STRING(external_clients, ', ') AS external_clients,
  ARRAY_TO_STRING(internal_clients, ', ') AS internal_clients,
  ARRAY_TO_STRING(product_leads, ', ') AS product_leads,
  products.current_lead,
  ARRAY_TO_STRING(developers, ', ') AS developers,
  products.expected_release_date,
  products.state,
  products.user_access,
  COUNT(product_instances.id) AS instances,
  products.github_identifier,
  products.rails_version,
  products.ruby_version,
  products.postgresql_version,
  ARRAY_TO_STRING(other_technologies, ', ') AS other_technologies,
  products.dependencies,
  products.background_jobs,
  products.cron_jobs,
  products.hacks,
  ARRAY_TO_STRING(slave_products.master_names, ', ') AS master_products,
  ARRAY_TO_STRING(master_products.slave_names, ', ') AS slave_products,
  to_char(products.created_at,'YYYY-MM-DD HH:MM') AS created_at,
  to_char(products.updated_at,'YYYY-MM-DD HH:MM') AS updated_at
FROM products
LEFT OUTER JOIN product_instances ON product_instances.product_id = products.id AND product_instances.deleted_at IS NULL
LEFT JOIN (
  SELECT d.sub_product_id AS slave_id,
  ARRAY_AGG(p.title) AS master_names
  FROM dependencies d JOIN products p ON p.id = d.master_product_id
  GROUP BY d.sub_product_id
) slave_products ON slave_products.slave_id = products.id
LEFT JOIN (
  SELECT d.master_product_id AS master_id,
  ARRAY_AGG(p.title) AS slave_names
  FROM dependencies d JOIN products p ON p.id = d.sub_product_id
  GROUP BY d.master_product_id
) master_products ON master_products.master_id = products.id
GROUP BY products.id, slave_products.master_names, master_products.slave_names
ORDER BY products.title