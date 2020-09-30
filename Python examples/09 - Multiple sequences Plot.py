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

ip = "192.168.0.40"
host = "http://" + ip

# This example will stream 2 sequences, LAeq and LCeq. If more sequences is wanted add to this list
sequenceNames = ["LAeq", "LApeak"]

def getSequenceID(host, SqeuenceName):
    sequences = requests.get(host + "/webxi/sequences?recursive").json()
    return seq.find_sequence_by_name(SqeuenceName, sequences)
    
class streamHandler:

    def __init__(self, startStream = False):
        self.streamInit()
        if startStream:
            self.startStream()

    def streamInit(self):
        self.IDs = []
        self.sequences = []
        self.sequenceFuncs = []

        for x in sequenceNames:
            ID, sequence = seq.get_sequence(host, getSequenceID(host, x))
            self.IDs.append(ID)
            self.sequences.append(sequence)
            self.sequenceFuncs.append(MovingLeq(10, storedata=True, windowSize=100))

        self.uri = stream.setup_stream(host, ip, self.IDs, "MultipleSequences")
        # Start a measurement. This is needed to obtain data from the device
        meas.start_pause_measurement(host,True) 

    def startStream(self):
        self.StreamRun = True
        asyncio.run(self.runStream())

    async def runStream(self):
        loop = asyncio.get_running_loop()
        fut = loop.create_future()
        # Create lambda function to use for the stream message. In this example is a function
        # call used
        self.msg_func = lambda msg : self.print_data(msg, self.IDs, self.sequences, self.sequenceFuncs, fut) 
        # Initilize and run the websocket to retrive data
        loop.create_task(webSocket.next_async_websocket(self.uri, self.msg_func))
        await fut
        meas.stop_measurement(host)
        streamID = stream.get_stream_ID(host, "LAeqStream")
        requests.delete(host + "/WebXi/Streams/" + str(streamID)) # Cleaning up and deleting the stream used 

    def stopStream(self):
        self.StreamRun = False  

    def print_data(self, message, IDs, sequences, sequenceFuncs, fut):
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
        
        if not self.StreamRun:
            fut.set_result(True)

class FigHandler:  
   
    def __init__(self, dataHandler):
        self.fig, self.ax = plt.subplots(2,1,sharex=True, sharey=True)
        axis = np.arange(-(len(dataHandler[0].getPlotData(True)) - 1),1,1)
        self.dataHandler = dataHandler if isinstance(dataHandler, list) else [dataHandler]
        self.ln1 = []
        self.ln2 = []
        for x, ii in zip(self.dataHandler, sequenceNames):
            self.ln1.append((self.ax[0].plot(axis,x.getPlotData(True), label=ii))[0])
            self.ln2.append((self.ax[1].plot(axis,x.getPlotData(False)))[0])
        self.ax[1].set_xlim(left=np.min(axis), right=np.max(axis))
        self.ax[1].set_ylim(bottom=30, top=100)
        self.ax[0].set_ylabel("dB [SPL]")
        self.ax[1].set_xlabel("Time [s]")
        self.ax[1].set_ylabel("dB [SPL]")
        self.ax[0].set_title('Moving avaraged')
        self.ax[1].set_title('Instantaneous')
        leg = self.ax[0].legend(loc='upper left')
        self.ax[0].grid()
        self.ax[1].grid()
        self.fig.autofmt_xdate()
        self.fig.tight_layout()
        self.fig.canvas.mpl_connect('close_event', on_close)
        self.fig.canvas.set_window_title('LAeq example') 

    def _update(self, i): 
        for idx, x in enumerate(self.dataHandler):
            self.ln1[idx].set_ydata(x.getPlotData(True))
            self.ln2[idx].set_ydata(x.getPlotData(False))

    def startAnimation(self):
        self.ani = FuncAnimation(self.fig, self._update, interval=1000)                     

def on_close(event):
    streamer.stopStream()
    sys.exit(0)

if __name__ == "__main__":
    streamer = streamHandler()
    fig = FigHandler(streamer.sequenceFuncs)
    fig.startAnimation()
    threading.Thread(target=streamer.startStream).start()        
    plt.show()
