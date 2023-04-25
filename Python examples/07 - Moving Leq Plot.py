import asyncio 
import requests
import threading
import sys, traceback
import time

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
from HelpFunctions.Leq import MovingLeq, SLM_Setup_LAeq # Class to hold moving Leq 
import HelpFunctions.websocket_handler as webSocket     # Async functions to control communication

ip = "192.168.0.40"
host = "http://" + ip
sequenceID = 6

leq_10_mov = MovingLeq(10, storedata=True)

class streamHandler:

    def __init__(self, startStream = False):
        self.streamInit()
        if startStream:
            self.startStream()

    def print_LAeq_mov(self, message, data_type, leq_mov, fut):
        """This is the function handling the data from the BK2245\n
        This function prints the data to the terminal in the format:\n
        "LAeq: Inst_Val | LAeq,mov,10s: AVG_Val"""
        package = webxiStream.WebxiStream.from_bytes(message)
        if package.header.message_type == webxiStream.WebxiStream.Header.EMessageType.e_sequence_data:
            value = package.content.sequence_blocks[0].values
            # Convert data from binary stream data to Int format
            LAeq_value = stream.data_type_conv(data_type, value, None) / 100 
            LAeq_mov_value = leq_mov.move(LAeq_value)
            print("LAeq: " + "%.1f" % LAeq_value + "  |  LAeq,mov,10s: " + "%.1f" % LAeq_mov_value)
            
        if not self.StreamRun:
            fut.set_result(True)

    def streamInit(self):
        SLM_Setup_LAeq(host)
        self.ID, self.sequence = seq.get_sequence(host, sequenceID)
        # Get datatype of the logging data 
        self.data_type = self.sequence["DataType"]  

        # Get URI for stream
        self.uri = stream.setup_stream(host,ip,self.ID,"LAeqStream")  

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
        self.msg_func = lambda msg : self.print_LAeq_mov(msg, self.data_type, leq_10_mov, fut) 
        # Initilize and run the websocket to retrive data
        loop.create_task(webSocket.next_async_websocket(self.uri, self.msg_func))
        await fut
        meas.stop_measurement(host)
        streamID = stream.get_stream_ID(host, "LAeqStream")
        requests.delete(host + "/WebXi/Streams/" + str(streamID)) # Cleaning up and deleting the stream used        

    def stopStream(self):
        self.StreamRun = False  

class FigHandler:  
   
    def __init__(self, dataHandler):
        self.fig = plt.figure()
        self.ax = self.fig.subplots(2,1,sharex=True, sharey=True)
        axis = np.arange(-(len(dataHandler.getPlotData(True)) - 1),1,1)
        self.dataHandler = dataHandler
        self.ln1, = self.ax[0].plot(axis,dataHandler.getPlotData(True))
        self.ln2, = self.ax[1].plot(axis,dataHandler.getPlotData(False))
        self.ax[1].set_xlim(left=np.min(axis), right=np.max(axis))
        self.ax[1].set_ylim(bottom=30, top=100)
        self.ax[0].set_ylabel("dB [SPL]")
        self.ax[1].set_xlabel("Time [s]")
        self.ax[1].set_ylabel("dB [SPL]")
        self.ax[0].set_title('Moving avaraged LAeq')
        self.ax[1].set_title('Instantaneous LAeq')
        self.ax[0].grid()
        self.ax[1].grid()
        self.fig.canvas.mpl_connect('close_event', on_close)
        self.fig.canvas.manager.set_window_title('LAeq example') 

    def _update(self, i): 
        self.ln1.set_ydata(self.dataHandler.getPlotData(True))
        self.ln2.set_ydata(self.dataHandler.getPlotData(False))

    def startAnimation(self):
        self.ani = FuncAnimation(self.fig, self._update, interval=1000)                     

def on_close(event):
    streamer.stopStream()
    sys.exit(0)

if __name__ == "__main__":
    streamer = streamHandler()
    fig = FigHandler(leq_10_mov)
    fig.startAnimation()
    threading.Thread(target=streamer.startStream).start()        
    plt.show()
    