import requests
from requests.auth import HTTPDigestAuth

def start_pause_measurement(hostID,start):
    """This function starts or pause a measurement. 
    If trying to start a measurement and the device is already running 
    will this function do nothing, same for pause."""
    response = requests.get(hostID + "/webxi/Applications/SLM/State")
    print(response.json())
    if start and response.json() != "Running":
        response = requests.put(hostID + "/WebXi/Applications/SLM?Action=StartPause")
        assert(response.status_code == 200)
    elif not start and response.json() == "Running":
        response = requests.put(hostID + "/WebXi/Applications/SLM?Action=StartPause")
        assert(response.status_code == 200)

def stop_measurement(hostID):
    """Stop a measurement on the device"""
    response = requests.put(hostID + "/WebXi/Applications/SLM?Action=Stop")
    assert(response.status_code == 200)
