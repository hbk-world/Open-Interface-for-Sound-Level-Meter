# MATLAB example guide

This README will guide you through the setup process as well as how to run the different examples.

## Requirements
1. MATLAB (tested in 2020b)
2. MATLAB Instrument Control Toolbox
3.  python >= 3.6

## Structure
This example packages consist of multiple examples where the level of complexity increases through the examples resulting in real-time streaming of LAeq.  There is a class called SLM which stores some help functions as starting or stopping a measurement and the methods for communicating via HTTP to the 2245.

To ease the handling of the data streamed from the device are Kaitai structs used(python). This is required to run  the example "StreamLAeq.m" and the MATLAB Instrument Control Toolbox is required for the streaming examples. See references. The needed files to run the examples are already compiled and a part of this example package. Make sure that it is possible to call python functions within MATLAB, see references for more info.

## Setup of python 
For the parser function to work, there must be installed some Python modules. To do this run the following two commands in a terminal
```Powershell
python -m pip install -r requirements.txt
python -m pip install .
```
## References
1. [MATLAB Instrument Control Toolbox](https://se.mathworks.com/products/instrument.html)
2. [Kaitai Struct documentation](https://kaitai.io/)
3. [How to use python in MATLAB](https://se.mathworks.com/help/matlab/call-python-libraries.html#:~:text=To%20call%20a%20Python%20function,data%20to%20the%20Python%20language.)