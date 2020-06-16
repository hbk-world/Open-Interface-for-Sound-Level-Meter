using Kaitai;
using System;
using System.Threading;
using System.Net.WebSockets;
using System.Threading.Tasks;

namespace Websocket
{
    public class WSConnection
    {
        private ClientWebSocket ws;

        public WSConnection()
        {
            this.ws = new ClientWebSocket();

        }

        public async Task Connect(Uri uri)
        {
            while (ws.State != WebSocketState.Open)
            {
                await ws.ConnectAsync(uri, CancellationToken.None);
                Console.WriteLine("Web socket : " + ws.State);
            }
        }


        public async Task Receive_LaEQ()
        {
            ArraySegment<byte> receivedBytes = new ArraySegment<byte>(new byte[128]);
            WebSocketReceiveResult receiveResult = await ws.ReceiveAsync(receivedBytes, CancellationToken.None);

            // Create a kaitati stream
            KaitaiStream kaistream = new KaitaiStream(receivedBytes.Array);
            // This will check if the package contains magic field 
            WebxiHeader webxiHeader = new WebxiHeader(kaistream);


            if (webxiHeader.MessageType == WebxiHeader.EMessageType.ESequenceData)
            {
                // Get the sequence from the sequence
                WebxiStream.SequenceData sequenceData = new WebxiStream.SequenceData(kaistream);
                dynamic Seqblck = sequenceData.SequenceBlocks[0];

                // Convert and and scale the value 
                byte[] bytear = { Seqblck.Values[0], Seqblck.Values[1] };
                Int16 Value = BitConverter.ToInt16(bytear);
                float ScaledVal = (float)Value / 100;
                Console.WriteLine("LaEQ {0} dB", ScaledVal);
            }
        }
    }
}
