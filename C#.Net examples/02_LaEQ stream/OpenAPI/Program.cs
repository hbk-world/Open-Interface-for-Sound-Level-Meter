using System;
using System.Threading.Tasks;
using SLM;
using Websocket;

namespace OpenAPI
{
    class ExampleClass
    {
        static async Task Example(string address)
        {
            // Initilaze The SLM object 
            Client slm = new Client(address);

            // Setup of the SLM, certain modes is needed to perform the LAeq measuremet
            slm.Setup();

            // The sequenceID of LAeq measurement
            string ID = "6";

            // Get the sequence eqaul to to the ID and read the data type
            dynamic sequence = slm.get_sequence(ID);
            string datatype = sequence["DataType"];

            // Setup of stream with the ID and the stream name "TestStream"
            string uri = slm.setup_stream(ID, "TestStream");

            // When stream is configured a Uri to the corresponding stream is returned. Combine with the IP address of the 2245
            Uri streamUri = new Uri("ws://" + address + uri);

            // For any data to present it is required to start a recording
            slm.MeasState("start");

            // Open a websocket and connect with the obtained URI
            WSConnection wSConnection = new WSConnection();
            await wSConnection.Connect(streamUri);

            int i = 0;
            while (i <= 10)
            {
                await wSConnection.Receive_LaEQ();
                i++;
            }

            slm.MeasState("stop");
        }


        static void Main()
        {
            Console.WriteLine("Streaming Example");
            Console.WriteLine("Please enter the IP address of the SLM:");
            string address = Console.ReadLine();
            Task.Run(async () => await Example(address)).Wait();
        }
    }
}

