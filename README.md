# mesuMat

A set of scripts and functions to do data acquisition and transfer function measurements. Three data acquisition hardwares are supported:

- National Instrument data acquisition cards

- Picoscope ps2000 or ps4000

- Soundcards

## National Instrument data acquisition cards

Only for Windows. Prerequisities are the following:

- daqmx drivers

- Data acquisition toolbox for Matlab

Instructions : add the directories sigMat and niMat in your path and run: 

ni_io

## Picoscope oscilloscope

Should work with Windows, Linux and MacOS. Only tested on Linux and Windows.

The following needs to be installed and work properly : 

- Picoscope drivers (Installing Picoscope sofwtare does the job)

- picosdk-matlab-picoscope-support-toolbox

- picosdk-ps2000-matlab-instrument-driver or picosdk-ps4000-matlab-instrument-driver

- Instrument control toolbox for Matlab

Instructions : add the directories sigMat, picoMat, picosdk-matlab-picoscope-support-toolbox and picosdk-psN000-matlab-instrument-driver in your path and run: 

pico_io

## Soundcard

Should work with Windows, Linux and MacOS. Only tested on Linux and Windows. In Linux, ALSA driver is used. In Windows, ASIO drivers are necessary.

Prerequisities:

- audio toolbox for Matlab

- A sound card with ALSA drivers (Linux) or ASIO drivers (Windows)

Instructions : add the directories sigMat and audioMat in your path and run:

audio_io



Contact : olivier.doare@ensta-paris.fr
