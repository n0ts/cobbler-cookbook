#
# Cookbook Name:: cobbler
# Resource:: repo
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete, :add, :remove

default_action :create

attribute :mirror, :kind_of => String, :default => nil
attribute :createrepo_flags, :kind_of => String, :default => '-c cache -d'
attribute :keep_updated, :kind_of => String, :default => 'Y'
attribute :priority, :kind_of => Fixnum, :default => 99
attribute :arch, :kind_of => String, :default => node['machine']
attribute :mirror_locally, :kind_of => String, :default => 'Y'
attribute :breed, :kind_of => String, :default => 'yum'
