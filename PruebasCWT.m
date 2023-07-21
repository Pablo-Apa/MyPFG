close all
clear all

rep = 7;

filename = "data/data_s11_antenna"+rep+".mat";
load(filename)

%% Variables

sample_rate = 25e9;
[timeSignal, complex_unfolded, fs, dt] =  f2t_fill(mag_s11,phase_s11,freq,sample_rate);

%% CWT morse

[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse');
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz - Default morse" )

%% CWT amor
[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'amor');
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz (amor)")
%% CWT bump
[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'bump');
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz (bump)")

%% CWT morse

[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48);
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz - Defalut morse - VPO 48")

%% CWT morse

[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [3,120]);
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz - Morse [3 , 120] - VPO 48")
%% 

for i = [1,3,5]
    for j = [i*10,i*20,i*30,i*40]
        [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [i,j]);
        sigLen = numel(timeSignal(1:end/2));
        t = (0:sigLen-1)/fs;

        figure
        h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
        view(2)
        set(h,'LineStyle','none')
        xlim([0 6])
        ylim([0 13])
        ylabel('Frequency (GHz)')
        xlabel('Time (ns)')
        title("CWT - Sample rate " + sample_rate./1e9 + " GHz (morse) " + i + " " + j)
    end
end

%%
%% CWT morse

[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [10,400]);
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz - Morse [10 , 400] - VPO 48")

%%
%% CWT morse

[cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 5, WaveletParameters = [3,5]);
sigLen = numel(timeSignal(1:end/2));
t = (0:sigLen-1)/fs;

figure
h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
view(2)
set(h,'LineStyle','none')
xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("CWT - Sample rate " + sample_rate./1e9 + " GHz - Morse [3 , 5] - VPO 5")