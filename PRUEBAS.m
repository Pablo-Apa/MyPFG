
close all
clc
n = ceil(rand(10)*100);
sample_rate = 8e9
tagname = "tag_01000_2x2_050_080_1"
for i = 1:10
    aux = n(i)
    dataMag = dataMags(:,aux)
    dataPh1 = dataPh(:,aux)
    [timeSignal, complex_unfolded, fs, dt, t] =  f2t_fill(dataMag,dataPh1,freq',sample_rate);
    %

    color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph


    figure
    subplot(1,3,1)
    hold on;
    plot(dataMag, freq./1e9,'color',color, LineWidth=3)
    ax = gca
    ylabel('Frequency(GHz)')
    xlabel('Magnitude (dB)')

    ylim([1 5.5])
    ax.XDir = 'reverse'


    [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [10 , 400]);
    sigLen = numel(timeSignal(1:end/2));
    t = (0:sigLen-1)/fs;
    subplot(1,3,[2,3])
    h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
    view(2)
    set(h,'LineStyle','none')
    xlim([0 10])
    ylim([1 5.5])
    ylabel('Frequency (GHz)')
    xlabel('Time (ns)')
    title("CWT- " + replace(tagname,"_"," ") + " " + aux + " - Sample rate " + sample_rate./1e9 + " GHz - Morse [10 , 400] - VPO 48")
end