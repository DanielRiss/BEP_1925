function [episodes] = runI2MC(filenameF)

    % Read the JSON file content as a string
    jsonStr = fileread(filenameF);

    % Decode the JSON string using jsondecode
    fixationStruct = jsondecode(jsonStr);

    % Convert the fixation structure to matrix
    fixationCell = struct2cell(fixationStruct)';

    firstTimeStamp = fixationCell(1, 5);

    nanRows = any(cellfun(@(x) any(strcmpi(x, 'NaN')), fixationCell), 2);
    fixationCell(nanRows, :) = [];

    fixationMatrix = cell2mat(fixationCell);

    data.t          = fixationMatrix(:, 5);    % time signal
    data.left.X     = fixationMatrix(:, 3);    % horizontal gaze signal of left eye
    data.left.Y     = fixationMatrix(:, 4);    % vertical gaze signal of left eye
    data.right.X    = fixationMatrix(:, 3);    % horizontal gaze signal of right eye
    data.right.Y    = fixationMatrix(:, 4);    % vertical gaze signal of right eye
    % add other info about data
    data.freq       = 1000;                     % sampling frequency (Hz)

    % do fixation classification
    % the output is a struct containing the starts and ends of fixations
    % (sample numbers)
    episodes        = I2MC(data, 'left', struct());

    episodes.startT = data.t(episodes.start);
    episodes.endT   = data.t(episodes.end);

    % print fixation start and end on the command window

    k = height(episodes.startT) + 1;
    
    p = 1;
    while p < k
        if ((episodes.endT(p) - episodes.startT(p))/10 < 60)
            episodes.startT(p, :) = [];
            episodes.endT(p, :) = [];
            episodes.medX(:, p) = [];
            episodes.medY(:, p) = [];
            episodes.start(:, p) = [];
            episodes.end(:, p) = [];
            k = k-1;
        else
            p = p+1;
        end
    end
    fprintf('%d fixations classified\n', length(episodes.startT));
    % 
    % for j = 1:length(episodes.startT)
    %     fprintf('%3d: %4.0f -- %4.0f: %4.0f\n', j, episodes.startT(j), episodes.endT(j), (episodes.endT(j) - episodes.startT(j))/10);
    % end
end
