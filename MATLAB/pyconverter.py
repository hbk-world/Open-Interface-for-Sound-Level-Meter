# Modules to convert webxi data
import webxi.webxi_header as webxiHead
import webxi.webxi_stream as webxiStream


def Parse(message):
    """This is the function handling the data from the BK2245l"""
    package = webxiStream.WebxiStream.from_bytes(message)
    if package.header.message_type == webxiStream.WebxiStream.Header.EMessageType.e_sequence_data:
        value = package.content.sequence_blocks[0].values
        # Convert data from binary stream data to Int format
        value = data_type_conv(value, None)
        return value





def data_type_conv(value, vector_length):
    """Convert the byte data retrived from BK2245 to Int16 format\n
       The byte format is in 'little'"""
    if vector_length == None:
        return int.from_bytes(value, "little", signed=True)
    else:
        value_array = []
        for i in range(0, vector_length*2, 2):
            value_array.append(int.from_bytes(value[i:i+2], "little", signed=True))
            # print(len(value_array))
            return value_array



def test(message):
    return message