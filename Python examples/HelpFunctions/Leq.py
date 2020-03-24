import numpy as np


class MovingLeq:
    """Class to create a moving Leq object.\n
       Stores a window of Leq logging intervals to be combined into a total Leq\n
       Calling move(new_interval) on the object will overwrite the oldest value in the       
       window, recalculate the total Leq and return it."""

    def __init__(self, window_length_sec):
        self.window_length = window_length_sec

        # Intialize an empty array, index to track oldest value, and window status
        self.leq_window = np.zeros(window_length_sec)
        self.oldest_value_index = 0
        self.leq_total = 0.0
        self.window_full = False

    def total_leq(self,window):
        """ Function to combine several Leq periods into a total Leq, as per:\n
            10 * log10(10^(L1/10) + 10^(L2/10) + ... 10^(Ln/10) / n)"""
        sound_Pa = np.sum(np.power(10,window/10)) / len(window)
        return 10 * np.log10(sound_Pa)

    def move(self, new_value):
        """Overwrite the oldest value in the array with the new logging interval
         and update the oldest value index to point to the next oldest value"""
        self.leq_window[self.oldest_value_index] = new_value
        self.oldest_value_index += 1
        
        # Calculate the total Leq for the moving window and return it.
        if self.window_full:            
            self.leq_total = self.total_leq(self.leq_window)
            self.oldest_value_index = self.oldest_value_index % self.window_length
            return self.leq_total

        # If the moving window is not full of measured data, simply calculate total Leq
        # for the data that is in the window (and ignore the empty part of the array)
        else:
            self.leq_total = self.total_leq(self.leq_window[:self.oldest_value_index])

            #self.leq_total = 10 * math.log((sum(pow(10,(self.leq_window[:self.oldest_value_index]/10)))/self.oldest_value_index),10)
            self.oldest_value_index = self.oldest_value_index % self.window_length
            if self.oldest_value_index == self.window_length - 1:
                self.window_full = True
            return self.leq_total
