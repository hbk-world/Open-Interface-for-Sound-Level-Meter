import asyncio
import requests
import threading
import sys
import HelpFunctions.sequence_handler as seq
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np

# Modules to convert webxi data
import webxi.webxi_stream as webxiStream
# Help functions located in HelpFunction folder
# Read these files to get examples on how to communicate with the SLM
import HelpFunctions.stream_handler as stream           # SLM stream functions
# Start/pause/Stop measurments functions
import HelpFunctions.measurment_handler as meas
# Get sequences, 
import HelpFunctions.sequence_handler as seq

# Async functions to control communication
import HelpFunctions.websocket_handler as webSocket
from timeit import default_timer as timer
# Buffer and decoder for the flac stream
from HelpFunctions.buffer import DataBuffer
import HelpFunctions.flac_stream_2_samples as flac2samples
import threading

# FLAC streaming is only available on 2255
ip = "BK2255-000404"
host = "http://" + ip
sequenceID = 157

class streamHandler:
    def __init__(self, startStream=False):
        self.i = 0
        self.streamInit()
        if startStream:
            self.startStream()
    
    def decode_flac_stream(self, message, fut):
        start = timer()
        package = webxiStream.WebxiStream.from_bytes(message)
        if package.header.message_type == webxiStream.WebxiStream.Header.EMessageType.e_sequence_data:
            # Get the encoded flac block
            flac = package.content.sequence_blocks[0]          
            # Decode the compressed samples and add it to the data bufffer 
            DataBuffer.append(flac2samples.decode(flac))
            end = timer()
            total = (end - start)
            if 0.0625 < total:
                print(f"TotalTime: {total}")
        if not self.StreamRun:
            fut.set_result(True)

    def streamInit(self):
        # Enable audio recording analysis quality
        response = requests.put(f"{host}/WebXi/Applications/SLM/setup/AudioRecordingAnalysisQuality", json = 1)
        assert(response.status_code == 200)
        self.ID, self.sequence = seq.get_sequence(host, sequenceID)

        # Get URI for stream
        self.uri = stream.setup_stream(host, ip, self.ID, "Flac stream")

        # Start a measurement. This is needed to obtain data from the device
        meas.start_pause_measurement(host, True)

    def startStream(self):
        self.StreamRun = True
        asyncio.run(self.runStream())

    async def runStream(self):
        loop = asyncio.get_running_loop()
        fut = loop.create_future()
        # Create lambda function to use for the stream message. In this example is a function
        # call used
        self.msg_func = lambda msg : self.decode_flac_stream(msg, fut) 
        # Initilize and run the websocket to retrive data

        loop.create_task(webSocket.next_async_websocket(self.uri, self.msg_func))
        await fut
        meas.stop_measurement(host)
        streamID = stream.get_stream_ID(host, "flac ")
        # Cleaning up and deleting the stream used
        requests.delete(host + "/WebXi/Streams/" + str(streamID))

    def stopStream(self):
        self.StreamRun = False

class FigHandler:
    def __init__(self):

        self.ChunkToShow = 2**16
        self.fig, (self.ax1) = plt.subplots(1, 1)
        axis = np.arange(self.ChunkToShow)
        axis = np.flip(axis * -1/2**16)

       # Subplot1 Time data
        self.line1, = self.ax1.plot(axis, np.arange(self.ChunkToShow))
        self.ax1.set_xlim(left=np.min(axis), right=np.max(axis))
        self.ax1.set_ylim(bottom=-10, top=10)
        self.ax1.grid()
        self.ax1.set_xlabel("Time in seconds")
        self.ax1.set_ylabel("Pressure in pascal")
        self.fig.canvas.mpl_connect('close_event', on_close)

    def _update(self, i):
        # print("update")
        self.line1.set_ydata(DataBuffer.getPart(self.ChunkToShow))

    def startAnimation(self):
        self.ani = FuncAnimation(self.fig, self._update, interval=100)

def on_close(event):
    streamer.stopStream()
    sys.exit(0)

if __name__ == "__main__":
    streamer = streamHandler()
    fig = FigHandler()
    threading.Thread(target=streamer.startStream).start()
    threading.Thread(target=fig.startAnimation()).start()
    plt.show()
 