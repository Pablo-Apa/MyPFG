
close all
clear all

rep = 7;

filename = "data/data_s11_antenna"+rep+".mat";
load(filename)

%% Variables

sample_rate = 25e9;
[timeSignal, complex_unfolded, fs, dt] =  f2t_fill(mag_s11,phase_s11,freq,sample_rate);
%% WVD

figure
wvd(real(timeSignal), sample_rate*2,'smoothedPseudo')

xlim([0 6])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("WVD - Sample rate " + sample_rate./1e9 + " GHz")
%% WVD smooth
figure
wvd(real(timeSignal),sample_rate*2, 'smoothedPseudo', kaiser(51,1));
%         h = surf(t(1:end),f(1:end), d2(1:end, 1:end))
%         view(2)
%         set(h,'LineStyle','none')

xlim([0 6])
ylim([0 13])
title("WVD Smooth - Sample rate " + sample_rate./1e9 + " GHz - kaiser (51,1)")
fig.Position = [300 300 1440 300];
%% WVD smooth
figure
wvd(real(timeSignal),sample_rate*2, 'smoothedPseudo', kaiser(1001,1));
%         h = surf(t(1:end),f(1:end), d2(1:end, 1:end))
%         view(2)
%         set(h,'LineStyle','none')

xlim([0 6])
ylim([0 13])
title("WVD Smooth - Sample rate " + sample_rate./1e9 + " GHz - kaiser (1001,1)")
fig.Position = [300 300 1440 300];