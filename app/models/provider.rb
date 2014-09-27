require 'rake'

class Provider < ActiveRecord::Base
  attr_accessible :provider_type, :provider_id, :name

  def generate_page(name,id,type)
    load File.join(Rails.root, 'lib', 'tasks', 'page_generator.rake')
    Rake::Task["page_generator:add_provider"].invoke(name,id,type)
  end

end
