__author__ = 'taylor'

import json
import requests
import sys

art_url = "http://art.ccri.com:8081/artifactory/api/search/artifact/?name="

f = open(sys.argv[1])
for line in f:
    line = line.strip()
    if line.startswith("ADD"):
        output = ''
        try:
            (_, jar, rest) = line.split(' ')
            js = requests.get(art_url + jar)
            js_parse = json.loads(js.text)
            js2 = requests.get(js_parse.get('results')[0].get('uri'))
            js_parse2 = json.loads(js2.text)
            output = "ADD " + js_parse2["downloadUri"] + " " + rest

        except Exception as e:
            output = line
        print output
    else:
        print line
