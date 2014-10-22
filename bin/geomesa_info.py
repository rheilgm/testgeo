#!/usr/bin/env python
# This script will display container information.

import docker
import getpass

remote_docker_daemon_host = "127.0.0.1"
unsecure_docker_port = 5555


def get_client_unsecure(host, port):
    client = docker.Client(base_url="http://%s:%s" % (host, port), version="1.10")
    return client

if __name__ == '__main__':
    # unsecured but over localhost (127.0.0.1)
    dc = get_client_unsecure(remote_docker_daemon_host, unsecure_docker_port)


def hilite(string, status, bold):
    attr = []
    if status:
        # green
        attr.append('32')
    else:
        # red
        attr.append('31')
    if bold:
        attr.append('1')
    return '\x1b[%sm%s\x1b[0m' % (';'.join(attr), string)


def get_info():
    #accumulo
    print hilite("                              ~==:..=======:,,                                  ", False, True)
    print hilite("                      ========...====.==:::==~======....                        ", False, True)
    print hilite("                      ===..==.....==..:=.........===========.                   ", False, True)
    print hilite("                     ===...=......==.............==,==.....==.                  ", False, True)
    print hilite("                   ====,...:......==..............==.=......==..                ", False, True)
    print hilite("    ,===============.=,...........=................=..~..===.=....              ", False, True)
    print hilite("   =...........,==...............,,.................=....,=.:.=..======~~.      ", False, True)
    print hilite(" :............==.................=........................==,..==........===    ", False, True)
    print hilite("............=,.............................................=....==........=.=   ", False, True)
    print hilite("..................................................................=,.........=. ", False, True)
    print hilite("Docker-Geomesa successfully deployed.  Instance information is as follows...    ", False, True)

    ireport = dc.inspect_container("tests-accumulo")
    host_port = ireport['NetworkSettings']['Ports']
    print 'Namenode: http://' + remote_docker_daemon_host + ":" + host_port['50070/tcp'][0]['HostPort']
    print 'Accumulo Monitor: http://' + remote_docker_daemon_host + ":" + host_port['50095/tcp'][0]['HostPort']
    print 'Zookeeper: ' + remote_docker_daemon_host + ":" + host_port['2181/tcp'][0]['HostPort']
    print 'Username: root\nPassword: toor'
    print 'Instance Name: docker_instance'
    print 'Data Volume: /home/' + getpass.getuser() + '/geomesa-docker-volumes/accumulo-data -> accumulo:/data-dir'
    print 'Dependency Volume: /home/' + getpass.getuser() + '/geomesa-docker-volumes/accumulo-libs -> accumulo:' \
                                                            '/opt/accumulo/accumulo-1.5.2/lib/ext/'
    #yarn
    ireport = dc.inspect_container("tests-yarn")
    host_port = ireport['NetworkSettings']['Ports']
    print '\nYarn Resource Manager: http://' + remote_docker_daemon_host + ":" + host_port['8088/tcp'][0]['HostPort']
    print 'Yarn Node Manager: http://' + remote_docker_daemon_host + ":" + host_port['8042/tcp'][0]['HostPort']
    #geoserver
    ireport = dc.inspect_container("tests-geoserver")
    host_port = ireport['NetworkSettings']['Ports']
    status = '\nGeoServer Web Admin: http://' + remote_docker_daemon_host + ':' + host_port['8080/tcp'][0]['HostPort']\
        + '/geoserver/index.html' + '\nUsername: admin\nPassword: geoserver'
    print status


get_info()
