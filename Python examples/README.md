# Python example guide
This README will guide you through the setup process as well as how to run the different examples. 

## Requirements
1. python >= 3.6
2. See top folder README for more
3. Add git to the environment variables

It is recommended to install VSCode, Sublime Text 3, or similar to run and edit the code. To not break any Python installation it is recommended to use either a docker or a Python virtual environment to run the test, see references.

## Setup and how to run an example
To run the given examples must different Python modules be installed. To do this run the following two commands in a given terminal
```Powershell
python -m pip install -r requirements.txt
python -m pip install .
```
where python is your python environment, change this if e.g. a virtual environment is wanted or if multiple python versions are installed. It is now possible to run all of the examples using a terminal as
```Powershell
python "01 - Getting device information.py"
```
Remember to change the IP/host in each example
## Structure
This example packages consist of multiple examples where the level of complexity increases through the examples resulting in real-time streaming of LAeq. Some of the later examples will have different functions in common. Those are placed in the HelpFunctions folder.
To ease the handling of the data streamed from the device are Kaitai structs used. See references. The needed files to run the examples are already compiled and a part of this example package.

## References
1. [How to setup Python virtual environments.](https://docs.python.org/3/library/venv.html)
2. [Kaitai Struct documentation](https://kaitai.io/)
