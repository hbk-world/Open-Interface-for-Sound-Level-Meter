using System;
using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using Requests;

namespace SLM
{
    public class Client
    {
        public class RestClient : RestRequest
        {
            public RestClient(string s)
            {
                base.ResourcePath = s;
            }
        }

        public Client(string address)
        {
            m_address = address;
            m_uri = "http://" + address + "/webxi";
        }
        public string m_uri;
        public string m_address;
        private static Logger m_logger = Logger.Create(typeof(RestRequest));

        public RestClient WebXi(string s)
        {
            return new RestClient(m_uri + "/" + s);
        }


        public void Setup()
        {
            // Enable logging mode
            this.WebXi("Applications/SLM/Setup").Put("", "{\"ControlLoggingMode\": 1}");
            // Enable LAeq mode on the device
            this.WebXi("Applications/SLM/Setup").Put("", "{\"BBLAeq\": true}");
        }


        public dynamic get_sequence(string ID)
        {
            // Get all sequences avaible on the 2245
            string response = this.WebXi("sequences?recursive").Get();
            // The response is a JSON object, which is serilazied 
            var sequences = JsonConvert.DeserializeObject<Dictionary<string, Dictionary<string, Dictionary<string, Dictionary<string, dynamic>>>>>(response);

            // Now we find the sequence with specific sequenceID 
            foreach (var item in sequences)
            {
                foreach (var type in item.Value)
                {
                    try
                    {
                        //Console.WriteLine(type.Value[ID].Values);
                        dynamic obj = type.Value[ID];
                        return obj;
                    }
                    catch { }
                }
            }
            return null;
        }

        public string setup_stream(string sequenceID, string Name)
        {
            // Constuct the JSON object which specify the stream
            string body = "{\"ConnectionType\": \"WebSocket\"," +
                " \"Sequences\": [" + sequenceID + "]," +
                " \"MessageTypes\":[\"SequenceData\"], " +
                " \"Name\": \"" + Name + "\"}";

            // Send the the stream configuration, the response is a Uri which contain the info about the stream
            string response = this.WebXi("Streams").Post("", body);

            // Convert the JSON response into a dictonary
            var dictionary = JsonConvert.DeserializeObject<Dictionary<string, ArrayList>>(response);
            if (dictionary.ContainsKey("Error"))
                throw new NotImplementedException();

            // Get Uri  
            var uri = dictionary["URI"][0].ToString();
            return uri;
        }



        public void MeasState(string option)
        {
            // Get current measuring state
            string response = this.WebXi("Applications/SLM/State").Get();

            if (option == "start" & response != "Running")
            {
                this.WebXi("Applications/SLM").Put("Action=StartPause", "");
            }
            else if (option == "pause" & response == "Running")
            {
                this.WebXi("Applications/SLM").Put("Action=StartPause", "");
            }
            else if (option == "stop")
            {
                this.WebXi("Applications/SLM").Put("Action=Stop", "");
            }
        }
    }
}
