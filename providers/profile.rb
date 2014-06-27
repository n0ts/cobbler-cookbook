#
# Cookbook Name:: cobbler
# Provider:: profile
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

def whyrun_supported?
  true
end

action :create  do
  converge_by("cobbler profile add #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.nil?
    Chef::Log.error 'distro parameter is required' if new_resource.distro.nil?

    command = [ "cobbler profile add --name='#{new_resource.name}' --distro='#{new_resource.distro}'" ]
    command << "--kickstart=#{new_resource.kickstart}" unless new_resource.kickstart.nil?
    command << "--kopts='#{new_resource.kopts.join(' ')}'" unless new_resource.kopts.nil?
    command << "--kopts-post='#{new_resource.kopts_post.join(' ')}'" unless new_resource.kopts_post.nil?
    command << "--ksmeta='#{new_resource.ksmeta.join(' ')}'" unless new_resource.ksmeta.nil?
    command << "--name-servers='#{new_resource.name_servers.join(' ')}'" unless new_resource.name_servers.nil?
    command << "--name-servers-search='#{new_resource.name_servers_search}'" unless new_resource.name_servers_search.nil?
    command << "--repos='#{new_resource.repos.join(' ')}'" unless new_resource.repos.nil?
    unless new_resource.virt_type.nil?
      command << "--virt-type=#{new_resource.virt_type}" unless new_resource.virt_type.nil?
      command << "--virt-cpus=#{new_resource.virt_cpus}" unless new_resource.virt_cpus.nil?
      command << "--virt-disk-driver=#{new_resource.virt_disk_driver}" unless new_resource.virt_disk_driver.nil?
      command << "--virt-file-size=#{new_resource.virt_file_size}" unless new_resource.virt_file_size.nil?
      command << "--virt-path=#{new_resource.virt_path}" unless new_resource.virt_path.nil?
      command << "--virt-ram=#{new_resource.virt_ram}" unless new_resource.virt_ram.nil?
      command << "--virt-bridge=#{new_resource.virt_bridge}" unless new_resource.virt_bridge.nil?
    end

    execute "cobbler profile add #{new_resource.name}" do
      command command.join(' ')
      action :run
      not_if "cobbler profile find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end
  end
end

action :delete do
  converge_by("cobbler profile remove #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.empty?

    execute "cobbler profile remove #{new_resource.name}" do
      command "cobbler profile remove --name='#{new_resource.name}'"
      action :run
      only_if "cobbler profile find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end
  end
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
