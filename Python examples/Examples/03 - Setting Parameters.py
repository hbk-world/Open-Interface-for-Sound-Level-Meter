"""
03. Setting a setup parameter
-----------------------------
"""

import requests
host = "http://10.42.0.1"

"""
We have seen how we can get the value of a given node in the tree by using an HTTP GET request.
To set the value of a node we use the HTTP PUT request with a JSON value.
We will be using the DisplayScheme node from the metadata example (remember how Light = 0 and Dark = 1)
These two program lines will read the current value, and write the "inverted" value
"""
color = requests.get(host + "/webxi/applications/slm/setup/DisplayScheme").json()
response = requests.put(host + "/webxi/applications/slm/setup/DisplayScheme", json = (1 if (color == 0) else 0))

