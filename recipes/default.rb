#
# Cookbook Name:: chef_elastic_search
# Recipe:: default
#
# Copyright (C) 2014 GENE BY GENE
#
# All rights reserved - Do Not Redistribute

node.default['elastic_search']['packages'] = %w(jdk git git)

cookbook_file "DNS File for AWS" do
  path "/etc/resolv.conf"
  source "resolv.conf"
  owner "root"
  group "root"
  mode 0644
  action :create
end

#Note, this assues that you have compiled your own java jdk-7u55 64bit jdk and created an rpm.
#It also needs to be placed into your own custom yum repository
#Sorry, I don't compile on the fly with chef.
node['elastic_search']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

link "/usr/local/bin/java" do
  to "/usr/java/jdk1.7.0_55/bin/java"
end

#Note, this assumes that you have compiled elasticsearch into your own rpm and it is available in your
#custom yum repository
package "elasticsearch" do
    action :install
end

elastic_search_plugins "cloud-aws" do
  name "cloud-aws"
  plugin_url "elasticsearch/elasticsearch-cloud-aws/2.4.1"
  home_path "/usr/share/elasticsearch"
  action :install
end

elastic_search_plugins "paramedic" do
  name "paramedic"
  plugin_url "karmi/elasticsearch-paramedic"
  home_path "/usr/share/elasticsearch"
  action :install
end

elastic_search_plugins "kopf" do
  name "kopf"
  plugin_url "lmenezes/elasticsearch-kopf/1.4.3"
  home_path "/usr/share/elasticsearch"
  action :install
end

elastic_search_plugins "analysis-phonetic" do
    name "analysis-phonetic"
    plugin_url "elasticsearch/elasticsearch-analysis-phonetic/2.4.1"
    home_path "/usr/share/elasticsearch"
    action :install
end

%w[/mnt/elasticsearch /mnt/elasticsearch/data /mnt/elasticsearch/log].each do |dir|
  directory dir do
    owner "elasticsearch"
    group "elasticsearch"
    action :create
  end
end

service "elasticsearch" do
  action [ :enable, :start ]
end

template "/etc/elasticsearch/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner "root"
  group "root"
  mode 0644
  variables ({
    :cluster_name => node['elastic_search']['cluster_name'],
    :node_name => node['elastic_search']['node_name'],
    :data_path => node['elastic_search']['data_path'],
    :log_path => node['elastic_search']['log_path'],
    :security_group => node['elastic_search']['security_group'],
    :region => node['elastic_search']['region'],
    :s3_bucket => node['elastic_search']['s3_bucket'],
    :shard_number => node['elastic_search']['shard_number'],
    :min_master => node['elastic_search']['min_master'],
    :disable_delete => node['elastic_search']['disable_delete'],
    :concurrent_rebalance => node['elastic_search']['concurrent_rebalance']

   })
   action :create
   notifies :restart, "service[elasticsearch]", :delayed
end

