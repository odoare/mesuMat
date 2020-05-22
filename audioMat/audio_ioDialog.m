function mesu = audio_ioDialog(mesu)
%
% mesu = audio_ioDialog(mesu)
%
% Instantiates a Gui dialog that allows to adjust the parameters of a
% specific data acquisition.
%
% The parameter "mesu" is optionnal. If it is given, the fields of the the
% gui dialog are initiated to its values. If not, default values are taken.
%
% All the parameters are stored in the output structure "mesu".
%
% v0.01 - May, 19th 2020 - O. Doar� - olivier.doare@ensta-paris.fr

    default = audio_defaultMeasure() ;
    maxChan = 8 ;
    
    if ~exist('mesu')
       mesu = struct() ;
    end

    if isfield(mesu,'inMap')==0
        mesu.inMap = default.inMap ;
    end
    
    if isfield(mesu,'saveFile')==0
        mesu.saveFile = default.saveFile ;
    end

    if isfield(mesu,'Fs')==0
        mesu.Fs = default.Fs ;
    end

    if isfield(mesu,'duration')==0
        mesu.duration = default.duration ;
    end

% Upsampling not implemented yet    
%     if isfield(mesu,'upSample')==0
%         mesu.upSample = default.upSample ;       
%     end
    
    if isfield(mesu,'inDesc')==0
        mesu.inDesc = default.inDesc ;
    end

    if isfield(mesu,'inCal')==0
        mesu.inCal = default.inCal ;       
    end

    if isfield(mesu,'inUnit')==0
        mesu.inUnit = default.inUnit ;       
    end
    
    if isfield(mesu,'in0dBFS')==0
        mesu.in0dBFS = default.in0dBFS ;       
    end

    if isfield(mesu,'sg')==0
        mesu.sg = default.sg ;
    end

    if isfield(mesu,'sgType')==0
        mesu.sgType = default.sgType ;
    end
    
    if isfield(mesu,'sgAmplitude')==0
        mesu.sgAmplitude = default.sgAmplitude ;
    end

    if isfield(mesu,'sgStartFrequency')==0
        mesu.sgStartFrequency = default.sgStartFrequency ;
    end

    if isfield(mesu,'sgEndFrequency')==0
        mesu.sgEndFrequency = default.sgEndFrequency ;
    end

    if isfield(mesu,'sgRepetitions')==0
        mesu.sgRepetitions = default.sgRepetitions ;
    end
    
    if isfield(mesu,'displayLiveData')==0
        mesu.displayLiveData = default.displayLiveData ;
    end

    if isfield(mesu,'audioDev')==0
        mesu.audioDev = default.audioDev ;
    end
    
    if isfield(mesu,'outMap')==0
        mesu.outMap = default.outMap ;
    end
           
    if isfield(mesu,'peakSync')==0
        mesu.peakSync = default.peakSync ;
    end
 
    apr = audioPlayerRecorder(mesu.Fs,...
        'BitDepth','24-bit integer');
    deviceChoices = apr.getAudioDevices ;
    mesu.audioDevName = deviceChoices{mesu.audioDev} ;
    apr.Device = mesu.audioDevName ;
    [inChannelsStrings,outChannelsStrings] = getChannelsStrings(apr) ;
    release(apr) ;
    
    plotDataChoices = {'ask', 'no', 'yes'} ;
     
    sigGenChoices = {'LogSweep', 'Noise', 'File'} ;  
   
    d = dialog('Position',[300 300 600 500],'Name','National Instrument dialog');
    
    % Device
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 430 80 40],...
       'String','Device');
    device = uicontrol('Parent',d,...
        'Style','popup',...
        'Position',[110 450 100 20],...
        'String',deviceChoices,...
        'TooltipString','Select here an audio device',...
        'Callback',@device_callback,...
        'Value',mesu.audioDev);
    
    % Plot data ? (not working yet)
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[300 430 80 40],...
       'String','Plot data ?');
    plotData = uicontrol('Parent',d,...
       'Style','popup',...
       'Position',[390 450 100 20],...
       'String',plotDataChoices,...
        'TooltipString','Ask : a dialog appear just before running the task',...
       'Value',mesu.displayLiveData+2,...
       'Callback',@plotData_callback);

    % File name
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 410 360 20],...
       'String','File name');
    fileName = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[20 390 360 20],...
       'String',mesu.saveFile,...
       'TooltipString','The MAT file where data is saved (structure mesu)',...
       'Callback',@fileName_callback);

   % Frequency
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 350 100 20],...
       'String','Frequency (Hz)');
    Fs = uicontrol('Parent',d,...
        'Style','edit',...
        'Position',[20 330 100 20],...
        'String',num2str(mesu.Fs),...
        'TooltipString','Sampling frequency',...
        'Callback',@Fs_callback);

    % Duration
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[150 350 100 20],...
       'String','Duration (s)');
    duration = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[150 330 100 20],...
       'String',num2str(mesu.duration),...
       'TooltipString','Duration of the measurement',...
       'Callback',@duration_callback);

