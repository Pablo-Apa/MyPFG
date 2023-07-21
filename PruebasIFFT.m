close all
clear all

rep = 7;

filename = "data/data_s11_antenna"+rep+".mat";
load(filename)

%% Variables

sample_rate = 15e9;
[timeSignal, complex_unfolded, fs, dt] =  f2t_fill(mag_s11,phase_s11,freq,sample_rate);

%% Pruebas
% STFT
[s, fstft, tstft] = stft(real(timeSignal(1:end/2)),fs,FFTLength=length(complex_unfolded),OverlapLength=63,FrequencyRange="onesided", Window=kaiser(64,1) ); %,Window=kaiser(128,5));%,OverlapLength=22,FFTLength=1024);
sdb = mag2db(abs(s(1:10:end, 1:10:end)));

fig = figure(sample_rate/1e9)

h = surf(tstft(1:10:size(sdb(1:end, 1:end), 2)*10).*1e9, fstft(1:10:size(sdb(1:end, 1:end), 1)*10)./1e9,sdb(1:end, 1:end))
cc = max(sdb(:)) + [-60 0];
ax = gca;
ax.CLim = cc;
set(h,'LineStyle','none')
view(2)
xlim([0 10])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("STFT - Sample rate " + sample_rate./1e9 + " GHz")

%%
n_points = 200
timeSignal1 =[zeros(n_points,1) ;timeSignal]



[s, fstft, tstft] = stft(real(timeSignal1(1:end/2)),fs,FFTLength=length(complex_unfolded),OverlapLength=255,FrequencyRange="onesided", Window=kaiser(256,1) ); %,Window=kaiser(128,5));%,OverlapLength=22,FFTLength=1024);
sdb = mag2db(abs(s));
tstft = tstft - ones(length(tstft),1)*(n_points/2)*dt;

fig1 = figure(sample_rate/1e9)

h = surf(tstft.*1e9, fstft./1e9,sdb)
cc = max(sdb(:)) + [-60 0];
ax = gca;
ax.CLim = cc;
set(h,'LineStyle','none')
view(2)
xlim([0 12])
ylim([0 13])
ylabel('Frequency (GHz)')
xlabel('Time (ns)')
title("STFT - Sample rate " + sample_rate./1e9 + " GHz")