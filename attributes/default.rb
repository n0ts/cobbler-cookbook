#
# Cookbook Name:: cobbler
# Attribute:: default
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

default['cobbler'] = {
  'settings' => {
    'manage_dhcp' => 0,
    'next_server' => '127.0.0.1',
    'server' => '127.0.0.1',
    'pxe_just_once' => 0,
  },
  'dhcp' => {
    'shared-network' => '',
    'subnet' => {
      '' => {
        'netmask' => '',
        'routers' => '',
        'domain-name-servers' => [],
        'dynamic-bootp' => {
          'from' => '',
          'to' => '',
        },
      },
    },
    'dhcpargs' => '',
  },
  'reposync' => {
    'cron_hour' => 0,
  },
  'user' => {
    'name' => 'ubuntu',
    # printf "ubuntu" | mkpasswd -s -m md5
    'password' => '$1$wpMy9tRU$cAa.JyspgXVWUo5m7yCLg.',
  },
}