% Upsampling not implemented yet
% 	% Upsampling
%     txt = uicontrol('Parent',d,...
%        'Style','text',...
%        'Position',[280 350 100 20],...
%        'String','Upsampling');
%     upSampling = uicontrol('Parent',d,...
%        'Style','edit',...
%        'Position',[280 330 100 20],...
%        'String',num2str(mesu.upSample),...
%        'Callback',@upSampling_callback);

	% Input Channels
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 280 40 20],...
       'String','Inputs');
    inChannels = uicontrol('Parent',d,...
       'Style','listbox',...
       'Position',[20 160 40 120],...
       'String',inChannelsStrings,...
       'Max',4,...
       'Min',1,...
       'Value',mesu.inMap,...
       'TooltipString',['Select the desired inputs',...
            newline,'(hold ctrl or shift to select more)'],...
       'Callback',@inChannels_callback);
   
   
    % 0dBFS
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[65 280 60 20],...
        'String','0dBFS');
    for i1=1:maxChan
        if i1>length(mesu.in0dBFS)
            val = '1' ;
        else
            val = num2str(mesu.in0dBFS(i1)) ;
        end
        zdBFS{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[65 265-(i1-1)*15 60 15],...
           'String',val,...
           'TooltipString','The value in volts for which the acquired signal equals 1.',...
           'Callback',@inChannels_callback); 
    end
   
    % Calibrations
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[130 280 60 20],...
        'String','Calibrations');
    for i1=1:maxChan
        if i1>length(mesu.inCal)
            val = '1' ;
        else
            val = num2str(mesu.inCal(i1)) ;
        end
        cal{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[130 265-(i1-1)*15 60 15],...
           'String',val,...
           'TooltipString','Calibration of the incoming signal (in Volts/Unit)',...
           'Callback',@inChannels_callback); 
    end

    % Units
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[195 280 60 20],...
        'String','Units');
    for i1=1:maxChan
        if i1>length(mesu.inUnit)
            val = 'V' ;
        else
            val = mesu.inUnit{i1} ;
        end
        unit{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[195 265-(i1-1)*15 60 15],...
           'TooltipString','Unit of the calibration (Pa, m/s^2, etc.)',...
           'String',val,...
           'Callback',@inChannels_callback); 
    end


    % Info
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[260 280 120 20],...
        'String','Info');
    for i1=1:maxChan
        if i1>length(mesu.inDesc)
            val = 'Input description' ;
        else
            val = mesu.inDesc{i1} ;
        end
        info{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[260 265-(i1-1)*15 120 15],...
           'String',val,...
           'TooltipString','Enter here the description of the channel',...
           'Callback',@inChannels_callback);
    end

   
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[50 10 210 40],...
       'String','Adjust parameters then click Go');


    btnGo = uicontrol('Parent',d,...
       'Position',[300 30 70 25],...
       'String','Go',...
       'Callback','delete(gcf)');

    %%%
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[430 400 100 20],...
        'String','Sig. gen.');
    onOff = uicontrol('Parent',d,...
       'Style','checkBox',...
       'Position',[520 402 100 20],...
       'Value',mesu.sg,...
       'Callback',@onOff_callback);

    % Output channel
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 375 100 20],...
        'String','Channel');
    outChannel = uicontrol('Parent',d,...
       'Style','listbox',...
       'Position',[450 330 100 50],...
       'String',outChannelsStrings,...
       'Max',1,...
       'Min',0,...
       'Value',mesu.outMap,...
       'TooltipString','Select here an output channel',...
       'Callback',@outChannel_callback);
   
    sigGenType = uicontrol('Parent',d,...
        'Style','popup',...
        'Position',[450 300 100 20],...
        'String',sigGenChoices,...
        'Value',find(strcmp(sigGenChoices, mesu.sgType)),...
        'Callback',@sigGenType_callback);
   
   % Sig gen. amplitude
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 265 100 20],...
        'String','Amplitude');
    amplitude = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 250 100 20],...
       'String',num2str(mesu.sgAmplitude),...
       'Callback',@amplitude_callback);

   % Sig. gen start frequency
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 225 100 20],...
        'String','Min freq.');
    startFrequency = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 210 100 20],...
       'String',num2str(mesu.sgStartFrequency),...
       'Callback',@startFrequency_callback);

   % Sig. gen stop frequency
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 185 100 20],...
        'String','Max freq.');
    endFrequency = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 170 100 20],...
       'String',num2str(mesu.sgEndFrequency),...
       'Callback',@endFrequency_callback);

   % Sig. gen repetitions
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 145 100 20],...
        'String','Repetitions');
    repetitions = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 130 100 20],...
       'String',num2str(mesu.sgRepetitions),...
       'Callback',@repetitions_callback);

       %%%
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[430 80 100 20],...
        'String','Peak sync');
    peakSync = uicontrol('Parent',d,...
       'Style','checkBox',...
       'Position',[520 80 100 20],...
       'Value',mesu.peakSync,...
       'Callback',@peakSync_callback);

