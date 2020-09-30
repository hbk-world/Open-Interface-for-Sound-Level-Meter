"""
11. Set static IP address
-----------------------------
This example shows how to change the IP address of a BK2245 device.
This example uses the device name to connect to the device and changes the ethernet IP address.
"""

import requests

deviceName = "BK2245-100091"
host = "http://" + deviceName

"""First part shows how to do it with a device on a lan connection (USB or switch) here done with USB connection"""
oldIP = requests.get(host + "/webxi/Applications/SLM/Setup/NetworkEthernetIPAddress").json()
print(f"{host} old IP ethernet: {oldIP}")

# First the device needs to be in a mode where the IP address can be set manually
response = requests.put(host + "/webxi/Applications/SLM/Setup/NetworkEthernetSetUpIP", json = 0)
response = requests.put(host + "/webxi/Applications/SLM/Setup/NetworkEthernetIPAddress", json = "169.254.3.40")

newIP = requests.get(host + "/webxi/Applications/SLM/Setup/NetworkEthernetIPAddress").json()
print(f"{host} new IP ethernet: {newIP}")

"""Second part shows how to do it with a device on a WiFi connection"""
oldIP = requests.get(host + "/webxi/Applications/SLM/Setup/NetworkWifiIPAddress").json()
print(f"{host} old IP ethernet: {oldIP}")

# First the device needs to be in a mode where the IP address can be set manually
response = requests.put(host + "/webxi/Applications/SLM/Setup/NetworkWifiSetUpIP", json = 0) 
response = requests.put(host + "/webxi/Applications/SLM/Setup/NetworkWifiIPAddress", json = "192.168.0.40")

newIP = requests.get(host + "/webxi/Applications/SLM/Setup/NetworkWifiIPAddress").json()
print(f"{host} new IP ethernet: {newIP}")