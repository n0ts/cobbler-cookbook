#
# Cookbook Name:: cobbler
# Resource:: profile
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete, :add, :remove

default_action :create

attribute :name, :kind_of => String, :default => nil # required
attribute :distro, :kind_of => String, :default => nil #required
attribute :kickstart, :kind_of => String, :default => nil
attribute :kopts, :kind_of => Array, :default => nil
attribute :kopts_post, :kind_of => Array, :default => nil
attribute :ksmeta, :kind_of => Array, :default => nil
attribute :name_servers, :kind_of => Array, :default => nil
attribute :name_servers_search, :kind_of => String, :default => nil
attribute :repos, :kind_of => Array, :default => nil

attribute :virt_type, :kind_of => String, :default => nil # qemu(KVM) or xenpv(Xen)
attribute :virt_cpus, :kind_of => Fixnum, :default => nil
attribute :virt_disk_driver, :kind_of => String, :default => nil
attribute :virt_file_size, :kind_of => Fixnum, :default => nil
attribute :virt_path, :kind_of => String, :default => nil
attribute :virt_ram, :kind_of => Fixnum, :default => nil
attribute :virt_bridge, :kind_of => String, :default => nil
