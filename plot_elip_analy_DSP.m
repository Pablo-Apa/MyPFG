close all
clear all

list_sample_rate = [0, 25e9,40e9,45e9];
n_sample_rate = length(list_sample_rate);
j = 1;

for rep = [7]
    % open data
    filename = "data/data_s11_antenna"+rep+".mat";
    load(filename)
    
    for sample_rate = list_sample_rate % vary the sample rate: will give more TIME resolution
        
        
        if sample_rate == 0
            sample_rate = freq(end);
        end
        color = [0.954174456379543	0.0319226295039784	0.356868986182542]; % pretty color for graph

       % plot mag and phase
        f = figure(1);
        subplot 211
        hold on;
        plot(freq./1e9, mag_s11,'color',color, LineWidth=3)
        xlabel('Frequency(GHz)')
        ylabel('Magnitude (dB)')
        set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        subplot 212
        hold on;
        plot(freq./1e9, phase_s11,'color',color, LineWidth=3)
        xlabel('Frequency(GHz)')
        ylabel('Phase (rad)')
        set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        f.Position = [100 100 740 600];

        % mag and phase to linear
        complex = 10.^(mag_s11./20).*(cosd(phase_s11)+1i*sind(phase_s11));

        % get freq and time resolution values from data
        df = mean(diff(freq)); % frequency step
        fs = 2*(sample_rate+df); % sample rate (samples/s)
        dt = 1/fs; % time step

        % We have to: 1. Fill in the freq. spectrum from DC to f(1)
        %             2. Fill in the freq. spectrum from f(end) to sample
        %             rate
        %             3. Duplicate the frequency spectrum to negative freqs.

        % 1. Fill in the freq. spectrum from DC to freq(1)
        freq_dc_fstart = 0:df:freq(1)-df;
        freq_dc_fend = [freq_dc_fstart'; freq];

        % 2. Fill in the freq. spectrum from freq(end) to sample rate
        freq_fend_sampr = freq(end)+df:df:sample_rate;
        freq_dc_sampr = [freq_dc_fend; freq_fend_sampr'];

        % 3. Duplicate the frequency spectrum to negative freqs.
        NSamples = 2*length(freq_dc_sampr); % (1/df/dt); % number of points
        t = (0:NSamples-1)*dt; % time axis
        freq_unfolded = [-flipud(freq_dc_sampr); freq_dc_sampr];

        mag_dc_sampr = [zeros(length(freq_dc_fstart), 1); mag_s11; zeros(1,length(freq_fend_sampr))'];
        mag_unfolded = [flipud(mag_dc_sampr); mag_dc_sampr];
        complex_60_85GHz_100GHz = zeros(1,length(freq_fend_sampr));
        complex_dc_sampr = [zeros(length(freq_dc_fstart), 1); complex; zeros(1,length(freq_fend_sampr))'];
        complex_unfolded = [flipud(complex_dc_sampr); complex_dc_sampr];

        %mag_unfolded = [flipud(mag_s11); zeros(1,length(freq_dc_fstart)*2)'; mag_s11];
        %complex_unfolded = [flipud(complex); zeros(1,length(freq_dc_fstart)*2)'; complex];

        % Plot unfolded mag
        % f = figure(2), plot(freq_unfolded./1e9, mag_unfolded, 'LineWidth',3)
        % hold on, plot(freq./1e9, mag_s11, 'LineWidth',3, 'LineStyle','--')
        % xlabel('Frequency(GHz)')
        % ylabel('Magnitude (dB)')
        % set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        % f.Position = [100 100 740 300];

        %IFFT
        timeSignal = ifft(ifftshift(complex_unfolded))./dt;
        f = figure(4), subplot 311, hold on, plot(t.*1e9,timeSignal, 'LineWidth',3) % Plot time domain signal after IFFT
        xlim([0 20])
        xlabel('Time(ns)')
        ylabel('Amplitude')
        title('Real part of time domain signal')
        set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        subplot 312, hold on, plot(t.*1e9,imag(timeSignal), 'LineWidth',3) % Plot time domain signal after IFFT
        xlim([0 20])
        xlabel('Time(ns)')
        ylabel('Amplitude')
        title('Imag part of time domain signal')
        set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        subplot 313, hold on, plot(t.*1e9,abs(timeSignal), 'LineWidth',3) % Plot time domain signal after IFFT
        xlim([0 20])
        xlabel('Time(ns)')
        ylabel('Amplitude')
        title('Absolute value of time domain signal')
        set(gca,'fontname','times', 'FontSize', 20, 'FontWeight', 'bold')
        f.Position = [100 100 740 900];

        % STFT
        [s, fstft, tstft] = stft(real(timeSignal(1:end/2)),fs,FFTLength=length(complex_unfolded),OverlapLength=127,FrequencyRange="onesided"); %,Window=kaiser(128,5));%,OverlapLength=22,FFTLength=1024);
        sdb(:,:) = mag2db(abs(s(1:10:end, 1:10:end)));
        fig = figure(j+sample_rate/1e9+rep)
        subplot(1,4, j)
        h = surf(tstft(1:10:size(sdb(1:end, 1:end), 2)*10).*1e9, fstft(1:10:size(sdb(1:end, 1:end), 1)*10)./1e9,sdb(1:end, 1:end))
        cc = max(sdb(:)) + [-60 0];
        ax = gca;
        ax.CLim = cc;
        set(h,'LineStyle','none')
        view(2)
        xlim([0 6])
        ylim([0 13])
        ylabel('Frequency (GHz)')
        xlabel('Time (ns)')
        title("STFT - Sample rate " + sample_rate./1e9 + " GHz")

        % CWT
        [cfs, f] = cwt(real(timeSignal(1:end/2)), fs);
        sigLen = numel(timeSignal(1:end/2));
        t = (0:sigLen-1)/fs;

        subplot(1,4, j+1)
        hold on;
        h = surf(t.*1e9,f./1e9,abs(cfs),"CDataMapping","scaled")
        view(2)
        set(h,'LineStyle','none')
        xlim([0 6])
        ylim([0 13])
        ylabel('Frequency (GHz)')
        xlabel('Time (ns)')
        title("CWT - Sample rate " + sample_rate./1e9 + " GHz")

        %                 cc = max(abs(cfs(:))) + [4.0782e+08-20 4.0782e+08];
        %                 ax = gca;
        %                 ax.CLim = cc;

        % WVD
        subplot(1,4, j+2)
        wvd(real(timeSignal), sample_rate*2)
        xlim([0 6])
        ylim([0 13])
        ylabel('Frequency (GHz)')
        xlabel('Time (ns)')
        title("WVD - Sample rate " + sample_rate./1e9 + " GHz")

        subplot(1,4, j+3)
        wvd(real(timeSignal),sample_rate*2, 'smoothedPseudo');
        %         h = surf(t(1:end),f(1:end), d2(1:end, 1:end))
        %         view(2)
        %         set(h,'LineStyle','none')

        xlim([0 6])
        ylim([0 13])
        title("WVD Smooth - Sample rate " + sample_rate./1e9 + " GHz")
        fig.Position = [300 300 1440 300];
        
        clearvars -except rep j mag_s11 freq phase_s11 n_sample_rate
        
    end
    j = 1;
end