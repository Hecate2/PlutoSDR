clear

%% �����ʼ��
txPluto = sdrtx('Pluto','RadioID','usb:0',...
    'CenterFrequency',92.4e6,...
    'Gain',-0,...
    'ChannelMapping',1,...
    'BasebandSampleRate',228000);
txPluto.ShowAdvancedProperties = true;

afr=dsp.AudioFileReader('Scarborough Fair.flac','SamplesPerFrame',44100/2);
adw = audioDeviceWriter('SampleRate', afr.SampleRate);
mod=comm.FMBroadcastModulator('AudioSampleRate',afr.SampleRate, ...
    'SampleRate',txPluto.BasebandSampleRate,'Stereo',false);
%data=audioread('Scarborough Fair.flac');

%% ���ճ�ʼ��
sigSrc=comm.SDRRxPluto(...
    'CenterFrequency',89.9e6,...%The channel you want to listen to (Hz)
    'GainSource','Manual',...
    'Gain',50,...%can control volume
    'ChannelMapping',1,...
    'BasebandSampleRate',228000,...%228000
    'OutputDataType','single',...
    'SamplesPerFrame',45600*5/2);%5.2:�������������;5�ƺ���;4.2:�����м��;4.8:���չ�һ��ʱ����һ��

% Create FM broadcast receiver object and configure based on user input
fmBroadcastDemod = comm.FMBroadcastDemodulator(...
    'SampleRate', 228000, ...
    'FrequencyDeviation', 75e3, ...
    'FilterTimeConstant', 7.5e-5, ...
    'AudioSampleRate', 45600, ...
    'Stereo', true);

% Create audio player
player = audioDeviceWriter('SampleRate',45600);

while ~isDone(afr)
    data = afr();
    %adw(data);
    data=(data(:,1)+data(:,2))/2;
    data=mod(data);
    underflow=txPluto(data);

    rcv = sigSrc();
    audioSig = fmBroadcastDemod(rcv);
    player(audioSig);
end
