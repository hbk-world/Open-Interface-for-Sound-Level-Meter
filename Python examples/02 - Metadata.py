"""
02. Reading metadata
--------------------
"""

import requests
host = "http://10.100.38.87"

"""
DisplayScheme is a node that determines wether the display is dark or light.
This node is under "/webxi/applications/slm/setup/displayscheme"
"""
response = requests.get(host + "/webxi/applications/slm/setup/displayscheme")
print(response.text)

"""
This will either be 1 or 0 based on the current color.
To learn the meaning of 1 and 0, we need the metadata of the node.
Get this by using "?metadata" in the url. (also "indent" to make it easier to read)
"""
response = requests.get(host + "/webxi/applications/slm/setup/displayscheme?metadata&indent")
print(response.text)

