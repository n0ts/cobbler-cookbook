#
# Cookbook Name:: cobbler
# Recipe:: default
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

node.default['cobbler']['settings']['default_password_crypted'] = `openssl passwd -1 -salt 'cobbler' 'password'`.chomp

node.override['apache']['proxy']['allow_from'] = 'all'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_wsgi'
apache_module 'version'
include_recipe 'apache2'


%w{
  cman
  cobbler
  cobbler-web
  debmirror
  dhcp
  pykickstart
  yum-utils
}.each do |pkg, ver|
  package pkg do
    action :install
    version ver if ver && ver.length > 0
  end
end

service 'cobblerd' do
  supports :status => true, :restart => true
  action [:enable, :start]
  notifies :run, 'execute[cobbler-get-loaders]'
end

cron 'cobbler-reposync' do
  command '/usr/bin/cobbler reposync --tries=3 --no-fail > /dev/null 2>&1'
  hour node['cobbler']['reposync']['cron_hour']
  minute 15
  action :create
  only_if { node['cobbler']['reposync']['cron_hour'] != 0 }
end

execute 'cobbler-sync' do
  command 'cobbler sync'
  action :nothing
end

template '/etc/cobbler/settings' do
  source 'settings.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, 'service[cobblerd]'
end

execute 'cobbler-get-loaders' do
  command 'cobbler get-loaders'
  action :run
  not_if { ::File.exists?('/var/lib/cobbler/loaders/README') }
end

template '/etc/cobbler/pxe/pxedefault.template' do
  source 'pxedefault.template.erb'
  action :create
end

template '/etc/cobbler/dhcp.template' do
  source 'dhcp.template.erb'
  action :create
  notifies :run, 'execute[cobbler-sync]'
  only_if { node['cobbler']['settings']['manage_dhcp'] == 1 }
end

template '/etc/sysconfig/dhcpd' do
  source 'dhcpd.erb'
  action :create
  only_if { node['cobbler']['settings']['manage_dhcp'] == 1 }
end

template '/etc/cobbler/rsync.exclude' do
  source 'rsync.exclude.erb'
  action :create
end

cookbook_file '/etc/xinetd.d/rsync' do
  source 'rsync'
  action :create
end

template '/var/lib/cobbler/kickstarts/centos.ks' do
  source 'centos.ks.erb'
  action :create
end

template '/var/lib/cobbler/kickstarts/server.preseed' do
  source 'server.preseed.erb'
  action :nothing ## FIXME
end

directory '/usr/local/etc/cobbler' do
  action :create
end

template '/usr/local/etc/cobbler/import.sh' do
  source 'import.sh.erb'
  mode 0755
  action :create_if_missing
end

directory '/var/lib/cobbler/snippets/local' do
  mode 0755
  action :create
end

remote_directory '/var/lib/cobbler/snippets/local-centos.d' do
  source 'centos'
  action :create
end

remote_directory '/var/lib/cobbler/snippets/local-debian.d' do
  source '/debian'
  action :nothing ## FIXME
end

template '/usr/local/bin/generate_passwd.py' do
  source 'generate_passwd.py.erb'
  action :create
end
