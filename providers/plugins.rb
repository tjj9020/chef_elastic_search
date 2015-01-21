def whyrun_support?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Install #{ @new_resource }") do
      install_elasticsearch_plugin
    end
  end
end

#This is an existing method in Chef::Provider that we are overriding
def load_current_resource
  @current_resource = Chef::Resource::GbgElasticsearchPlugins.new(new_resource.name)
  Chef::Log.info "Inside load_current_resource for #{new_resource.name}"
  @current_resource.name(new_resource.name)
  @current_resource.plugin_url(new_resource.plugin_url)
  @current_resource.home_path(new_resource.home_path)
  
  Chef::Log.info "plugin url: #{new_resource.plugin_url}"

  if plugin_exists?(@current_resource.name)
    @current_resource.exists = true
  end
end

def check_plugin_binary? #We are checking to make sure elasticsearch has been installed
  plugin_bin = ::File.exists?("#{new_resource.home_path}/bin/plugin")
  if plugin_bin == true
    Chef::Log.info "Plugin binary is in #{new_resource.home_path}/bin/plugin"
  else
    Chef::Log.info "No plugin binary found..."
  end
end

def install_elasticsearch_plugin
  unless check_plugin_binary?
    Chef::Log.info "Begin installing plugin to #{new_resource.plugin_url}"
    cmd = "#{new_resource.home_path}/bin/plugin install #{new_resource.plugin_url}"
    cmd = Mixlib::ShellOut.new(cmd)
    cmd.run_command
  end
end

def plugin_exists?(name)
  plugin = ::File.directory?("#{new_resource.home_path}/plugins/#{name}")
  Chef::Log.info "Checking to see if the elasticsearch plugin exists: #{name}"
  if plugin == true
    Chef::Log.info "Plugin was found returning true"
    true
  else
    Chef::Log.info "Plugin not found returning false"
    false
  end
end
