"""
This example shows how to lock the measurement settings on the device. 
This is helpful when wanting to avoid changes
"""

import requests

ip = "169.254.3.40"
host = "http://" + ip

print("""Enable the service mode on the device and set a password to avoid others from opening the lock
These changes can be seen in System settings > Advanced settings
""")
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceServiceMode", json=(1))
response = requests.put(host + "/webxi/Applications/SLM/Setup/ServicePassword", json=("123"))

print("""Enable the lock settings and disable service mode
These changes can be seen in System settings > Advanced settings
""")
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceLockSetups", json=(1))
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceServiceMode", json=(0))

response = requests.put(host + "/webxi/applications/slm/setup/BBLAeq", json=True)
print(f"""It is now not possible to change measurement settings
This can be seen from sending a put request to set BBLAeq to true, resulting in the response: {response.reason}

Try to check the device and see""")
input("Press Enter to continue...\n")

print("""The device will now clear the srvice mode password and disable the lock""")
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceServiceMode", json=(1))
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceLockSetups", json=(0))
response = requests.put(host + "/webxi/Applications/SLM/Setup/ServicePassword", json=(""))
response = requests.put(host + "/WebXi/Applications/slm/Setup/ServiceServiceMode", json=(0))
print(f"""It is now possible to change measurement settings
This can be seen from sending a put request to set BBLAeq to true, resulting in the response: {response.reason}

Try to check the device and see""")