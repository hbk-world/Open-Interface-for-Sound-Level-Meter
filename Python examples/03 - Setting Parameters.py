"""
03. Setting a setup parameter
-----------------------------
"""

import requests
host = "http://10.100.38.87"

"""
To set the value of a node, use the HTTP PUT request with a JSON value.
We will be using the DisplayScheme node from the metadata example (remember how Light = 0 and Dark = 1)
These two program lines will read the current value, and write the "inverted" value
"""
color = requests.get(host + "/webxi/applications/slm/setup/DisplayScheme").json()
response = requests.put(host + "/webxi/applications/slm/setup/DisplayScheme", json = (1 if (color == 0) else 0))

