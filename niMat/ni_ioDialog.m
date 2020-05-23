function mesu = ni_ioDialog(mesu)
%
% mesu = ni_ioDialog(mesu)
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

    default = ni_defaultMeasure() ;
    
    maxChan = 8 ;
 
    inChannelsStrings = {} ;
    outChannelsStrings = {} ; 
    a = daq.getDevices ;
    
    for i1 = 1:length(a)
        deviceChoices{i1} = a(i1).ID ;
        inChannelsStrings{i1} = a(i1).Subsystems(1).ChannelNames ;
        outChannelsStrings{i1} = a(i1).Subsystems(2).ChannelNames ;
    end

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
        'Callback',@device_callback);
    
    % Plot data ? (not working yet)
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[300 430 80 40],...
       'String','Plot data ? (not working yet)');
    plotData = uicontrol('Parent',d,...
       'Style','popup',...
       'Position',[390 450 100 20],...
       'String',plotDataChoices,...
       'Callback',@plotData_callback);

    % File name
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 410 360 20],...
       'String','File name');
    fileName = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[20 390 360 20],...
       'String','test.mat',...
       'Callback',@fileName_callback);

   % Frequency
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 350 100 20],...
       'String','Frequency (Hz)');
    Fs = uicontrol('Parent',d,...
        'Style','edit',...
        'Position',[20 330 100 20],...
        'String','44100',...
        'Callback',@Fs_callback);

    % Duration
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[150 350 100 20],...
       'String','Duration (s)');
    duration = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[150 330 100 20],...
       'String','2',...
       'Callback',@duration_callback);

    % Up sampling not implemented yet for NI cards
    % Upsampling
    % txt = uicontrol('Parent',d,...
    %   'Style','text',...
    %   'Position',[280 350 100 20],...
    %   'String','Upsampling');
    %upSampling = uicontrol('Parent',d,...
    %   'Style','edit',...
    %   'Position',[280 330 100 20],...
    %   'String','16',...
    %   'Callback',@upSampling_callback);

	% Input Channels
    txt = uicontrol('Parent',d,...
       'Style','text',...
       'Position',[20 280 100 20],...
       'String','In channels');
    inChannels = uicontrol('Parent',d,...
       'Style','listbox',...
       'Position',[20 160 100 120],...
       'String',inChannelsStrings{1},...
       'Max',4,...
       'Min',1,...
       'Callback',@inChannels_callback);
   
    % Calibrations
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[130 280 60 20],...
        'String','Calibrations');
    for i1=1:maxChan
        cal{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[130 265-(i1-1)*15 60 15],...
           'String','1',...
           'Callback',@inChannels_callback); 
    end

    % Units
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[195 280 60 20],...
        'String','Units');
    for i1=1:maxChan
        unit{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[195 265-(i1-1)*15 60 15],...
           'String','V',...
           'Callback',@inChannels_callback); 
    end


    % Info
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[260 280 120 20],...
        'String','Info');
    for i1=1:maxChan
        info{i1} = uicontrol('Parent',d,...
           'Style','edit',...
           'Position',[260 265-(i1-1)*15 120 15],...
           'String','Channel info',...
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
       'Value',0,...
       'Callback',@onOff_callback);

    % Output channel
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 375 100 20],...
        'String','Channel');
    outChannel = uicontrol('Parent',d,...
       'Style','listbox',...
       'Position',[450 330 100 50],...
       'String',outChannelsStrings{1},...
       'Max',1,...
       'Min',1,...
       'Callback',@outChannel_callback);
   
    % Sig Gen type
%     txt = uicontrol('Parent',d,...
%        'Style','text',...
%        'Position',[20 430 80 40],...
%        'String','Device');
    sigGenType = uicontrol('Parent',d,...
        'Style','popup',...
        'Position',[450 300 100 20],...
        'String',sigGenChoices,...
        'Callback',@sigGenType_callback);
   
   % Sig gen. amplitude
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 265 100 20],...
        'String','Amplitude');
    amplitude = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 250 100 20],...
       'String','3',...
       'Callback',@amplitude_callback);

   % Sig. gen start frequency
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 225 100 20],...
        'String','Min freq.');
    startFrequency = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 210 100 20],...
       'String','20',...
       'Callback',@startFrequency_callback);

   % Sig. gen stop frequency
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 185 100 20],...
        'String','Max freq.');
    endFrequency = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 170 100 20],...
       'String','20000',...
       'Callback',@endFrequency_callback);

   % Sig. gen repetitions
    txt = uicontrol('Parent',d,...
        'Style','text',...
        'Position',[450 145 100 20],...
        'String','Repetitions');
    repetitions = uicontrol('Parent',d,...
       'Style','edit',...
       'Position',[450 130 100 20],...
       'String','3',...
       'Callback',@repetitions_callback);


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

    % Up sampling not implemented yet for NI cards
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

    if isfield(mesu,'daqID')==0
        mesu.daqID = default.daqID ;
    end
    
    if isfield(mesu,'outMap')==0
        mesu.outMap = default.outMap ;
    end

    set(fileName,'String',mesu.saveFile) ;
    set(Fs,'String',num2str(mesu.Fs)) ;
    set(duration,'String',num2str(mesu.duration)) ;
    % Up sampling not implemented yet for NI cards
    % set(upSampling,'String',num2str(mesu.upSample)) ;
    set(plotData,'Value',mesu.displayLiveData+2) ;
    index = find(strcmp(deviceChoices, mesu.daqID)) ;
    mesu.daqName = a(index).Description ;
    set(device,'Value',index) ;
    set(inChannels,'String',inChannelsStrings{index})
    if max(mesu.inMap)>length(inChannelsStrings{index})
        mesu.inMap = [] ;
    end
    set(inChannels,'Value',mesu.inMap) ;
    mesu.inName = {} ;
    mesu.outName = {} ;
    set(outChannel,'String',outChannelsStrings{index})
    if max(mesu.outMap)>length(outChannelsStrings{index})
      mesu.outMap = [] ;
    end
    set(outChannel,'Value',mesu.outMap) ;
    mesu.outName = outChannelsStrings{device.Value}{outChannel.Value}
    for i1=1:maxChan
        if i1<length(inChannels)+2
            set(info{i1},'String',mesu.inDesc{i1}) ;
            set(unit{i1},'String',mesu.inUnit{i1}) ;
            set(cal{i1},'String',num2str(mesu.inCal(i1))) ;    
            mesu.inName{i1} = inChannelsStrings{device.Value}{inChannels.Value(i1)} ;
        else
            set(info{i1},'String','') ;
            set(unit{i1},'String','V') ;
            set(cal{i1},'String','1') ;
        end
    end

    %%%
    set(onOff,'Value',mesu.sg) ;   
    set(amplitude,'String',num2str(mesu.sgAmplitude)) ;
    set(startFrequency,'String',num2str(mesu.sgStartFrequency)) ;
    set(endFrequency,'String',num2str(mesu.sgEndFrequency)) ;
