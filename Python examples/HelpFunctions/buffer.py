import numpy as np

class buffer:
    def __init__(self, size):
        self.size = size
        self.data = np.zeros(self.size)

    def append(self, x):
        """
        Adds data in the front of the buffer. Discard the oldest data if buffer is full
        """
        self.data =  np.append(self.data[-(self.size - len(x)) :: ] , x)

    def get(self):
        """
        Returns the whole buffer
        """
        return self.data

    def getPart(self, start = 2**16):
        """
        Returns X points of the newest data.
        """
        return self.data[-start :: ]

# Create databuffer to store the converted package data
DataBuffer = buffer(2**16)