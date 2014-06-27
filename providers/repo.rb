#
# Cookbook Name:: cobbler
# Provider:: repo
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

def whyrun_supported?
  true
end

action :create  do
  converge_by("cobbler repo add #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.empty?
    Chef::Log.error 'mirror parameter is required' if new_resource.mirror.nil?

    command = [ "cobbler repo add --name='#{new_resource.name}' --mirror='#{new_resource.mirror}'" ]
    command << "--createrepo-flags='#{new_resource.createrepo_flags}'" unless new_resource.createrepo_flags.nil?
    command << "--keep-updated='#{new_resource.keep_updated}'" unless new_resource.keep_updated.nil?
    command << "--priority=#{new_resource.priority}" unless new_resource.priority.nil?
    command << "--arch='#{new_resource.arch}'" unless new_resource.arch.nil?
    command << "--mirror-locally='#{new_resource.mirror_locally}'" unless new_resource.mirror_locally.nil?
    command << "--breed='#{new_resource.breed}'" unless new_resource.breed.nil?

    execute "cobbler repo add #{new_resource.name}" do
      command command.join(' ')
      action :run
      not_if "cobbler repo find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end
  end
end

action :delete do
  converge_by("cobbler repo remove #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.empty?

    execute "cobbler repo remove #{new_resource.name}" do
      command "cobbler repo remove --name='#{new_resource.name}'"
      action :run
      only_if "cobbler repo find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end
  end
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
