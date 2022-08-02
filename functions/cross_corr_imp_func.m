function cross_corr_imp_func = cross_cor_imp_func(file_path)
    fs = 16e3;
    og_file = './transmissions/transmissions_chirp_50hzto500hz_16khzfs_125ms_100ms_Repeat20.wav';
    freq_min = 50; freq_max = 500;

    freq_set = zeros(1,5); % Preallocate space for frequencies
    freq_dex = 1; % Index counter for freq_set
    
    %% This loop creates set of frequencies of chirps
    for i=freq_min:10:freq_max % Loop in steps of 1k
       freq_set(freq_dex) = i;
       freq_dex = freq_dex+1;
    end
    
    %% Parameters continued
    chirp_time = 0.125; % Single chirp duration in ms
    window_len = 0.1; % Percentage of chirp to envelope (front and end)
    
    how_many_reps_per_freq = 2; % Choose 1 for no extra repetitions
    how_many_reps_per_signal = 20; % Choose 1 for no extra repetitions
    
    [signal_full, signal_duplicate, pilot] = ...
        func_chirp_gen(fs, freq_set, chirp_time, window_len, ...
        how_many_reps_per_freq, how_many_reps_per_signal);
    
    %% Final signal for cross correlation
    freq_range = [freq_set(1), freq_set(end)];
    chirp_sig = audioread(og_file);
    
    
    %% Cross Correlation to find signal in recording
    disp('Filtering...');

    [x,~] = audioread([file_path]); % read sequence from filename
    % disp(x(:,1))
    mic_a = bandpass(x(:,1), freq_range, fs);
    
    [acor_a, lag_a] = xcorr(mic_a, chirp_sig);
    
    % Normal Cross-correlation to find signal in recording
    try
        [~,Ia] = max(abs(acor_a)); % Find the index of max value in autocorr
        start = lag_a(Ia);
        disp(start)
        disp(start + length(chirp_sig) -1)
        mic_a = mic_a(start:start + length(chirp_sig) -1); % chirp extracted from file
        mic_a = mic_a(length(pilot)+1:end); % Remove pilot from front
    
        mic_a = mic_a';
    catch
        disp('Automated filtering failed...');
        disp('Manual supervision required...');
        [~,z] = sort(abs(acor_a)); %sort acor_a from min to max
        cc_counter = 1; %counter to track which proposed trim to use
        for j = 1:length(chirp_sig)
            z_start = lag_a(z(j)); %find the maximum of lag_a
            z_ending = z_start+length(chirp_sig)-1;
            if z_ending < length(mic_a) && z_start > 0
                %figure; plot(mic_a(z_start:z_ending));
                % usr_cont = input(['#' num2str(cc_counter) ...
                %' @ Index ' num2str(z(j)) ': Enter 1 to continue, 0 to stop: ']);
                cc_counter = cc_counter+1;
                %if usr_cont ~= 1
                %    close all; 
                %    break
            end
        end
        mic_a = mic_a(z_start:z_ending); % chirp extracted from file
        mic_a = mic_a(length(pilot)+1:end); % Remove pilot from front
        mic_a = mic_a';
    end

    figure; plot(mic_a);
    
    
    %% Data structure for signals
    disp('Segmenting chirp chains...');
    samples_start = 0; % length(pilot);
    samples_gap = 16e3; % length(signal_duplicate);
    samples_end = samples_start+samples_gap;
    
    disp("sample gap, start, end")
    disp(samples_gap)
    disp(samples_start)
    disp(samples_end)
    samples_num = 20; %how_many_reps_per_signal; % number of repeating signals in file
    samples = zeros(samples_num, samples_gap); % preallocate space

    for i=1:samples_num
        samples(i,:) = mic_a((i-1)*samples_gap+i*samples_start+1:i*samples_end);
    end
    
    disp('Segmenting individual chirps...');
    samples_points = 1200; % 1200 points in single chirp
    samples_num_chirps = samples_num*20; % number of chirps in sample, 10 chirps per sample
    samples_chirps = zeros(samples_num_chirps, samples_points); % preallocate space
    
    sc_counter = 1; % counter to add chirps to matrix correctly

    chirp_length = 20000;
    buffer_length = 16001;
    chirp_buffer_length = chirp_length + buffer_length;
    chirps1 = [];
    ct = 1;
    if length(mic_a) < 704020
        mic_a = [mic_a zeros(1, 704020 - length(mic_a))];
    end
    disp("Size mic_a")
    disp(size(mic_a))
    mic_a = mic_a';
    % for ct = 1:samples_num
        for j = 1:chirp_buffer_length:length(mic_a)
            disp(ct)
            ct = ct + 1;
            disp(j+chirp_length-1)
            chirps1 = [chirps1, mic_a(j:j+chirp_length-1)];
        end
    
    disp("chirps1 size")
    disp(size(chirps1))
    chirps1 = chirps1';

    person = profile;
    person.samples = samples; person.samples_chirps = chirps1;
    
    [save_directory, file_name, extension] = fileparts(strrep(file_path,'user_data','final_cross_corr_data'));
    disp(save_directory);
    disp(file_name)

    if ~exist(save_directory, 'dir')
       mkdir(save_directory);
    end
    save_path = strcat(string(save_directory), '/', string(file_name), '.mat');
    disp(save_path)
    save(save_path, 'person');
    
    %% End Program
    disp('Done!');
end