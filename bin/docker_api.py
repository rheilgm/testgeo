#!/usr/bin/env python
# The unsecure client requires that your Docker daemon is listening on port 5555 in addition to the default unix socket.
# DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://127.0.0.1:5555"
# $ sudo service docker(.io) restart

__author__ = 'cott'

import docker
import getpass
from subprocess import call

geoserver_image = "user:geoserver"
accumulo_image = "user:accumulo"
yarn_image = "user:yarn"
remote_docker_daemon_host = "127.0.0.1"
unsecure_docker_port = 5555


def get_client_unsecure(host, port):
    client = docker.Client(base_url="http://%s:%s" % (host, port), version="1.10")
    return client


if __name__ == '__main__':
    # unsecured
    dc = get_client_unsecure(remote_docker_daemon_host, unsecure_docker_port)

    # print "\n---Images:\n"
    # for image in dc.images():
    #     print image
    #
    # print "\n---Containers:\n"
    # for container in dc.containers():
    #     print container
    #
    # ireport = dc.inspect_container("elegant_bohr")


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


def start_geomesa(user):
    #accumulo container
    accumulo_volumes = ['/opt/accumulo/accumulo-1.5.2/lib/ext/', '/data-dir/']
    accumulo_container = \
        dc.create_container(image=accumulo_image,
                            name=(user + 's-accumulo'),
                            tty=True,
                            stdin_open=True,
                            hostname='accumulo',
                            ports=[2181, 22, 50070, 50095, 50075, 9000],
                            volumes=accumulo_volumes,
                            mem_limit="4g")

    accumulo_binds = {
        '/home/' + getpass.getuser() + '/geomesa-docker-volumes/accumulo-libs':
        {
            'bind': '/opt/accumulo/accumulo-1.5.2/lib/ext/',
            'ro': False
        },
        '/home/' + getpass.getuser() + '/geomesa-docker-volumes/accumulo-data':
        {
            'bind': '/data-dir/',
            'ro': False
        }
    }
    dc.start(accumulo_container, publish_all_ports=True, binds=accumulo_binds)

    #YARN CONTAINER
    yarn_container = dc.create_container(image=yarn_image,
                                         name=(user + 's-yarn'),
                                         stdin_open=True,
                                         tty=True,
                                         hostname='yarn',
                                         ports=[8088, 8042, 22], mem_limit="2g")

    link = {(user + 's-accumulo'): 'accumulo'}
    dc.start(yarn_container,
             publish_all_ports=True,
             links=link)

    #geoserver container
    geoserver_container = dc.create_container(image=geoserver_image,
                                              name=(user + 's-geoserver'),
                                              stdin_open=True,
                                              tty=True,
                                              hostname='geoserver',
                                              ports=[8080, 22], mem_limit="2g")
    link = {(user + 's-accumulo'): 'accumulo', (user + 's-yarn'): 'yarn'}
    dc.start(geoserver_container,
             publish_all_ports=True,
             links=link)

start_geomesa('test')
call("./geomesa_info.py")

