import requests
from requests.auth import HTTPDigestAuth
import socket
import json

# Setup device 
ip = "169.254.3.40"
host = "http://" + ip
socket.gethostbyname(socket.gethostname())

if __name__ == "__main__":
    errorLogs = requests.get(host + "/WebXi/Device/Issues/Reports").json()
    for name,value in errorLogs.items():
        print(name)
    resp = requests.get(host + "/WebXi/Device/Issues/Reports/2020-02-11T11_39_23Z.txt")
    print(resp)
    