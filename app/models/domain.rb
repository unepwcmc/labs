class Domain < ApplicationRecord
  belongs_to :project
  has_many :models, dependent: :destroy

  def self.add_domain domain_hash
    project = Project.find_by(title: domain_hash['project_name'])
    old_domain = Domain.find_by(project_id: project.id)
    domain = Domain.create({project_id: project.id})

    add_models_from_array(domain_hash['models'], domain)
    save_diagrams(project.title, domain_hash['graph'])
    old_domain.destroy if old_domain.present?
  end

  private

  def self.add_models_from_array models, domain
    models.each do |model|
      Model.create({domain_id: domain.id, name: model})
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
