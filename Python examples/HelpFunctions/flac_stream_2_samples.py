import miniaudio
import numpy as np
import tempfile

class BitBuffer:
	def __init__(self, buf):
		self.out = buf
		self.bitbuffer = 0
		self.bitbufferlen = 0

	def write_int(self, n, val):
		self.bitbuffer <<= n
		self.bitbuffer |= val & ((1 << n) - 1)
		self.bitbufferlen += n
		while self.bitbufferlen >= 8:
			self.bitbufferlen -= 8
			b = (self.bitbuffer >> self.bitbufferlen) & 0xFF
			self.out.write(bytes((b,)))
		self.bitbuffer &= (1 << self.bitbufferlen) - 1

	def close(self):
		self.out.close()

	def __enter__(self):
		return self

	def __exit__(self, type, value, traceback):
		return

def add_header(buf, BLOCK_SIZE,  NUMCHANNEL=1, BITDEPTH=24, SAMPLEDATALENGTH=4096, stream_data=0):
    # Stream
	buf.write_int(32, 0x664C6143)  # fLaC
	# METADATA_BLOCK_HEADER
	buf.write_int(1, 1)
	buf.write_int(7, 0)
	buf.write_int(24, 34)
	# METADATA_BLOCK_STREAMINFO
	buf.write_int(16, BLOCK_SIZE * 3)   # BLOCK SIZE
	buf.write_int(16, BLOCK_SIZE * 3)   # BLOCK SIZE
	buf.write_int(24, 0)                # Frame size
	buf.write_int(24, 0)                # Frame size
	buf.write_int(20, 2**16)            # SAMPLERATE
	buf.write_int(3, NUMCHANNEL - 1)   # NumChannels
	buf.write_int(5, BITDEPTH - 1)   # BIT DEPTH
	buf.write_int(36, SAMPLEDATALENGTH)
	for _ in range(16):
		buf.write_int(8, 0)

    # End flac header begin of writing data
	for t in stream_data:
	    buf.write_int(8, t)
	    
def decode(flac_stream):
    # Add the header in front of the encoded samples 
    with tempfile.TemporaryFile() as fp:
        with BitBuffer(fp) as buf:
            add_header(buf, BLOCK_SIZE=flac_stream.frame_length, stream_data = flac_stream.frame)
        fp.seek(0)
		# Decode samples  
        tmp = miniaudio.flac_read_s32(fp.read())
    # now the samples is scaled to Pa 
    samples = (np.array(tmp.samples) / 2**23)
    return samples 