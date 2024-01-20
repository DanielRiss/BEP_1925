function [dilationData] = Pupillometry(pupilData)

    T = readtable(pupilData,'Delimiter',' ', 'FileType', 'text');

    % Assuming your table is named 'T'
    for col = 1:size(T, 2)
        if iscell(T{1, col}) % Check if the column contains cells
            T{:, col} = cellfun(@(x) str2double(strrep(x, ',', '.')), T{:, col}, 'UniformOutput', false);
        end
    end

    dilationData = table2array(T);

    %make time to be seconds from the start
    initial_time = dilationData{1, 1}; % Extract the initial time value
    dilationData(:, 1) = cellfun(@(x) x - initial_time, dilationData(:, 1), 'UniformOutput', false);

end