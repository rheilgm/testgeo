#!/usr/bin/env python
# THIS NEEDS TO BE RUN AS ROOT/SUDO
# This script will be used to allocate a network interface for each docker container.

# To bring a containers virtual interface down after stopping and removing the container
# run: 'ifconfig eth0:1 192.168.3.45 netmask 255.255.252.0 down' as root

__author__ = 'cott'

import subprocess
import docker

remote_docker_daemon_host = '127.0.0.1'
accumulo_image = 'user:accumulo'
container_name = 'tests'
device_name = 'em1:1'
custom_ip = '192.168.3.45'
subnet_mask = '255.255.252.0'


def create_virtual_ethernet(device, ip, netmask, linkstatus):
    proc = subprocess.Popen('sudo /sbin/ifconfig ' + device + ' ' + ip + ' netmask ' + netmask + ' ' + linkstatus,
                            shell=True, stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)

create_virtual_ethernet(device_name, custom_ip, subnet_mask, 'up')
dc = docker.Client(base_url="http://" + remote_docker_daemon_host + ":5555", version="1.10")

accumulo_container = \
    dc.create_container(image=accumulo_image,
                        name=(container_name + '-accumulo'),
                        tty=True,
                        stdin_open=True,
                        hostname='accumulo',
                        #ports=[2181, 22, 50070],
                        mem_limit="4g")

# Start container, binding ports to the virtual interface created above
custom_bindings = {
    50070: (custom_ip, 50070),
    50095: (custom_ip, 50095),
    22: (custom_ip, 22),
    2181: (custom_ip, 2181),
    9000: (custom_ip, 9000)
}

dc.start(accumulo_container, publish_all_ports=True,
         port_bindings=custom_bindings)

cinfo = dc.inspect_container(accumulo_container)
host_port = cinfo['NetworkSettings']['Ports']
#print 'Accumulo Container Networking:\n', host_port
print 'Namenode: http://' + custom_ip + ":" + host_port['50070/tcp'][0]['HostPort']
print 'Accumulo Monitor: http://' + custom_ip + ":" + host_port['50095/tcp'][0]['HostPort']
print 'Username: root\nPassword: toor'
print 'Instance Name: docker_instance'
