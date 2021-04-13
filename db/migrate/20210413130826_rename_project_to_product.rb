class RenameProjectToProduct < ActiveRecord::Migration[5.0]
  def change
    # Dependencies
    rename_column :dependencies, :master_project_id, :master_product_id
    rename_column :dependencies, :sub_project_id, :sub_product_id

    # Domains
    rename_column :domains, :project_id, :product_id

    # Installations
    rename_column :installations, :project_instance_id, :product_instance_id

    # KPIs
    rename_column :kpis, :percentage_projects_with_kpis, :percentage_products_with_kpis
    rename_column :kpis, :project_vulnerability_counts, :product_vulnerability_counts
    rename_column :kpis, :percentage_projects_with_ci, :percentage_products_with_ci
    rename_column :kpis, :percentage_projects_documented, :percentage_products_documented
    rename_column :kpis, :project_breakdown, :product_breakdown


    # Project instances
    rename_column :project_instances, :project_id, :product_id

    # Projects
    rename_column :projects, :project_leads, :product_leads
    rename_column :projects, :project_leading_style, :product_leading_style

    # Reviews
    rename_column :reviews, :project_id, :product_id

    rename_table :projects, :products
    rename_table :project_instances, :product_instances

    # Export Views
    reversible do |direction|
      direction.up { views_up }
      direction.down { views_down }
    end
  end

  def views_up
    execute "CREATE VIEW products_export AS #{view_sql('20210413142941', 'products_export')}"
    execute "CREATE VIEW combined_products_export AS #{view_sql('20210413142941', 'combined_products_export')}"
  end

  def views_down
    execute "DROP VIEW IF EXISTS combined_products_export"
    execute "DROP VIEW IF EXISTS products_export"
  end
end
