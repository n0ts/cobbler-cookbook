#
# Cookbook Name:: cobbler
# Resource:: system
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

actions :create, :delete, :add, :remove

default_action :create

attribute :profile, :kind_of => String, :default => nil # required, if image not set
attribute :image, :kind_of => String, :default => nil # required, if profile not set
attribute :gateway, :kind_of => String, :default => nil
attribute :hostname, :kind_of => String, :default => nil
attribute :kickstart, :kind_of => String, :default => nil
attribute :kopts, :kind_of => Array, :default => nil
attribute :kopts_post, :kind_of => Array, :default => nil
attribute :ksmeta, :kind_of => Array, :default => nil
attribute :name_servers, :kind_of => Array, :default => nil
attribute :name_servers_search, :kind_of => String, :default => nil

attribute :power_type, :kind_of => String, :default => nil # ipmilan or drac etc...
attribute :power_id, :kind_of => String, :default => nil
attribute :power_address, :kind_of => String, :default => nil
attribute :power_user, :kind_of => String, :default => nil
attribute :power_pass, :kind_of => String, :default => nil

attribute :virt_type, :kind_of => String, :default => nil # qemu(KVM) or xenpv(Xen)
attribute :virt_cpus, :kind_of => Fixnum, :default => nil
attribute :virt_disk_driver, :kind_of => String, :default => nil
attribute :virt_file_size, :kind_of => Fixnum, :default => nil
attribute :virt_path, :kind_of => String, :default => nil
attribute :virt_ram, :kind_of => Fixnum, :default => nil
attribute :virt_bridge, :kind_of => String, :default => nil

attribute :interface, :kind_of => Hash, :default => nil
# Usage
#
# - eth0 only
# 'eth0' => {
#   :ip => '127.0.0.1',
#   :netmask => '255.255.255.0',
#   :mac => 'AA:BB:CC:DD:EE:FF',
# }
#
# - bonding
# 'bond0' => {
#   :ip => '127.0.0.1',
#   :netmask => '255.255.255.0',
#   :bond_slave => { 'eth0' => 'AA:BB:CC:DD:EE:FF, 'eth1' => 'AA:BB:CC:DD:EE:FF' },
#   :bonding_opts => [ 'mode=active-backup', 'miimon=100' ],
# }
#
# - bridge + bonding
# 'br0' => {
#   :bridge => 'bond0',
#   :ip => '127.0.0.1',
#   :netmask => '255.255.255.0',
#   :bond_slave => { 'eth0' => 'AA:BB:CC:DD:EE:FF, 'eth1' => 'AA:BB:CC:DD:EE:FF' },
#   :bonding_opts => [ 'mode=active-backup', 'miimon=100' ],
#   :bridge_opts => [ 'stp=no', 'foo=1' ],
# }

