#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2011, 
#
# All rights reserved - Do Not Redistribute
#
package "nginx" do
  action :install
end

template "/etc/nginx/conf.d/server_names_hash_bucket_size.conf" do
  source "server_names_hash_bucket_size.conf.erb"
  mode 0644
end

vhost_conf="/etc/nginx/sites-available/vhost-#{node[:nginx][:vhost]}.conf"
template vhost_conf do
  source "nginx.conf.erb"
  variables(
    :server_name => node[:fqdn]
  )
  mode 0644
end

link "/etc/nginx/sites-enabled/vhost-#{node[:nginx][:vhost]}.conf" do
  to vhost_conf
end

service "nginx" do
  action :start
  subscribes :restart, resources(:template => vhost_conf)
end
