function [timeSignal, complex_unfolded, fs , dt, t] =  f2t_fill(mag_s11,phase_s11,freq,sample_rate)

if sample_rate == 0
    sample_rate = freq(end);
end
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

timeSignal = ifft(ifftshift(complex_unfolded))./dt;
end