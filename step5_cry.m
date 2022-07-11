recordings = dir("recordings");
disp(recordings);

% Go through each person in the recordings folder
for person = recordings'
    % GET RID OF THIS LINE:
    continue

    % ignore p1 and p2 because those are examples and not actual data
    if person.name == "p1" || person.name == "p2"
        continue
    end

    disp(person.name);

    % go through their left hand recordings
    leftPath = "recordings/"+person.name+"/left";
    leftFrequencies = dir(leftPath);

    % see each frequency they had a recording for
    for leftFrequency = leftFrequencies'

        leftFrequencyPath = leftPath+"/"+leftFrequency.name+"/*.wav";
        leftFrequencyDir = dir(leftFrequencyPath);
        
        % see the actual audio file with the sound for that specific
        % frequency
        for leftRecordings = leftFrequencyDir'
            if leftRecordings.isdir == 0

                % go to https://regex101.com/ in order to get a better
                % explanation of how this regex pattern works
                frequencyTokens = regexp(leftFrequency.name,"_([0-9]*)(k?)hzto([0-9]*)(k?)hz_([0-9]*)(k?)hzfs_([0-9]*)ms_(?:[0-9]*ms_)?(?i)Repeat([0-9]*)", "tokens");
                frequencyInfo = frequencyTokens{1};

                % extract minimum frequency from folder name
                frequencyMin = str2double(frequencyInfo(1));
                isFrequencyMinInKHZ = frequencyInfo(2) == "k";

                % if the number is khz, multiply by 1000 to get equivalent
                % in hz
                if(isFrequencyMinInKHZ)
                    frequencyMin = frequencyMin * 1000;
                end

                % extract maximum frequency from folder name
                frequencyMax = str2double(frequencyInfo(3));
                isFrequencyMaxInKHZ = frequencyInfo(4) == "k";

                % if the number is khz, multiply by 1000 to get equivalent
                % in hz
                if(isFrequencyMaxInKHZ)
                    frequencyMax = frequencyMax * 1000;
                end

                % extract sampling rate from folder name
                samplingRate = str2double(frequencyInfo(5));
                isSamplingRateInKHZ = frequencyInfo(6) == "k";

                % if the number is khz, multiply by 1000 to get equivalent
                % in hz
                if(isSamplingRateInKHZ)
                    samplingRate = samplingRate * 1000;
                end

                % convert the chirp time from ms to seconds 
                chirpTime = str2double(frequencyInfo(7))/1000; 
                
                % extract repitions from folder name
                repitionsPerSignal = str2double(frequencyInfo(8));

                disp(leftFrequency.name);
                disp(leftRecordings.name);

                disp(isFrequencyMinInKHZ);
                disp(frequencyMin);
                disp(chirpTime);
                disp(repitionsPerSignal);
            end
        end
    end
end

person = cross_correlate_attempt(16e3, 50, 500, 0.125,20, 'Fadi/Quiet/record_2022-07-09 14_58.wav');

% Failed
% person = cross_correlate_attempt(48e3, 16e3, 24e3, 0.125,10, 'p2/1.wav');

save_directory = "user_data/";
file_name="p2/Galaxy_Office_R";
if ~exist(save_directory, 'dir')
       mkdir(save_directory);
end
save([save_directory file_name], 'person');