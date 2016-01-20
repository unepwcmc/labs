class Domain < ActiveRecord::Base
  belongs_to :project
  has_many :models, dependent: :destroy

  def self.add_domain domain_hash
    project = Project.find_by(title: domain_hash['project_name'])
    domain = Domain.create({project_id: project.id})

    add_models(domain_hash['models'], domain)
    add_relationships(domain_hash['relationships'], domain)
    save_diagrams(project.title, domain_hash['graph'])
  end

  private

  def self.add_models models, domain
    models.each do |model_name, attributes|
      columns = attributes["columns"]
      relationships = attributes["relationships"]

      model = Model.create({domain_id: domain.id, name: model_name})
      columns.each do |name, type|
        Column.create({model_id: model.id, name: name, col_type: type})
      end
    end
  end

  def self.add_relationships relationships, domain
    relationships.each do |relationship|
      relationship["left_model"] = Model.find_by_name(relationship["left_model"]).id
      relationship["left_model_id"] = relationship.delete "left_model"
      relationship["right_model"] = Model.find_or_create_by({name: relationship["right_model"], domain_id: domain.id}).id
      relationship["right_model_id"] = relationship.delete "right_model"

      Relationship.create(relationship)
    end
  end

  def self.save_diagrams project, graph
    graph.each do |model|
      model.each do |key, value|
        domain = key.downcase
        dir = "#{Rails.root}/public/domains/#{project}"
        filename = "#{dir}/#{domain}"
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
        File.open("#{filename}.dot", 'w') { |f| f.puts value }
        system "dot -Tpng #{filename}.dot > #{filename}.png"
        File.delete("#{filename}.dot")
      end
    end
  end
end
