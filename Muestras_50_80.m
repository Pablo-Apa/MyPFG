clear all
close all
clc

listaTag = dir("tag_4800_50_140_") 
sample_rate = 8e9;

cont = 1

for i = 3:20
   idtag = 3;
   tagname = replace(listaTag(idtag).name,'.mat','')
    if sample_rate == 0
        sample_rate = freq(end);
    end
   filename = "tag_4800_50_140_/" + tagname + ".mat";
   load(filename)
   
   n = ceil(rand()*100);
   dataMags = dataMags(:,n)
   dataPh = dataPh(:,n)
   [timeSignal, complex_unfolded, fs, dt, t] =  f2t_fill(dataMags,dataPh,freq',sample_rate);
   % 
   
   color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph
   
   
   figure
   subplot(1,3,1)
   hold on;
   plot(dataMags, freq./1e9,'color',color, LineWidth=3)
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
   xlim([2 10])
   ylim([1 5.5])
   ylabel('Frequency (GHz)')
   xlabel('Time (ns)')
   title("CWT- " + replace(tagname,"_"," ") + " " + n + " - Sample rate " + sample_rate./1e9 + " GHz - Morse [10 , 400] - VPO 48")
   % print('Fig ' + cont)
   % print('  Time resolution: ' +  mean(diff(t)))
   % print('  Freq resolution: ' +  mean(diff(f)))
   cont = cont + 1;
   
   % [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [3 , 10]);
   % sigLen = numel(timeSignal(1:end/2));
   % t = (0:sigLen-1)/fs;
   % subplot(1,3,[2,3])
   % h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
   % view(2)
   % set(h,'LineStyle','none')
   % xlim([30 48])
   % ylim([1 5.5])
   % ylabel('Frequency (GHz)')
   % xlabel('Time (ns)')
   % title("CWT- " + replace(tagname,"_"," ") + " " + n + " - Sample rate " + sample_rate./1e9 + " GHz - Morse [3 , 10] - VPO 48")

  
end