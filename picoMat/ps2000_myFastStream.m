%% myfaststream_ps2000_io.m 
%
% Acquisition script for Picoscope PS2000 Matlab
%
% Adapted from picotech examples
%
% v0.01 - March, 9th 2020 - O. Doaré - olivier.doare@ensta-paris.fr

clc;

close all;

PS2000Config;

%% Convert index range to numerical range
channelRanges = [10e-3;20e-3;50e-3;100e-3;200e-3;500e-3;1; 2; 5;10;20] ;
mesu.inNumRange{1} = channelRanges(mesu.inRange{1}+1) ;
mesu.inNumRange{2} = channelRanges(mesu.inRange{2}+1) ;

%% Introduce some siggen variables
mesu.sgNumstep = 100 ;
mesu.sgIncrement = (mesu.sgEndFrequency-mesu.sgStartFrequency)/mesu.sgNumstep ;
mesu.sgStepDuration = mesu.duration/mesu.sgNumstep/mesu.sgRepetitions/2 ;

%% Other variables
mesu.numSamplesPerAggregate = 1 ;
mesu.inEnable{1} = 1 ;
mesu.inEnable{2} = 1 ;

% Compute effective sampling parameters

mesu.effectiveTimestep = ( mesu.Fs * mesu.upSample ...
    * mesu.numSamplesPerAggregate )^-1 ;
mesu.effectiveNSamples = mesu.duration * mesu.Fs ...
    * mesu.upSample * mesu.numSamplesPerAggregate ;

% Channel Settings

% Channel A
ps2000ConfigInfo.channelSettings.channelA.inEnabled = mesu.inEnable{1};
ps2000ConfigInfo.channelSettings.channelA.dc = mesu.inCoupling{1};
ps2000ConfigInfo.channelSettings.channelA.inRange = mesu.inRange{1};

% Channel B
ps2000ConfigInfo.channelSettings.channelB.inEnabled = mesu.inEnable{2};
ps2000ConfigInfo.channelSettings.channelB.dc = mesu.inCoupling{2};
ps2000ConfigInfo.channelSettings.channelB.inRange = mesu.inRange{2};

%% Device Connection

% Create a device object. 
ps2000DeviceObj = icdevice('picotech_ps2000_generic.mdd');

% Connect device object to hardware.
connect(ps2000DeviceObj);

%% Obtain Device Groups
% Obtain references to device groups to access their respective properties
% and functions.

% Block specific properties and functions are located in the Instrument
% Driver's Block group.

blockGroupObj = get(ps2000DeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);

% Streaming specific properties and functions are located in the Instrument
% Driver's Streaming group.

streamingGroupObj = get(ps2000DeviceObj, 'Streaming');
streamingGroupObj = streamingGroupObj(1);

% Trigger specific properties and functions are located in the Instrument
% Driver's Trigger group.

triggerGroupObj = get(ps2000DeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);

%%
% Set channels - channel information is loaded from the PS2000Config file:

% Channel     : 0 (ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_A)
% Enabled     : 0 or 1
% DC          : 0 or 1
% Range       : value

[status.setChA] = invoke(ps2000DeviceObj, 'ps2000SetChannel',...
    ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_A, ...
    ps2000ConfigInfo.channelSettings.channelA.inEnabled,...
    ps2000ConfigInfo.channelSettings.channelA.dc, ...
    ps2000ConfigInfo.channelSettings.channelA.inRange);

% Obtain the voltage range for the channel (in millivolts).

chARangeMv = PicoConstants.SCOPE_INPUT_RANGES(ps2000ConfigInfo.channelSettings.channelA.inRange + 1);

% Channel     : 1 (ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_B)
% Enabled     : 0 or 1
% DC          : 0 or 1
% Range       : value

[status.setChB] = invoke(ps2000DeviceObj, 'ps2000SetChannel',...
    ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_B, ...
    ps2000ConfigInfo.channelSettings.channelB.inEnabled, ...
    ps2000ConfigInfo.channelSettings.channelB.dc, ...
    ps2000ConfigInfo.channelSettings.channelB.inRange);    

% Obtain the voltage range for the channel (in millivolts).

chBRangeMv = PicoConstants.SCOPE_INPUT_RANGES(ps2000ConfigInfo.channelSettings.channelB.inRange + 1);

% Find the maximum ADC Count from the driver.

maxADCCount = get(ps2000DeviceObj, 'maxADCValue');

%%
% Set sampling interval and number of samples to collect:

% Set sampling interval. The driver will calculate the nearest sampling
% interval that is relatively shorter if an exact match cannot be found.
% Sampling rates faster than 1MS/s are not recommended as these are low
% memory devices.

% Set the sampling interval.

set(streamingGroupObj, 'streamingIntervalMs', mesu.effectiveTimestep*1000);

fprintf('Sampling interval: %.6f ms.\n', mesu.effectiveTimestep*1000);

% Collect samples from the driver
set(ps2000DeviceObj, 'numberOfSamples', mesu.effectiveNSamples);

