#!/usr/bin/env python
import yaml
import hashlib
import os
import sys
import httplib
import json
import urllib2
from urlparse import urlparse

__author__ = 'cott'
artifactory_url = "art.ccri.com:8081"
#local download folder
local_folder = "./deps"
conn = httplib.HTTPConnection(artifactory_url)


def download(filename, remote):
    print "\nDownloading: " + remote
    req = urllib2.urlopen(remote)
    blocksize = 16 * 1024
    with open(local_folder + "/" + filename, 'wb') as fp:
        while True:
            chunk = req.read(blocksize)
            if not chunk:
                break
            fp.write(chunk)
        fp.close()


def main():
    if not os.path.exists(local_folder):
        os.mkdir(local_folder)

    # Take last arg as filename
    filename = sys.argv[-1]

    if os.path.isfile(filename):
        stream = open(filename, 'r')
        yaml_instance = yaml.safe_load(stream)
        stream.close()

        artifacts = yaml_instance["artifacts"]

        print "\nFetching Artifacts in '" + filename + "' from Artifactory... "

        #for each element in YAML...
        for artifact in artifacts:
            entry = artifact["artifact"]
            artifact_version = str(entry["version"])
            artifact_groupid = str(entry["groupid"])
            artifact_artifactid = str(entry["artifactid"])

            # Create API call
            api_call = "/artifactory/api/search/gavc?g=" + artifact_groupid\
                       + "&a=" + artifact_artifactid\
                       + "&v=" + artifact_version
            if 'classifier' in entry:
                api_call += "&c=" + str(entry["classifier"])

            # GET the results
            conn.request("GET", api_call)
            r1 = conn.getresponse()

            # If GET was Successful
            if r1.status == 200 and r1.reason == "OK":
                uris = json.loads(r1.read())["results"]

                jar_links = []

                # Omit Javadoc, Sources, POMs...Grab latest SNAPSHOT in list.

                for uri in uris:
                    link = uri["uri"]
                    if not link.endswith(".pom") \
                            and not link.endswith("-sources.jar") \
                            and not link.endswith("-javadoc.jar") \
                            and not link.endswith("-tests.jar"):
                        jar_links.append(uri)
                    else:
                        continue

                if len(jar_links) != 0:
                    link = jar_links[-1]["uri"]
                else:
                    print artifact
                    raise Exception("Failed to fetch artifact.")
                    sys.exit()
                conn.request("GET", link)
                artifact_json = conn.getresponse().read()
                artifact_props = json.loads(artifact_json)

                downloaduri = artifact_props["downloadUri"]
                md5 = artifact_props["checksums"]["md5"]
                fname = urlparse(downloaduri).path.split('/')[-1]

                #Always Download Dep, unless conditions change.
                omit_dl = False
                if os.path.exists(local_folder + "/" + fname):
                    print "\nLocal Copy of '" + fname + "' Exists, checking md5..."
                    print "Remote MD5: " + md5
                    curr_md5 = hashlib.md5(open(local_folder + "/" + fname).read()).hexdigest()
                    print " Local MD5: " + curr_md5
                    if curr_md5 == md5:
                        omit_dl = True  # conditions changed

                if not omit_dl:
                    download(fname, downloaduri)
                else:
                    print "Hashes match, omitting download..."

            else:
                print "Artifact was not found in Artifactory."

        conn.close()
        print "Done."
    else:
        print "YAML file: '" + sys.argv[-1] + "' not found."



main()
