"""
02. Reading metadata
--------------------
"""

import requests
host = "http://bk2245-000340"

"""
We have seen how we can read information from the device.
But sometimes the way we can interpret that information can be ambiguous.
Take the example of the DisplayScheme; a node that determines wether the display is dark or light.
This node is under "/webxi/applications/slm/setup/displayscheme"
"""
response = requests.get(host + "/webxi/applications/slm/setup/displayscheme")
print(response.text)

"""
This will either be 1 or 0 based on the current color. But what does this mean? Does 1 mean Light or Dark?
To learn the meaning we need metadata of the node.
You can get this by using "?metadata" in the url. (also "indent" to make it easier to read)
"""
response = requests.get(host + "/webxi/applications/slm/setup/displayscheme?metadata&indent")
print(response.text)

