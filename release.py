#!/usr/bin/python

import os, json

with open('info.json', 'r') as handle:
    info = json.loads(handle.read())
    name = info['name']
    version = info['version']

cmd = f'''cd ..
zip -r ~/.factorio/mods/{name}_{version}.zip {name} -x '*.git' -x '*.py'
'''

# Run this command
os.system(f'rm ~/.factorio/mods/{name}_*.zip')
os.system(cmd)
