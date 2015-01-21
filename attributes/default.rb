
node.default['elastic_search']['cluster_name'] = nil
node.default['elastic_search']['node_name'] = node['hostname']
node.default['elastic_search']['data_path'] = "/mnt/elasticsearch/data"
node.default['elastic_search']['log_path'] = "/mnt/elasticsearch/log"
node.default['elastic_search']['security_group'] = nil
node.default['elastic_search']['region'] = 'us-east-1'
node.default['elastic_search']['s3_bucket'] = nil
node.default['elastic_search']['shard_number'] = 6
node.default['elastic_search']['min_master'] = 2
node.default['elastic_search']['disable_delete'] = 'true'
node.default['elastic_search']['concurrent_reblance'] = 2