% Set the size of the overview buffer used for streaming capture.
% This is the size of the internal buffer for each channel and should be
% large enough to accomodate the data that is collected in the time it
% takes to execute an iteration of the loop below.
set(streamingGroupObj, 'overviewBufferSize', 100000);

%%
% Trigger setup:

% Turn trigger off. 
[status.setTriggerOff] = invoke(triggerGroupObj, 'setTriggerOff');

%% Set Application Buffers
% The data for each channel will be collected into a corresponding
% application buffer.
%
% Ensure application buffers are large enough to accomodate pre- and
% post-trigger samples, as Data collection will stop if the application
% buffer becomes full.
%
% If capturing data without using the autoStop flag, or if using a trigger
% with the autoStop flag, allocate sufficient space (1.5 times the sum of
% the number of pre-trigger and post-trigger samples is shown below) to
% allow for additional pre-trigger data. Pre-allocating the array is more
% efficient than using vertcat to combine data.
%
% The maximum array size will depend on PC's resources - type
% <matlab:doc('memory') |memory|> at the MATLAB command prompt for further
% information.

appBufferSize = mesu.effectiveNSamples * 1.5;

pAppBufferChA = libpointer('int16Ptr', zeros(appBufferSize, 1, 'int16'));
pAppBufferChB = libpointer('int16Ptr', zeros(appBufferSize, 1, 'int16'));

% Set the application buffers in the underlying wrapper library.

invoke(streamingGroupObj, 'setBuffer',...
    ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_A,...
    pAppBufferChA,...
    appBufferSize);

invoke(streamingGroupObj, 'setBuffer',...
    ps2000Enuminfo.enPS2000Channel.PS2000_CHANNEL_B,...
    pAppBufferChB,...
    appBufferSize);

%% Fast Streaming Data Collection
% Collect data in fast streaming mode. As no trigger is set, but the auto
% stop feature is used, data collection will stop when the number of
% specified samples has been collected. Data will be plotted as it is
% collected if the User chooses to do so when prompted.
%
% *Note:* When plotting live data, there may be small amounts of 'missing'
% data. This is likely to be due to the wrapper/driver interaction and how
% the streaming data collection works. The data should be present when it
% is displayed in the final (second) plot.

% Prompt User to indicate if they wish to plot live streaming data.

switch mesu.displayLiveData
    case -1
        plotLiveData = questionDialog('Plot live streaming data?', 'Streaming Data Plot');
    case 0
        plotLiveData = PicoConstants.FALSE ;
    case 1
        plotLiveData = PicoConstants.TRUE ;
end

if mesu.sg
    %%% SIGGEN part

    %% Obtain Signal Generator Group Object
    % Signal Generator properties and functions are located in the Instrument
    % Driver's Signalgenerator group.

    sigGenGroupObj = get(ps2000DeviceObj, 'Signalgenerator');
    sigGenGroupObj = sigGenGroupObj(1);

    set(sigGenGroupObj, 'offsetVoltage', 0);
    set(sigGenGroupObj, 'peakToPeakVoltage', 2*1000*mesu.sgAmplitude);
    set(sigGenGroupObj, 'startFrequency', mesu.sgStartFrequency);
    set(sigGenGroupObj, 'stopFrequency', mesu.sgEndFrequency);

    [status.sigGenSimple] = invoke(sigGenGroupObj,...
        'ps2000SetSigGenBuiltIn', ...
        ps2000Enuminfo.enPS2000WaveType.PS2000_SINE,...
        mesu.sgIncrement,...
        mesu.sgStepDuration,...
        2,...
        0);
    %%% End od SIGGEN part
end


if(plotLiveData == PicoConstants.TRUE)
   
    disp('Live streaming data collection with second plot on completion.');
    
else
    
    disp('Streaming data plot on completion.');
    
end

% Start the device collecting data.
[status.runStreamingNs] = invoke(streamingGroupObj,...
    'ps2000RunStreamingNs', mesu.numSamplesPerAggregate);

disp('Collecting fast streaming data...');
fprintf('Click the STOP button to stop capture or wait for auto stop if enabled.\n\n') 

% Variables to be used when collecting the data
hasAutoStopped      = PicoConstants.FALSE;
isAppBufferFull     = PicoConstants.FALSE;
totalSamples        = 0;
previousTotal       = 0; % Keep track of previous total.
hasTriggered        = 0; % To indicate if trigger has occurred.
triggeredAtIndex    = 0; % The index in the overall buffer where the trigger occurred.

% Stop button to check abort data collection.
[stopFig.h, stopFig.h] = stopButton();   

flag = 1; % Use flag variable to indicate if stop button has been clicked (0)
setappdata(gcf, 'run', flag);

% Plot Properties - these are for displaying data as it is collected.

if(plotLiveData == PicoConstants.TRUE)
    
    % Plot on a single figure set(streamingGroupObj, 'streamingIntervalMs', 20e-3);
    figure1 = figure(100);
    clf ;

    axes1 = axes('Parent', figure1);

    % Estimate x-axis limit to try and avoid using too much CPU resources
    % when drawing - use max voltage range selected if plotting multiple
    % channels on the same graph.
    
    xlim(axes1, [0 (mesu.effectiveTimestep*1000 * mesu.effectiveNSamples)]);

    yRange = max(chARangeMv, chBRangeMv) + 500;
    ylim(axes1,[(-1 * yRange) yRange]);

    hold(axes1,'on');
    grid(axes1, 'on');

    title(axes1, 'Live Fast Streaming Data Acquisition');
    xLabelStr = 'Time (ms)';
    xlabel(axes1, xLabelStr);
    ylabel(axes1, 'Voltage (mV)');
    
