clear all; close all; clc

% Construct SLM object
slm = SLM('169.254.60.175')

% Load all of webxi into a struct and find a value 
    % webxi = slm.get('/webxi?recursive');
    % DisplayScheme_before = webxi.Applications.SLM.Setup.DisplayScheme

% Get single value from WebXI tree
colorBefore = slm.get('/webxi/Applications/SLM/Setup/DisplayScheme')

% Toggle scheme value
if colorBefore == 1;  Color = 0; else Color = 1; end

% HTTP PUT to 2245
slm.put("/webxi/Applications/SLM/Setup/DisplayScheme",Color);

% Get the updated value
colorNow = slm.get('/webxi/Applications/SLM/Setup/DisplayScheme')