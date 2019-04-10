clear

txPluto = sdrtx('Pluto','RadioID','usb:0',...
       'CenterFrequency',92.4e6,...
                  'Gain',-0,...
        'ChannelMapping',1,...
    'BasebandSampleRate',614400);
txPluto.ShowAdvancedProperties = true;

afr=dsp.AudioFileReader('Scarborough Fair.flac','SamplesPerFrame',4410);
adw = audioDeviceWriter('SampleRate', afr.SampleRate);
mod=comm.FMBroadcastModulator('AudioSampleRate',afr.SampleRate, ...
     'SampleRate',txPluto.BasebandSampleRate,'Stereo',true);
%data=audioread('Scarborough Fair.flac');
while ~isDone(afr)
    data = afr();
    %adw(data);
    underflow=txPluto(mod(data));
end
% audio = dsp.AudioFileReader('Scarborough Fair.flac','SamplesPerFrame',44100);
% fmbMod = comm.FMBroadcastModulator('AudioSampleRate',audio.SampleRate, ...
%     'SampleRate',240e3);
% groupLen = 104;
% sps = 10;
% groupsPerFrame = 19;
% rbdsFrameLen = groupLen*sps*groupsPerFrame;
% afrRate = 40*1187.5;
% rbdsRate = 1187.5*sps;
% outRate = 4*57000;
% 
% afr = dsp.AudioFileReader('rbds_capture_47500.wav','SamplesPerFrame',rbdsFrameLen*afrRate/rbdsRate);
% rbds = comm.RBDSWaveformGenerator('GroupsPerFrame',groupsPerFrame,'SamplesPerSymbol',sps);
% 
% fmMod = comm.FMBroadcastModulator('AudioSampleRate',afr.SampleRate,'SampleRate',outRate,...
%     'Stereo',true,'RBDS',true,'RBDSSamplesPerSymbol',sps);

% [y,fs]=audioread('Scarborough Fair.flac');
% y=resample(y,fmfs,fs);

% function aa= recorder(cf,handles)
% %RECORDER Summary of this function goes here
% % Detailed explanation goes here
% % h=figure(soundrec);
% 
% h=cf;
% thehandles=handles;
% setappdata(h,'isrecording',1);
% 
% Ai=analoginput('winsound'); % ����һ��ģ���ź��������
% % ���ͨ��
% addchannel(Ai,1);
% Ai.SampleRate=48000; % ����Ƶ��
% Ai.SamplesPerTrigger=Inf; % ������
% 
% start(Ai); % ��������
% warning off % ���������ݲ���ʱ��ȡ������
% while isrunning(Ai) % �������Ƿ���������
%     if getappdata(h,'isrecording')
%         data=peekdata(Ai,Ai.SampleRate);% ��ȡ�����е����Ai.SampleRate����������
%         plot(thehandles.axes1,data) % �������Ai.SampleRate���������ݵ�ͼ�Σ���˱��ֳ�������ʵʱ����
%         set(handles.axes1,'ylim',[-1 1],'xlim',[0 Ai.SampleRate]);
%         y1=fft(data,2048); %���ź���2048��FFT�任
%         f=Ai.SampleRate*(0:1023)/2048;
%         bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g') %��ԭʼ�����źŵ�FFTƵ��ͼ
%         set(handles.axes2,'ylim',[0 10],'xlim',[0 20000]);%����handles.axes2�ĺ������귶Χ
%         drawnow; % ˢ��ͼ��
%     else
%         stop(Ai);
%         num=get(Ai,'SamplesAvailable');
%         aa=getdata(Ai,num);
%         axes(thehandles.axes1);
%         plot(thehandles.axes1,aa) % �������в������ݵ�ͼ��
% 
%         y1=fft(data,2048); %���ź���2048��FFT�任
%         f=Ai.SampleRate*(0:1023)/2048;
%         bar(handles.axes2,f,abs(y1(1:1024)),0.8,'g') %��ԭʼ�����źŵ�FFTƵ��ͼ
%         %set(handles.axes2,'ylim',[0 10],'xlim',[0 20000]);%����handles.axes2�ĺ������귶Χ
%         drawnow; % ˢ��ͼ��
%         setappdata(h,'sounds',aa);
%     end
% end