end

% Collect samples as long as the autoStop flag has not been set, the  or the call
% to getStreamingLatestValues does not return an error code (check for STOP
% button push inside loop).
while(hasAutoStopped == PicoConstants.FALSE && isAppBufferFull == PicoConstants.FALSE)

    ready = 0;
    
    % Poll the device
    while(ready == PicoConstants.FALSE)

        invoke(streamingGroupObj, 'pollFastStreaming');

        ready = invoke(streamingGroupObj, 'isFastStreamingReady');
        
        % Give option to abort data collection from here.
        flag = getappdata(gcf, 'run');
        drawnow;

        if(flag == 0)

            disp('STOP button clicked - aborting data collection.')
            break;

        end

        if(plotLiveData == PicoConstants.TRUE)

            drawnow;

        end
        
    end

    % Retrieve fast streaming information.
    [totalValues, overflow, triggeredAt, hasTriggered, hasAutoStopped, ...
        isAppBufferFull, startIndex] = invoke(streamingGroupObj, 'getFastStreamingDetails');
    
    if(previousTotal ~= totalValues)

        % Outputting to command line window may hinder performance.
        %fprintf('Num values: %d Total - %d\n', previousTotal, totalSamples);
        
        if(hasTriggered)

            % Offset by 1 as MATLAB does not use zero based indexing.
            triggeredAtIndex = previousTotal + triggeredAt + 1; 

        end

        % Position indices of data in the buffer(s).
        firstValuePosn = startIndex + 1;
        
        % Convert data values to millivolts from the application buffer(s).
        bufferChAmV = adc2mv(pAppBufferChA.Value(firstValuePosn:totalValues), chARangeMv, maxADCCount);
        bufferChBmV = adc2mv(pAppBufferChB.Value(firstValuePosn:totalValues), chBRangeMv, maxADCCount);
        
        if(plotLiveData == PicoConstants.TRUE)

            % Time axis.
            % Multiply by ratio mode as samples get reduced.
            time = (double(mesu.effectiveTimestep*1000) * double(mesu.numSamplesPerAggregate)) * (startIndex:(totalValues - 1));

            plot(axes1, time, bufferChAmV, time, bufferChBmV);

        end
        
        previousTotal = totalValues - totalSamples; % Calculate previous total.
        totalSamples = totalValues;
        
    end

    % Check if auto stop has occurred.
    if(hasAutoStopped)

        disp('AutoStop: TRUE - exiting loop.');
        break;

    end
    
    % Check if the application buffer is full.
    if(isAppBufferFull)
       
        disp('Application buffer(s) full - exiting loop.');
        break;
        
    end
    
    % Check if 'STOP' button has been pressed.
    flag = getappdata(gcf, 'run');
    drawnow;

    if(flag == 0)

        disp('STOP button clicked - aborting data collection.');
        break;
        
    end

end

disp('Data collection complete.');

% Close the STOP button window
if(exist('stopFig', 'var'))
    
    close('Stop Button');
    clear stopFig;
        
end

if(plotLiveData == PicoConstants.TRUE)
    
    drawnow;
    
    % Take hold off the current figure
    hold(axes1,'off');
    
end

if(hasTriggered == PicoConstants.TRUE)
   
    fprintf('Triggered at overall index: %d\n\n', triggeredAtIndex);
    
end

% Clear parameters held in the wrapper library if another data capture run
% is to take place.
invoke(streamingGroupObj, 'clearFastStreamingParameters');

%% Stop the Device.
% This function should be called regardless of whether the autoStop
% property is enabled or not.

[status.stop] = invoke(ps2000DeviceObj, 'ps2000Stop');

%% Process Data
% Process data if required - here the data will be plotted again.

disp('Processing data for plot...')

maxADCValue = get(ps2000DeviceObj, 'maxADCValue');

% Change length of buffers if number of samples is less than application
% buffer.

if(totalValues < appBufferSize)
   
    pAppBufferChA.Value(totalValues + 1:end) = [];
    pAppBufferChB.Value(totalValues + 1:end) = [];
    
end

% Retrieve data and convert to milliVolts
bufferChA = adc2mv(pAppBufferChA.Value, chARangeMv, maxADCValue);
bufferChB = adc2mv(pAppBufferChB.Value, chBRangeMv, maxADCValue);

time = (0:1:(length(bufferChA)) - 1) * double(mesu.effectiveTimestep) * double(mesu.numSamplesPerAggregate) ;

%% Disconnect
% Disconnect device object from hardware.

disconnect(ps2000DeviceObj);
delete(ps2000DeviceObj);

mesu.date = date ;
mesu.time = clockString ;
%mesu.picoName = unitInfo ;
