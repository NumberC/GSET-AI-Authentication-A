base_path = './combo_gesture_data/';
recordings = dir(base_path);
model_data = []; 
gestures_list = [];
gestureNames = {};

for person = recordings'
    if strcmp(person.name, 'Aashi') == 1 | strcmp(person.name, 'Fadi') == 1 | strcmp(person.name, 'Aashika') == 1 
        loudFiles = dir(strcat(base_path, person.name, "/Gesture1/"));
        for lfile = loudFiles'
            if strcmp(lfile.name, '.') ~= 1 & strcmp(lfile.name,'..') ~= 1
               file_path = strcat(base_path, person.name, "/Gesture1/", lfile.name);
               data = load(file_path);
                gestures_list = [gestures_list data.g1];
                gestureNames{end+1} = strcat(person.name, "_", "g1");
                disp(file_path)
               continue
            end
        end
        quietFiles = dir(strcat(base_path, person.name, "/Gesture2/"));
        for qfile = quietFiles'
            if strcmp(qfile.name, '.') ~= 1 & strcmp(qfile.name,'..') ~= 1
                file_path = strcat(base_path, person.name, "/Gesture2/", qfile.name);
                data = load(file_path);
                gestures_list = [gestures_list data.g1];
                gestureNames{end+1} = strcat(person.name, "_", "g2");
                disp(file_path)
                continue
            end
        end
    end
end

names = {}
for i = 16001:16330
    names{end+1} = strcat("Var", string(i));
end
for i = 1:length(gestures_list)
    i_data = array2table(gestures_list(i).audio); %, 'VariableNames', {'Audio'});
    t_data = array2table(gestures_list(i).accel, 'VariableNames', cellstr(names)); %, 'VariableNames', {'Accel'});
    p_label = array2table(cellstr(repmat(gestureNames(i),20,1)),'VariableNames',{'Person'});
    test_table = [i_data t_data p_label];
    disp("Dimensions")
    disp(size(test_table))
    model_data = [model_data; test_table]; 
end

disp(size(model_data))