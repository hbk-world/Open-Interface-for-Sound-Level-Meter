# This example shows how to stream an LAeq stream with timestamps. 
# Some of the functionality to stream the timestamps can be found in example "09 - Multiple sequences"
# as the timestamps come from a stream itself.

import asyncio 
import requests
import threading
import sys, traceback
import time
import socket
from datetime import datetime

import HelpFunctions.sequence_handler as seq
from HelpFunctions.Leq import MovingLeq, SLM_Setup_LAeq 

import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np

# Modules to convert webxi data
import webxi.webxi_header as webxiHead
import webxi.webxi_stream as webxiStream
# Help functions located in HelpFunction folder
# Read these files to get examples on how to communicate with the SLM
import HelpFunctions.stream_handler as stream           # SLM stream functions
import HelpFunctions.measurment_handler as meas         # Start/pause/Stop measurments functions
import HelpFunctions.sequence_handler as seq            # Get sequences, e.g. LAeq functions
from HelpFunctions.Leq import SLM_Setup_LAeq, MovingLeq # Class to hold moving Leq 
import HelpFunctions.websocket_handler as webSocket     # Async functions to control communication

#      # Setup device 
ip = "169.254.3.40"
host = "http://" + ip
socket.gethostbyname(socket.gethostname())

# Setup streaming info. Here we will stream an LAeq stream with timestamps.
# The timestamps are obtained using the StartTime and StopTime, where the StartTime is the time at which the stream started and StopTime is the elapsed time
sequenceNames = ["LAeq", "StartTime", "ElapsedTime"]

class timeStamps:
    @property
    def StartTime(self):
        return self.__startTime
    @StartTime.setter
    def StartTime(self, Value):
        adder = (-1 * (time.timezone))
        self.__startTime = Value + adder
    @property    
    def lastTime(self):
        return datetime.utcfromtimestamp(self.__timeBuffer[-1]).strftime('%H:%M:%S')

    def __init__(self, bufferSize) -> None:
        self.__startTime = None
        self.__timeBuffer = np.zeros(bufferSize)
        print("Hej")

    def move(self, NewValue):
        NewValue = NewValue + self.StartTime
        self.__timeBuffer = np.append(self.__timeBuffer[1:], NewValue)
        return self.lastTime

def getSequenceID(host, SqeuenceName):
    sequences = requests.get(host + "/webxi/sequences?recursive").json()
    return seq.find_sequence_by_name(SqeuenceName, sequences)

def print_data(message, IDs, sequences, sequenceFuncs):
    package = webxiStream.WebxiStream.from_bytes(message)
    if package.header.message_type == webxiStream.WebxiStream.Header.EMessageType.e_sequence_data:
        for ID, sequence, Func, Name in zip(IDs, sequences, sequenceFuncs, sequenceNames):
            for data in package.content.sequence_blocks:
                if data.sequence_id == ID:
                    value = stream.data_type_conv(sequence["DataType"], data.values, None)

                    if sequence["DataType"] == "BKTimeSpan":
                        handleTimeData(value, sequence, Func, Name, sequenceFuncs)
                    else:
                        handleData(value, sequence, Func, Name, sequenceFuncs)

def handleTimeData(value, sequence, Func, Name, sequenceFuncs):
    if Name == "StartTime":
        Func.StartTime = value
    else:
        ii = sequenceNames.index("StartTime")
        Func.StartTime = sequenceFuncs[ii].StartTime
        Func.move(value)

def handleData(value, sequence, Func, Name, sequenceFuncs):
    ii = sequenceNames.index("ElapsedTime")
    value = (np.array(value) if isinstance(value, list) else value) / 100
    move = Func.move(value)
    seqName = sequence["Name"]
    print(f"{sequenceFuncs[ii].lastTime} {seqName}: {value} and 10s avg: {move:.2f}")

async def main():
    IDs = []
    sequences = []
    sequenceFuncs = []

    for x in sequenceNames:
        ID, sequence = seq.get_sequence(host, getSequenceID(host, x))
        IDs.append(ID)
        sequences.append(sequence)
        sequenceFuncs.append(MovingLeq(10, storedata=True) if sequence['DataType'] == "Int16" else timeStamps(101))

    uri = stream.setup_stream(host, ip, IDs, "MultipleSequences")
    # Start a measurement. This is needed to obtain data from the device
    meas.start_pause_measurement(host,True) 

    msg_func = lambda msg : print_data(msg, IDs, sequences, sequenceFuncs)
    
    await webSocket.next_async_websocket(uri, msg_func)

if __name__ == "__main__":
    asyncio.run(main())

