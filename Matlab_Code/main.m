close all
clear
clc

% Specify the root folder for data
root = "C:\Users\20203132\Desktop\1925_Data"; 

% Define the resolution of the screen
resolution = [1024 768];

%% Reading in Eprime & Tobii Files
% Initialize an empty table to store the results
participantData = table();
slideTable = table();
firstTimeStamps = table();
combinedPupil = table(cell(52, 1), 'VariableNames', {'CellArrays'});

% Specify the number of participants
numParticipants = 66;

for participantIndex = 1:66
    disp('------------------------------------')
    disp(' ');
    fprintf('Reading in data for participant %d...\n------------------------------------\n', participantIndex);
    % Generate the participant identifier string
    participantString = ['P', num2str(participantIndex)];

    % Construct the file paths for PrimeTime and Fixture data
    filenameE = fullfile(root, [participantString, '\', participantString, 'E.json']);
    filenameF = fullfile(root, [participantString, '\', participantString, 'FD.json']);
    filenameQ = fullfile(root, [participantString, '\', participantString, 'Q.txt']);
    filenameP = fullfile(root, [participantString, '\', participantString, 'PU.pup']);

    % Check if files exist
    if ~exist(filenameQ, 'file')
        error('File does not exist: %s', filenameQ);
    end

    if ~exist(filenameF, 'file')
        error('File does not exist: %s', filenameF);
    end

    if participantIndex < 4 || participantIndex == 5 || participantIndex == 17 || ...
            participantIndex == 19 || participantIndex == 20 || participantIndex == 21 || ...
            participantIndex == 29 || participantIndex == 31 || participantIndex == 33 || ...
            participantIndex == 39 || participantIndex == 47 || participantIndex == 49 || ...
            participantIndex == 64
        fprintf('Skipped participant %d\n', participantIndex)
        continue;
    end

    % Read data and obtain fixation array
    [readTable, actualFirstTime, firstTimeStamp] = readData(filenameQ, ...
        filenameE, resolution, participantIndex);
    fprintf('Participant %d general data read\n', participantIndex)
    [dilationData] = Pupillometry(filenameP);
    fprintf('Participant %d pupil data read\n', participantIndex)
    fixationStruct = runI2MC(filenameF);
    fprintf('Participant %d fixation data read\n', participantIndex)

    % Get question data
    [slideQuestions] = ReadQuestions(filenameQ);
    fprintf('Participant %d survey data read\n', participantIndex)
    % Assign fixation data to the cell array
    if participantIndex < 5
        combinedStruct(participantIndex - 3) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 3} = dilationData;
    elseif participantIndex < 17
        combinedStruct(participantIndex - 4) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 4} = dilationData;
    elseif participantIndex < 19
        combinedStruct(participantIndex - 5) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 5} = dilationData;
    elseif participantIndex < 20
        combinedStruct(participantIndex - 6) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 6} = dilationData;
    elseif participantIndex < 21
        combinedStruct(participantIndex - 7) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 7} = dilationData;
    elseif participantIndex < 29
        combinedStruct(participantIndex - 8) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 8} = dilationData;
    elseif participantIndex < 31
        combinedStruct(participantIndex - 9) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 9} = dilationData;
    elseif participantIndex < 33
        combinedStruct(participantIndex - 10) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 10} = dilationData;
    elseif participantIndex < 39
        combinedStruct(participantIndex - 11) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 11} = dilationData;
    elseif participantIndex < 47
        combinedStruct(participantIndex - 12) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 12} = dilationData;
    elseif participantIndex < 49
        combinedStruct(participantIndex - 13) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 13} = dilationData;    
    elseif participantIndex < 64
        combinedStruct(participantIndex - 14) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 14} = dilationData;
    else
        combinedStruct(participantIndex - 15) = fixationStruct;
        combinedPupil.CellArrays{participantIndex - 15} = dilationData;
    end

    % Append results to the finalDataTable
    participantData = [participantData; readTable];
    slideTable = [slideTable; slideQuestions];
    firstTimeStamps = [firstTimeStamps; firstTimeStamp];
end

%% Mapping Data & Creating Plots
% Map time and perform plots
disp(' ')
disp(' ')
disp(' ')
disp('Mapping eye-tracking data to timestamps...');
disp('------------------------------------------')
participantDataMapped = mappingTime(participantData, combinedStruct, ...
    actualFirstTime, firstTimeStamps, combinedPupil);

disp(' ')
disp(' ')
disp(' ')
disp('Calculating pupil dilation changes...');
disp('-------------------------------------')
calculatedDilation = calculateDilation(participantDataMapped, combinedPupil);

% Call function to create and display plots
disp(' ')
disp(' ')
disp(' ')
disp('Plotting figures...');
disp('-------------------')
plots(combinedStruct, participantDataMapped, firstTimeStamps);


disp(' ')
disp(' ')
disp(' ')
disp('Finishing up calculations and exporting...');
disp('------------------------------------------')

%actual index to see which condition participant belongs to
slideTable.Condition = participantDataMapped.actualIndex;

%moving fixation mapping variables to exporting table
slideTable.FixCount = participantDataMapped.FixationCount;
slideTable.FixDuration = participantDataMapped.Duration;
slideTable.avgFixDuration = participantDataMapped.avgDuration;
slideTable.FixCountVid = participantDataMapped.FixVidCount;
slideTable.FixDurationVid = participantDataMapped.FixVidDuration;
slideTable.avgFixDurationVid = participantDataMapped.avgFixVidDuration;
slideTable.FixCountOut = participantDataMapped.FixOutCount;
slideTable.FixDurationOut = participantDataMapped.FixOutDuration;
slideTable.avgFixDurationOut = participantDataMapped.avgFixOutDuration;
slideTable.FixCountLeft = participantDataMapped.leftCount;
slideTable.FixDurationLeft = participantDataMapped.leftDuration;
slideTable.avgDurationLeft = participantDataMapped.avgleftDuration;
slideTable.FixCountRight = participantDataMapped.rightCount;
slideTable.FixDurationRight = participantDataMapped.rightDuration;
slideTable.avgDurationRight = participantDataMapped.avgrightDuration;
slideTable.FixCountFace = participantDataMapped.faceCount;
slideTable.FixDurationFace = participantDataMapped.faceDuration;
slideTable.avgFixDurationFace = participantDataMapped.avgfaceDuration;
slideTable.FixCountNotface = participantDataMapped.notfaceCount;
slideTable.FixDurationNotFace = participantDataMapped.notfaceDuration;
slideTable.avgFixDurationNotface = participantDataMapped.avgnotfaceDuration;

%moving pupil dilation mapping variables to exporting table
slideTable.Baseline = calculatedDilation.Baseline;
slideTable.avgPupVid = calculatedDilation.avgVideo;
slideTable.avgPCPD = calculatedDilation.avgChange;

% Initialize an empty table
fixationTable = table();

% Loop through each participant
for participant = 1:length(combinedStruct)
    % Create a table for the current participant
    participantTable = table(combinedStruct(participant).start(:), ...
                             combinedStruct(participant).end(:), ...
                             combinedStruct(participant).medX(:), ...
                             combinedStruct(participant).medY(:), ...
                             'VariableNames', {'start', 'end', 'medX', 'medY'});
    
    % Append the participant table to the main table
    fixationTable = [fixationTable; participantTable];
end

% Export the table to Excel
writetable(fixationTable, 'fixation_data.xlsx');

%export table to excel file
writetable(slideTable, 'SlideAnalysis.xlsx');


