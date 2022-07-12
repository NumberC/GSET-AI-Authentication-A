clear; clc; close all;

% Perform feature extraction on all user profiles in a given folder. Simply
% provide the user ID for the files_num variable.

userDataDir = dir("user_data");
for individualUserFolder = userDataDir'
    userName = individualUserFolder.name;
    
    if userName == "p1" || userName == "p2"
        files_dir =['user_data/' userName '/'];
    else
        files_dir = ['user_data/' userName '/Quiet/'];
    end

    files = dir(files_dir);
    files = {files(3:end).name}';
    files = string(files);
    
    for i=1:length(files)
        disp(['(' num2str(i) '/' num2str(length(files)) ...
            ') Extracting features for ' files_dir char(files(i))]);
        
        load([files_dir char(files(i))]);
        
        [...
            person.average, person.std, ...
            person.max, person.min, ...
            person.rge, person.variance, ...
            person.change, ...
            person.q1, person.q2, person.q3, person.q4, ...
            person.skew, person.kurt, ...
            person.fft, person.mfcc, ...
            person.fbe, person.frames ...
            ] = get_features(person.samples_chirps');
        
        person.features = [...
            person.average; person.std; ...
            person.max; person.min; ...
            person.rge; person.variance; ...
            person.change; ...
            person.q1; person.q2; person.q3; person.q4; ...
            person.skew; person.kurt; ...
            person.fft; person.mfcc; ...
            person.fbe; person.frames ...
            ];

        
        save([files_dir char(files(i))], 'person');
        clear person;
    end
    
    disp('Done!');
end