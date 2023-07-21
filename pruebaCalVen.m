close all
clear all
clc

filename= "medidas_extras"
listaTag = dir(filename) 
sample_rate = 8e9;
color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph
t1 = 2;  % ns
t2 = 20; % ns

idtags = [3,6,9,12,15,18,21,24,27,30,33,36,39,41,45,48];
ns = [2,23,66,27,62,18,6,72];

for j = 1:50

   idtag = ceil(rand()*48) + 2;
   n = ceil(rand()*50);
   % idtag = 14;
    % n = 47;
   %idtag = idtags(j);
   %n = ns(j);


   tagname = replace(listaTag(idtag).name,'.mat','');
   doc = filename + "/" + tagname + ".mat";
   load(doc);
   dataMags = dataMags(:,n);
   dataPh = dataPh(:,n);

   [timeSignal, complex_unfolded, fs, dt, t] =  f2t_fill(dataMags,dataPh,freq',sample_rate);
   [cfs1, f1] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [10 , 200]);
   [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [3 , 20]);
   % [ncfs, nf] = dfuniform(cfs,f,t);
    ncfs = cfs;
   [nf,nc] = size(ncfs);
   tam = ceil((nc/t(end))*5e-9); % el tamaño de la ventana son 10 ns pues es el tamañoq ue se desea capturar
    


            nth1 = ceil((nc/(t(end/2)*1e9))*t1) + 1;
            nth2 = ceil((nc/(t(end/2)*1e9))*t2) + 1;

            wid = [];
            for i = 1:nc-tam
                if i >= nth1 && i <= nth2
                    wid(i) = mean(mean(abs(cfs(:,i:i+tam-1))));
                else
                    wid(i) = 0;
                end
            end

            wid(nth1:nth2) = normalize(wid(nth1:nth2), 'range');
            [pks ,locs] = findpeaks(wid(nth1:nth2));
            maxidx = find(pks >= 0.5,1);

    % wid = [];
    % for i = 1:nc-tam
    %     wid(i) = mean(mean(abs(ncfs(:,i:i+tam-1))));
    % end
    % 
    % wid = normalize(wid, 'range');
    % [pks,locs] = findpeaks(wid);
    % maxidx = find(pks >= 0.5,1);
    % maxidx = find(wid == max(wid));
    tp = t(locs(maxidx) + nth1 - 1);
    

    figure
    subplot(3,1,[1,2])
    h = surf(t(1:end/2).*1e9,f./1e9,abs(cfs),"CDataMapping","scaled");
    hold on
    % plot([tp3,tp3,tp3 + 10e-9,tp3 + 10e-9,tp3]*1e9,[1.5,5,5,1.5,1.5],'red')
    view(2)
    set(h,'LineStyle','none')
    xlim([0, 30])
    ylim([1 5.5])
    ylabel('Frequency (GHz)')
    xlabel('Time (ns)')
    title("CWT- " + replace(tagname,"_"," ") + " " + n + " - Sample rate " + sample_rate./1e9 + " GHz - Morse "  + " - VPO 48")
    
    % subplot(3,1,3)
    % plot(t(1:end/2)*1e9,normalize(real(timeSignal(1:end/2)),'range'))
    % hold on
    % plot([tp,tp]*1e9,[0,1],'red')
    % plot([tp+10e-9,tp+10e-9]*1e9,[0,1],'red')
    % ylabel('Potencia (GHz)')
    % xlabel('Time (ns)')
    % xlim([0, 100])
    subplot(3,1,3)
    plot(t(1:end/2 - tam)*1e9,wid)
    hold on
    plot([tp,tp]*1e9,[0,1],'red')
    plot([tp+10e-9,tp+10e-9]*1e9,[0,1],'red')
    ylabel('Potencia (GHz)')
    xlabel('Time (ns)')
    xlim([0, 30])

    j
end