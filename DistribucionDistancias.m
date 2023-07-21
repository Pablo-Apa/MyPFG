close all
clear all
clc

filename = "medidas_referencia";
rangeID = 1;
t1 = 2;  % ns
t2 = 20; % ns

sample_rate = 8e9;
wid_param = [3,20];
color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph

listaTag = dir(filename)
num_doc = length(listaTag)

cont = rangeID;
cont1 = 1;
dist = [];
for j = 3:num_doc
    tagname = replace(listaTag(j).name,'.mat','');
    doc = filename + "/" + tagname + ".mat";
    if cont == 5
        tagname
        cont = 1;
        load(doc);
        numSig = size(dataMags,2);
        for i = 1:numSig
            dataMagsAux = dataMags(:,i);
            dataPhAux = dataPh(:,i);
            [timeSignal, complex_unfolded, fs, dt, t] =  f2t_fill(dataMagsAux,dataPhAux,freq',sample_rate);
            [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = wid_param);
            [nf,nc] = size(cfs);
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
            [pks,locs] = findpeaks(wid);
            maxidx = find(pks >= 0.5,1);
            % maxidx = find(wid == max(wid));

            dist(cont1) = t(locs(maxidx));
            cont1 = cont1 + 1;

        end
    else
        cont =cont + 1;
    end
    
end

%%  
% tempCal_50_80 = [dist(1:1000),dist(1101:end)]
% temp_10101_4x4_50_80 = dist(1001:1100)
save('tempCal_000_140_ref.mat','dist')
 % save('tempCal_80_110.mat','dist')
 %save('tempCal_110_140_1.mat','dist')
% save('temp_10101_4x4_50_80.mat','temp_10101_4x4_50_80')
%% 
close all
clc
clear all
 load('tempCal_000_140_ref.mat')
% load('tempCal_110_140_1.mat')
figure
hist(dist*1e9,40)
ylabel('Cantidad')
xlabel('Tiempo (ns)')
title('Histograma de los tiempos de inicio (50 80 calibrado)')

figure
plot(dist*1e9)


x_values = 0:0.1:20;




% figure
% hold on
% for i = 0:15
% 
%     pd = fitdist(dist(i*50+1:i*50+50)'*1e9,'Kernel','Kernel','epanechnikov')
%     y = pdf(pd,x_values);
%     plot(x_values,y)
% end
% title('Distribucion temporal de las respuestas de los tags')
% xlabel('Tiempo (ns)')
% ylabel('Cantidad')

figure
pd = fitdist(dist'*1e9,'Kernel','Kernel','epanechnikov')
y = pdf(pd,x_values);
plot(x_values,y)
title('Distribucion ')
xlabel('Tiempo (ns)')
ylabel('Cantidad')
%%
d = [50,80,110,140]*1e-2;
c= 299792458;
teoricaltime = (d*2/c)*1e9

load("tempCal_50_80_extra.mat")
dist1 = dist'*1e9;
load("tempCal_80_110_extra.mat")
dist2 = dist'*1e9;
load("tempCal_110_140_extra.mat")
dist3 = dist'*1e9;
% load("tempCal_0_110_ref.mat")
% dist4 = dist'*1e9;
% load("tempCal_000_140_ref.mat")
% dist5 = dist'*1e9;

% clear tempCal_50_80 dist temp_10101_4x4_50_80

% t = 26.25;
t = 1.24;

x_values = 0:0.05:15;

% y1 = pdf(fitdist(dist1,'Kernel','Kernel','epanechnikov'),x_values);
% y2 = pdf(fitdist(dist2,'Kernel','Kernel','epanechnikov'),x_values);
% y3 = pdf(fitdist(dist3,'Kernel','Kernel','epanechnikov'),x_values);
% y4 = pdf(fitdist(dist4,'Kernel','Kernel','epanechnikov'),x_values);
% 
% 
% [pks, locs1]=findpeaks(y1)
% [pks, locs2]=findpeaks(y2)
% [pks, locs3]=findpeaks(y3)
% [pks, locs4]=findpeaks(y4)
% 
% 
%  t = (x_values(locs1) - teoricaltime(1) +x_values(locs2) - teoricaltime(2) +x_values(locs3) - teoricaltime(3)+ x_values(locs4) - teoricaltime(4))/4 

t = 1,14;

dist1 = dist1 - t
dist2 = dist2 - t;
dist3 = dist3 - t;
% dist4 = dist4 - t;
% dist5 = dist5 - t;



y1 = pdf(fitdist(dist1,'Kernel','Kernel','epanechnikov'),x_values);
y2 = pdf(fitdist(dist2,'Kernel','Kernel','epanechnikov'),x_values);
y3 = pdf(fitdist(dist3,'Kernel','Kernel','epanechnikov'),x_values);
% y4 = pdf(fitdist(dist4,'Kernel','Kernel','epanechnikov'),x_values);
% y5 = pdf(fitdist(dist5,'Kernel','Kernel','epanechnikov'),x_values);

figure
hold on
plot(x_values,y1,'DisplayName','Dist 050-080')
plot(x_values,y2,'DisplayName','Dist 080-110')
plot(x_values,y3,'DisplayName','Dist 110-140')
% plot(x_values,y4,'DisplayName','Dist 110-140')
% plot(x_values,y5,'DisplayName','Dist 110-140')
for i = 1:4
    plot([teoricaltime(i),teoricaltime(i)],[0,1],'red')
end
% plot(x_values,y4,'DisplayName','Tag 10101 050-080')
title("Superposicion de tiempos")
xlabel('Tiempo (ns)')
ylabel('Distribucion')
lgd = legend({'Dist 050-080','Dist 080-110','Dist 110-140','Tiempos teoricos'})
% lgd = legend({'Dist 050-080','Dist 080-110','Dist 110-140','Tiempos teoricos'});
title(lgd,'Intervalos (cm)')
