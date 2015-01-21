actions :install
default_action :install

attribute :plugin_name, :kind_of => String, :name_attribute => true
attribute :plugin_url, :kind_of => String
attribute :home_path, :kind_of => String

attr_accessor :exists
