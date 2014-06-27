#
# Cookbook Name:: cobbler
# Provider:: system
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

def whyrun_supported?
  true
end

action :create  do
  converge_by("cobbler system add #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.nil?
    Chef::Log.error 'profile parameter is required' if new_resource.profile.nil?

    command = [ "cobbler system add --name='#{new_resource.name}' --profile='#{new_resource.profile}'" ]
    command << "--gateway=#{new_resource.gateway}" unless new_resource.gateway.nil?
    command << "--hostname='#{new_resource.hostname}'" unless new_resource.hostname.nil?
    command << "--kopts='#{new_resource.kopts.join(' ')}'" unless new_resource.kopts.nil?
    command << "--kopts-post='#{new_resource.kopts_post.join(' ')}'" unless new_resource.kopts_post.nil?
    command << "--ksmeta='#{new_resource.ksmeta.join(' ')}'" unless new_resource.ksmeta.nil?
    command << "--name-servers='#{new_resource.name_servers.join(' ')}'" unless new_resource.name_servers.nil?
    command << "--name-servers-search='#{new_resource.name_servers_search}'" unless new_resource.name_servers_search.nil?

    unless new_resource.virt_type.nil?
      command << "--virt-type=#{new_resource.virt_type}" unless new_resource.virt_type.nil?
      command << "--virt-cpus=#{new_resource.virt_cpus}" unless new_resource.virt_cpus.nil?
      command << "--virt-disk-driver=#{new_resource.virt_disk_driver}" unless new_resource.virt_disk_driver.nil?
      command << "--virt-file-size=#{new_resource.virt_file_size}" unless new_resource.virt_file_size.nil?
      command << "--virt-path=#{new_resource.virt_path}" unless new_resource.virt_path.nil?
      command << "--virt-ram=#{new_resource.virt_ram}" unless new_resource.virt_ram.nil?
      command << "--virt-bridge=#{new_resource.virt_bridge}" unless new_resource.virt_bridge.nil?
    end

    unless new_resource.power_type.nil?
      command << "--power-type=#{new_resource.power_type}" unless new_resource.power_type.nil?
      command << "--power-id=#{new_resource.power_id}" unless new_resource.power_id.nil?
      command << "--power-address=#{new_resource.power_address}" unless new_resource.power_address.nil?
      command << "--power-user=#{new_resource.power_user}" unless new_resource.power_user.nil?
      command << "--power-pass=#{new_resource.power_pass}" unless new_resource.power_pass.nil?
    end

    execute "cobbler system add #{new_resource.name}" do
      command command.join(' ')
      action :run
      not_if "cobbler system find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end

    unless new_resource.interface.nil?
      new_resource.interface.each do |iface, iface_v|
        command = [ "cobbler system edit --name='#{new_resource.name}' --interface=#{iface}" ]
        if iface_v.key?('ip')
          command << "--ip-address=#{iface_v['ip']}" 
          command << '--static=1'
        end
        command << "--netmask=#{iface_v['netmask']}" if iface_v.key?('netmask')

        case iface
        when /^eth.*/
          command << "--mac='#{iface_v['mac']}'" if iface_v.key?('mac')

        when /^bond.*/
          Chef::Log.error 'bond_slave is required' unless iface_v.key?('bond_slave')

          command << '--interface-type=bond'
          command << "--bonding-opts=#{iface_v['bonding_opts'].join(' ')}" if iface_v.key?('bonding_opts')
          iface_v['bond_slave'].each do |slave_iface, slave_iface_mac|
            execute "cobbler system edit #{new_resource.name} #{iface} #{slave_iface}" do
              command "cobbler system edit --name=#{new_resource.name} --interface=#{slave_iface} --mac='#{slave_iface_mac}' --interface-type=bond_slave --interface-master=#{iface}"
              action :run
              not_if "cobbler system dumpvars --name='#{new_resource.name}' | grep -P '^bonding_#{slave_iface}'"
            end
          end

        when /^br.*/
          command << '--interface-type=bridge'
          command << "--bridge-opts='#{iface_v['bridge_opts'].join(' ')}'" if iface_v.key?('bridge_opts')

          # bondig support
          if iface_v.key?('bridge') and iface_v['bridge'] =~ /bond.*/
            iface_v['bond_slave'].each do |slave_iface, slave_iface_mac|
              execute "cobbler system edit #{new_resource.name} #{iface} #{slave_iface}" do
                command "cobbler system edit --name=#{new_resource.name} --interface=#{slave_iface} --mac='#{slave_iface_mac}' --interface-type=bond_slave --interface-master=#{iface_v['bridge']}"
                action :run
                not_if "cobbler system dumpvars --name='#{new_resource.name}' | grep -P '^bonding_#{slave_iface}'"
              end
            end

            cmd = "cobbler system edit --name=#{new_resource.name} --interface=#{iface_v['bridge']} --interface-type=bonded_bridge_slave --interface-master=#{iface}"
            cmd << " --bonding-opts=#{iface_v['bonding_opts'].join(' ')}" if iface_v.key?('bonding_opts')
            execute "cobbler system edit #{new_resource.name} #{iface} #{iface_v['bridge']}" do
              command cmd
              action :run
              not_if "cobbler system dumpvars --name='#{new_resource.name}' | grep -P '^interface_type_#{iface_v['bridge']}'"
            end
          end
        end

        execute "cobbler system edit #{new_resource.name} #{iface}" do
          command command.join(' ')
          action :run
          not_if "cobbler system dumpvars --name='#{new_resource.name}' | grep -P '^interface_type_#{iface}'"
        end
      end
    end
  end
end

action :delete do
  converge_by("cobbler system remove #{new_resource.name}") do
    Chef::Log.error 'name parameter is required' if new_resource.name.empty?

    execute "cobbler system remove #{new_resource.name}" do
      command "cobbler system remove --name='#{new_resource.name}'"
      action :run
      only_if "cobbler prifle find --name='#{new_resource.name}' | grep -P '^#{new_resource.name}'"
    end
  end
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
