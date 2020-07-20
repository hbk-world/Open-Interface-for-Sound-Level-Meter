// C# .Net sample code, to demonstrate how to use mDNS to browse for 2245 SLM devices on the network
// The sample code is using features from the Universal Windows Platform (UWP API) and will as such only run on Windows 10
//   1. Add Nuget package "Microsoft.Windows.SDK.Contracts"
//   2. If the project includes a "packages.config" file, then right-click "packages.config" and select "Migrate packages.config to PackageReference..."

using System;
using System.Collections.Generic;
using System.Threading;
using Windows.Devices.Enumeration;

class DeviceBrowser
{
    static void Main()
    {
        // The GUID of the "DNS Service Discovery"
        var dnsSdProtocol = new Guid("{4526e8c1-8aac-4153-9b16-55e86ada0e54}");
        // The ID of the devices to look for
        // The 2245 SLM is identified as a "_web-xi.tcp" device
        var serviceName = "_web-xi._tcp";

        var queryString = string.Format(
            "System.Devices.AepService.ProtocolId:={{{0}}} " +
            "AND System.Devices.Dnssd.Domain:=\"local\" " +
            "AND System.Devices.Dnssd.ServiceName:=\"{1}\"",
            dnsSdProtocol, serviceName
        );

        var watcher = DeviceInformation.CreateWatcher(queryString,
            new string[] {
                "System.Devices.Dnssd.HostName",
                "System.Devices.IpAddress" },
            DeviceInformationKind.AssociationEndpointService
        );

        watcher.Added += (sender, args) => { OnDevice(args.Properties); };
        watcher.Updated += (sender, args) => { OnDevice(args.Properties); };

        Console.WriteLine("Browsing for devices...");

        watcher.Start();

        // Give the watcher a chance to listen and update output (via 'OnDevice')
        Thread.Sleep(10000);

        Console.WriteLine("Done.");
    }

    // Method will be called everytime a "_web-xi.tcp" device has been found
    static void OnDevice(IReadOnlyDictionary<string, object> props)
    {
        var name = props["System.Devices.Dnssd.HostName"] as string;
        var addrs = props["System.Devices.IpAddress"] as string[];

        foreach (var addr in addrs)
        {
            Console.WriteLine("Found WebXi device {0} at {1}", name, addr);
        }
    }
}