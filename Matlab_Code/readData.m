function [dataTable, actualFirstTime, firstTimeStamp] = readData(ePrimeTime, tobiiEye, resolution, actualIndex)
    % -------------------------------------------------------------------------
    % Author(s): [Daniël Ris, Linghan Zhang]
    % READDATA Reads and maps ePrime and Tobii data.
    % [dataTable, fixationArray] = readData(ePrimeTime, tobiiEye, resolution, actualIndex)
    %
    % This function reads ePrime and Tobii data, maps fixation coordinates to screen
    % coordinates, and provides two matrices: dataTable and fixationArray.
    %
    % Input:
    % - ePrimeTime: Filepath to the ePrime data file (.txt).
    % - tobiiEye: Filepath to the Tobii data file (fixture...json).
    % - resolution: Screen resolution [width, height].
    % - actualIndex: Participant's actual index.
    %
    % Output:
    % - dataTable: Table containing participant information.
    % - fixationArray: Matrix containing fixation coordinates and timestamps.
    % -------------------------------------------------------------------------
    
    %% Reading in Eprime
    % Check if the ePrime file exists
    if ~exist(ePrimeTime, 'file')
        error('File does not exist: %s', ePrimeTime);
    end

    % Open the ePrime file
    fid = fopen(ePrimeTime, 'r');

    % Check if the file was opened successfully
    if fid == -1
        error('Could not open the file: %s', ePrimeTime);
    end

    % Read the ePrime text file into a table
    dataTable = readtable(ePrimeTime, 'Delimiter', '\t', VariableNamingRule='preserve');

    % Get the current column names
    currentColumnNames = dataTable.Properties.VariableNames;

    % Replace dots with underscores
    newColumnNames = cellfun(@(x) strrep(x, '.', '_'), currentColumnNames, 'UniformOutput', false);

    % Update the column names in the table
    dataTable.Properties.VariableNames = newColumnNames;

    dataTable = dataTable(1, :);

    % Extract hours, minutes, and seconds from the SessionTime column
    sessionTimeComponents = datevec(dataTable.SessionTime, 'HH:MM:SS');
    hours = sessionTimeComponents(:, 4);
    minutes = sessionTimeComponents(:, 5);
    seconds = sessionTimeComponents(:, 6);

    % Convert each component to milliseconds
    hoursInMilliseconds = hours * 60 * 60 * 1000;
    minutesInMilliseconds = minutes * 60 * 1000;
    secondsInMilliseconds = seconds * 1000;

    % Sum the components to get the total time in milliseconds
    sessionTimeInMilliseconds = hoursInMilliseconds + minutesInMilliseconds + secondsInMilliseconds;

    % Update the SessionTime column in the table
    dataTable.SessionTime = sessionTimeInMilliseconds;

    % Calculate start and finish times for Instruction 1
    instruction1Start = dataTable.Instruction1_FirstFrameTime * 100;  % Add three zeros to convert to milliseconds
    instruction1Finish = instruction1Start + (dataTable.Instruction1_FramesDisplayed / 30) * 1000;

    % Calculate start and finish times for Instruction 2
    instruction2Start = dataTable.Instruction2_FirstFrameTime * 1000;  % Add three zeros to convert to milliseconds
    instruction2Finish = instruction2Start + (dataTable.Instruction2_FramesDisplayed / 30) * 1000;

    % Add the calculated columns to the table
    dataTable.Instruction1_Start = instruction1Start;
    dataTable.Instruction1_Finish = instruction1Finish;
    dataTable.Instruction2_Start = instruction2Start;
    dataTable.Instruction2_Finish = instruction2Finish;
    dataTable.actualIndex = actualIndex;

    % Assuming your table is named 'yourTable'
    variablesToKeep = {
        'SessionTime', ...
        'Instruction1_FirstFrameTime', 'Instruction1_FramesDisplayed', ...
        'Instruction2_FirstFrameTime', 'Instruction2_FramesDisplayed', ...
        'Instruction1_Start', 'Instruction1_Finish', ...
        'Instruction2_Start', 'Instruction2_Finish', ...
        'actualIndex'
    };

    % Keep only the specified variables in the table
    dataTable = dataTable(:, variablesToKeep);

    % Close the ePrime file
    fclose(fid);
    
    %% Tobii Fixation File
    % Read the JSON file content as a string
    jsonStr = fileread(tobiiEye);

    % Decode the JSON string using jsondecode
    fixationStruct = jsondecode(jsonStr);

    % Convert the fixation structure to a cell array
    fixationCell = struct2cell(fixationStruct);

    % Extract fixation start and end times
    firstTimeStamp = fixationCell(9, 1);
    actualFirstTime = split(cell2mat(fixationCell(11, 1)), ["T", "+"]);
    actualFirstTime = timeStrToMilliseconds(actualFirstTime(2));

    function timeMilliseconds = timeStrToMilliseconds(timeStr)
        % Convert time in string format to milliseconds
        timeArray = split(timeStr, ":");
        hour = str2double(cell2mat(timeArray(1)));
        minute = str2double(cell2mat(timeArray(2)));
        second = str2double(cell2mat(timeArray(3)));
        timeMilliseconds = (hour * 3600 + minute * 60 + second) * 1000;
    end
end

