clear all
close all
clc

filename = 'tag_4800_50_140_';
datasetName = 'Datasets/Dataset_AO_uni'
t1 = 2;
t2 = 20;

sample_rate = 8e9;
color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph




listaTag = dir(filename);
num_doc = length(listaTag);

for j = 3:num_doc

    idtag = j
    tagname = replace(listaTag(idtag).name,'.mat','');
    doc = filename + "/" + tagname + ".mat";
    load(doc);
    numSig = size(dataMags,2);
    cont = 1;
    for i = 1:numSig
        dataMagsAux = dataMags(:,i);
        dataPhAux = dataPh(:,i);

        [timeSignal, complex_unfolded, fs, dt, t] =  f2t_fill(dataMagsAux,dataPhAux,freq',sample_rate);
        [cfs, f] = cwt(real(timeSignal(1:end/2)), fs,'morse', VoicesPerOctave = 48, WaveletParameters = [10 , 400]);

        [nf,nc] = size(cfs);
        tam = ceil((nc/t(end))*5e-9); % el tamaño de la ventana son 10 ns pues es el tamañoq ue se desea capturar

        nf2 = nf - find(fliplr(f') >= 1.5e9,1) + 1;
        nf1 = find(f <= 5e9, 1) - 1;

        if cont == 3
            nc1 = ceil((nc/(t(end/2)*1e9))*t1);
            nc2 = ceil((nc/(t(end/2)*1e9))*t2);
            if tagname ==  'tag_10101_4x4_050_080_1'
                nc1 = ceil((nc/(t(end/2)*1e9))*(t1 + 26.3));
                nc2 = ceil((nc/(t(end/2)*1e9))*(t2 + 26.3));
            end
        else
            nc1 = ceil((nc/(t(end/2)*1e9))*(t1 + 26.3));
            nc2 = ceil((nc/(t(end/2)*1e9))*(t2 + 26.3));
        end
        % nc1 = ceil((nc/(t(end/2)*1e9))*t1);
        % nc2 = ceil((nc/(t(end/2)*1e9))*t2);
        aux = reshape(cfs(nf1:nf2,nc1:nc2),[1,(nf2-nf1+1)*(nc2-nc1+1)]);
        aux = reshape(normalize(abs(aux), 'range'),[(nf2-nf1+1),(nc2-nc1+1)]);
        [ncfs, nf] = dfuniform(aux,f(nf1:nf2),t(nc1:nc2));
        % csvwrite("Dataset_AO_uni\" + tagname(1:13) + "\" + tagname(1:21) + "_" + num2str(cont1) + ".csv", aux);
        feature = ncfs;
        label = tagname(1:9);
        dim = str2num(tagname(11));
        range = tagname(15:21);
        save(datasetName + "/" + tagname(1:end-1) + num2str(cont) + ".mat","feature","label","dim","range")
        cont = cont + 1;
    end
    j
end