# This example will show how to stream multiple sequences at the same time using the same stream
# For this example enable the wanted sequences on the device
import asyncio
import requests
import threading
import sys, traceback
import numpy as np
import time
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Modules to convert webxi data
import webxi.webxi_header as webxiHead
import webxi.webxi_stream as webxiStream

import HelpFunctions.sequence_handler as seq            # Get sequences, e.g. LAeq functions
import HelpFunctions.stream_handler as stream           # SLM stream functions
import HelpFunctions.measurment_handler as meas         # Start/pause/Stop measurments functions
from HelpFunctions.Leq import MovingLeq, SLM_Setup_LAeq # Class to hold moving Leq 
import HelpFunctions.websocket_handler as webSocket     # Async functions to control communication

ip = "192.168.0.111"
host = "http://" + ip

# This example will stream 2 sequences, LAeq and LCeq. If more sequences is wanted add to this list
sequenceNames = ["LAeq", "LCeq"]

def getSequenceID(host, SqeuenceName):
    sequences = requests.get(host + "/webxi/sequences?recursive").json()
    return seq.find_sequence_by_name(SqeuenceName, sequences)

def print_data(message, IDs, sequences, sequenceFuncs):
    package = webxiStream.WebxiStream.from_bytes(message)
    if package.header.message_type == webxiStream.WebxiStream.Header.EMessageType.e_sequence_data:
        for ID, sequence, Func in zip(IDs, sequences, sequenceFuncs):
            for data in package.content.sequence_blocks:
                if data.sequence_id == ID:
                    value = stream.data_type_conv(sequence["DataType"], data.values, None)
                    value = (np.array(value) if isinstance(value, list) else value) / 100
                    move = Func.move(value)
                    seqName = sequence["Name"]
                    print(f"{seqName}: {value} and 10s avg: {move:.2f}")

async def main():
    IDs = []
    sequences = []
    sequenceFuncs = []

    for x in sequenceNames:
        ID, sequence = seq.get_sequence(host, getSequenceID(host, x))
        IDs.append(ID)
        sequences.append(sequence)
        sequenceFuncs.append(MovingLeq(10, storedata=True))

    uri = stream.setup_stream(host, ip, IDs, "MultipleSequences")
    # Start a measurement. This is needed to obtain data from the device
    meas.start_pause_measurement(host,True) 

    msg_func = lambda msg : print_data(msg, IDs, sequences, sequenceFuncs)

    await webSocket.next_async_websocket(uri, msg_func)

if __name__ == "__main__":
    asyncio.run(main())
