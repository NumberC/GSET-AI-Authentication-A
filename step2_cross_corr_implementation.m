base_path = "./user_data/";
recordings = dir(base_path);

% Go through each person in the recordings folder
for person = recordings'
    % go through their left hand recordings
    disp(person)
    loudFiles = dir(base_path + person.name + "/Loud/");
    
    % see each frequency they had a recording for
    for lfile = loudFiles'
        if strcmp(lfile.name, '.') ~= 1 & strcmp(lfile.name,'..') ~= 1
            disp("In IF")
            file_path = base_path + person.name + "/Loud/" + lfile.name;
            disp(lfile)
            cross_corr_imp_func(file_path)
            continue
        end
    end
    
    quietFiles = dir(base_path + person.name + "/Quiet/");
    
    % see each frequency they had a recording for
    for qfile = quietFiles'
        if strcmp(qfile.name, '.') ~= 1 & strcmp(qfile.name,'..') ~= 1            
            file_path = base_path + person.name + "/Quiet/" + qfile.name;
            disp(qfile)
            cross_corr_imp_func(file_path)
            continue
        end 
    end
end