% Upsampling not implemented yet  
%    mesu.effectiveFrequency = mesu.Fs * mesu.upSample ;
    
    %%%
    
%     if mesu.sg
        mesu.outMap = outChannel.Value ;
%     else
%         mesu.outMap = [] ;
%     end

%     disp(outChannel.String) 
%     disp(outChannel.Value)
    
    % Wait for d to close before running to completion
    uiwait(d);

    
    % Callback functions
    
    function device_callback(popup,event)
        mesu.audioDev = popup.Value ;
        mesu.audioDevName = deviceChoices{mesu.audioDev} ;
        apr = audioPlayerRecorder(mesu.Fs,...
            'Device',mesu.audioDevName,...
            'BitDepth','24-bit integer');
        deviceChoices = apr.getAudioDevices ;
        [inChannelsStrings,outChannelsStrings] = getChannelsStrings(apr) ;
        release(apr) ;

        set(inChannels,'String',inChannelsStrings)
        if max(mesu.inMap)>length(inChannelsStrings)
          mesu.inMap = [] ;
        end
        set(inChannels,'Value',mesu.inMap) ;
        set(outChannel,'String',outChannelsStrings)
        if max(mesu.outMap)>length(outChannelsStrings)
          mesu.outMap = [] ;
        end
        set(outChannel,'Value',mesu.outMap) ;
        affichemesu ;
    end

    function plotData_callback(popup,event)
      mesu.displayLiveData = popup.Value-2 ;
      affichemesu ;
    end

    function fileName_callback(edit,event)
        mesu.saveFile = edit.String ;
        affichemesu ;
    end

    function Fs_callback(edit,event)
        mesu.Fs = str2num(edit.String) ;
        mesu.effectiveFrequency = mesu.Fs * mesu.upSample ;
        affichemesu ;
    end

    function duration_callback(edit,event)
        mesu.duration = str2num(edit.String) ;
        affichemesu ;
    end

% Upsampling not implemented yet
%     function upSampling_callback(edit,event)
%         mesu.upSample = str2num(edit.String) ;
%         mesu.effectiveFrequency = mesu.Fs * mesu.upSample ;
%         affichemesu ;
%     end

    function inChannels_callback(popup,event)
        mesu.inMap = inChannels.Value ;
        mesu.in0dBFS = [] ;
        mesu.inDesc = {} ;
        mesu.inCal = [] ;
        mesu.inUnit = {} ;
        for i1 = 1:length(inChannels.Value)
            mesu.inDesc{i1} = info{i1}.String ;
            mesu.in0dBFS(i1) = str2num(zdBFS{i1}.String) ;
            mesu.inCal(i1) = str2num(cal{i1}.String) ;
            mesu.inUnit{i1} = unit{i1}.String ;
        end
        affichemesu ;
    end

    function outChannel_callback(popup,event)
%         if mesu.sg
            mesu.outMap = outChannel.Value ;
%         else
%             mesu.outMap = [] ;
%         end
        affichemesu ;
    end

    function onOff_callback(edit,event)
       mesu.sg = edit.Value ;
%        if ~mesu.sg
%            mesu.outMap = [] ;
%        else
           mesu.outMap = outChannel.Value ;
%        end
       affichemesu ;
    end

    function amplitude_callback(edit,event)
       mesu.sgAmplitude = str2num(edit.String) ;
       affichemesu ;
    end

    function startFrequency_callback(edit,event)
        mesu.sgStartFrequency = str2num(edit.String) ;
        affichemesu ;
    end

    function endFrequency_callback(edit,event)
        mesu.sgEndFrequency = str2num(edit.String) ;
        affichemesu ;
    end

    function repetitions_callback(edit,event)
        mesu.sgRepetitions = str2num(edit.String) ;
        affichemesu ;
    end

    function sigGenType_callback(edit,event)
        mesu.sgType = edit.String{edit.Value} ;
        if strcmp(mesu.sgType,'File')
            [filename, pathname] = uigetfile({'*.wav'}) ;
            mesu.sgFile = fullfile(pathname,filename) ;
        end
        affichemesu ;
    end

    function peakSync_callback(edit,event)
       mesu.peakSync = edit.Value ;
    end
    
    function [inStrings,outStrings] = getChannelsStrings(apr)
        for iii=1:apr.info.MaximumRecorderChannels
            inStrings{iii} = num2str(iii) ;
        end
        for iii=1:apr.info.MaximumPlayerChannels
            outStrings{iii} = num2str(iii) ;
        end
    end

    function affichemesu
        disp(mesu) ; % Comment this line if you don't want debug info
    end
end