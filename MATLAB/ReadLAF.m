clear all; clc

% Set the IP the 2245
slm = SLM('169.254.60.175')
% Load webXi tree into a struct
while true
    slm.get("/webxi/applications/SLM/Outputs/LAF")/100
    pause(1)
end