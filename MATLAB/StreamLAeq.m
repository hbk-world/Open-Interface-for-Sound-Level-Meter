clc; close all; clear all

% Import  the python script "pyconverter.py" for parsing the binary network
% stream recieved from the device
pyconverter  = py.importlib.import_module('pyconverter');
py.importlib.reload(pyconverter);


% Create a slm object which stores the ip of the 2245 and stores some functions 
% such as functions to start/stop the measurement and the common REST
% protocols
slm = SLM('169.254.60.175')

% Create stream with the name "MyStream" using socket interface
stream ='{"ConnectionType": "Socket", "Sequences": [6], "MessageTypes": ["SequenceData"],   "Name": "MyStream"}';
% POST the stream to 2245, the response will be an struct contining an URI
% which describes where the new stream is located
response = slm.post("/webxi/Streams",stream)
port = slm.get(response.URI + "/Port");

% Enables a recording on the 2245
slm.start_puase_measurement(true)
t = tcpip(slm.ip, port, 'NetworkRole', 'client');
t.ByteOrder = 'littleEndian';
fopen(t);

% If there is package ready, read it, parse the binary package using the python
% script and scale the value
while true
    if(t.BytesAvailable ~= 0)
        data = fread(t, t.BytesAvailable);
        package = typecast(int8(data), 'int8');
        % Call python Parse function and scale the value
        LAeq = pyconverter.Parse(package) / 100     
    end
end