%     set(repetitions,'String',num2str(mesu.sgRepetitions)) ;
    
    index = find(strcmp(sigGenChoices, mesu.sgType)) ;
    set(sigGenType,'Value',index) ;
    
    % % Up sampling not implemented yet for NI cards
    % mesu.effectiveFrequency = mesu.Fs * mesu.upSample ;
    
    %%%

    % Wait for d to close before running to completion
    uiwait(d);

    
    % Callback functions
    
    function device_callback(popup,event)
      mesu.daqID = popup.String{popup.Value} ;
      mesu.daqName = a(find(strcmp(deviceChoices, mesu.daqID))).Description ;
      set(inChannels,'String',inChannelsStrings{popup.Value})
      if max(mesu.inMap)>length(inChannelsStrings{popup.Value})
          mesu.inMap = [] ;
      end
      set(inChannels,'Value',mesu.inMap) ;
      set(outChannel,'String',outChannelsStrings{popup.Value})
      if max(mesu.outMap)>length(outChannelsStrings{popup.Value})
          mesu.outMap = [] ;
      end
      set(outChannel,'Value',mesu.outMap) ;
%       for i1=1:5
%         if i1<length(inChannels)+1
%             set(info{i1},'String',mesu.inDesc{i1}) ;
%             set(unit{i1},'String',mesu.inUnit{i1}) ;
%             set(cal{i1},'String',num2str(mesu.inCal{i1})) ;    
%         else
%             set(info{i1},'String','') ;
%             set(unit{i1},'String','V') ;
%             set(cal{i1},'String','1') ;
%         end
%      end
    end

    function plotData_callback(popup,event)
      mesu.displayLiveData = popup.Value-2
    end

    function fileName_callback(edit,event)
        mesu.saveFile = edit.String
    end

    function Fs_callback(edit,event)
        mesu.Fs = str2num(edit.String)
        mesu.effectiveFrequency = mesu.Fs * mesu.upSample ;
    end

    function duration_callback(edit,event)
        mesu.duration = str2num(edit.String)
    end

    % Up sampling not implemented yet for NI cards
%     function upSampling_callback(edit,event)
%         mesu.upSample = str2num(edit.String)
%     end

    function inChannels_callback(popup,event)
        mesu.inMap = inChannels.Value ;
        mesu.inName = {} ;
        mesu.inDesc = {} ;
        mesu.inCal = [] ;
        mesu.inUnit = {} ;
        for i1 = 1:length(inChannels.Value)
            mesu.inName{i1} = inChannelsStrings{device.Value}{inChannels.Value(i1)} ;
            mesu.inDesc{i1} = info{i1}.String ;
            mesu.inCal(i1) = str2num(cal{i1}.String) ;
            mesu.inUnit{i1} = unit{i1}.String ;
        end
        disp(mesu) ;
    end

    function outChannel_callback(popup,event)
        mesu.outMap = outChannel.Value ;
        mesu.outName = outChannelsStrings{device.Value}{outChannel.Value}
    end

    function onOff_callback(edit,event)
       mesu.sg = edit.Value
    end

    function amplitude_callback(edit,event)
       mesu.sgAmplitude = str2num(edit.String)
    end

    function startFrequency_callback(edit,event)
        mesu.sgStartFrequency = str2num(edit.String)
    end

    function endFrequency_callback(edit,event)
        mesu.sgEndFrequency = str2num(edit.String)
    end

    function repetitions_callback(edit,event)
        mesu.sgRepetitions = str2num(edit.String)
    end

    function sigGenType_callback(edit,event)
        mesu.sgType = edit.String{edit.Value}
        if strcmp(mesu.sgType,'File')
            [filename, pathname] = uigetfile({'*.wav'}) ;
            mesu.sgFile = fullfile(pathname,filename) ;
        end
    end
end
