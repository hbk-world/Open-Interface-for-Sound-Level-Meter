using System;
using System.Threading.Tasks;
using SLM;

namespace ToggleScheme
{
    class ExampleClass
    {

        static void Example(string address)
        {
            // First we create a SLM object which handles the REST requests
            Client slm = new Client(address);
            // Read the color scheme of 2245 with the HTTP GET function 
            string value = slm.WebXi("applications/slm/setup/Displayscheme").Get();
            // Deteremine the value and return the opposite
            value = (value == " 1") ? "0" : "1";
            // Change the color scheme via the HTTP PUT command 
            slm.WebXi("Applications/SLM/Setup").Put("", "{\"DisplayScheme\": " + value + "}");
        }

        static void Main(string[] args)
        {
            Console.WriteLine("DisplayScheme Example");
            Console.WriteLine("Please enter the IP address of the 2245:");
            string address = Console.ReadLine();
            Task.Run(() => Example(address)).Wait();
        }
    }
}
