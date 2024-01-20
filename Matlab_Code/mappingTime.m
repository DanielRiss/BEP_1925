function participantData = mappingTime(participantData, combinedStruct, actualFirstTime, firstTimeStamps, pupilDilation)
% -------------------------------------------------------------------------
%  Author(s): Daniël Ris
%  MAPPINGTIME Maps fixations to instructions based on fixation times.
%   participantData = mappingTime(participantData, fixationArrays)
%
%   This function takes participant data and fixation arrays and maps
%   fixations to specific instructions based on fixation start and end times.
%
%   Input:
%   - participantData: Table containing participant information, including
%                      session times and instruction time ranges.
%   - fixationArrays: Cell array containing fixation arrays for each participant.
%
%   Output:
%   - participantData: Updated participantData table with FixationMapping.
% -------------------------------------------------------------------------

    % Get the number of participants
    numParticipants = height(participantData);

    % Initialize FixationMapping cell arrays for each participant
    participantData.FixationMapping = cell(numParticipants, 1); %fixation mapping (instruction 1, instruction 2, or outside)
    participantData.DilationMapping = cell(numParticipants, 1); %dilation mapping (starting, video, outside)
    participantData.DurationTime = cell(numParticipants, 1);    %durationtime mapping (fixation count & average duration per minute)
    participantData.ScreenMapping = cell(numParticipants, 1);   %screenmapping (left side of screen, or right side of screen)
    participantData.FaceMapping = cell(numParticipants, 1);     %facemapping (outside face area, or on face)
    participantData.FixationCount = cell(numParticipants, 1);   %fixationcount (total fixation count for this participant)
    participantData.Duration = cell(numParticipants, 1);        %duration (total duration of all fixations)
    participantData.avgDuration = cell(numParticipants, 1);     %avgduration (average duration of all fixations)

    %variables for fixations during video
    participantData.FixVidCount = cell(numParticipants, 1);
    participantData.FixVidDuration = cell(numParticipants, 1);
    participantData.avgFixVidDuration = cell(numParticipants, 1);

    %variables for fixations outside video
    participantData.FixOutCount = cell(numParticipants, 1);
    participantData.FixOutDuration = cell(numParticipants, 1);
    participantData.avgFixOutDuration = cell(numParticipants, 1);

    %variables for left side of the screen fixations
    participantData.leftCount = cell(numParticipants, 1);
    participantData.leftDuration = cell(numParticipants, 1);
    participantData.avgleftDuration = cell(numParticipants, 1);

    %variables for right side of the screen fixations
    participantData.rightCount = cell(numParticipants, 1);
    participantData.rightDuration = cell(numParticipants, 1);
    participantData.avgrightDuration = cell(numParticipants, 1);

    %variables for on face and not on face fixations
    participantData.faceCount = cell(numParticipants, 1);
    participantData.notfaceCount = cell(numParticipants, 1);
    participantData.faceDuration = cell(numParticipants, 1);
    participantData.notfaceDuration = cell(numParticipants, 1);
    participantData.avgfaceDuration = cell(numParticipants, 1);
    participantData.avgnotfaceDuration = cell(numParticipants, 1);
    

    % Iterate through each participant
    for participantIndex = 1:numParticipants

        %get fixation array and pupil array for the current participant
        fixationStruct = combinedStruct(participantIndex);
        pupilArray = pupilDilation.CellArrays{participantIndex};

        % Initialize mappings for the current participant
        participantData.FixationMapping{participantIndex} = cell(size(fixationStruct(1).startT, 1), 1);
        participantData.ScreenMapping{participantIndex} = cell(size(fixationStruct(1).startT, 1), 1);
        participantData.FaceMapping{participantIndex} = cell(size(fixationStruct(1).startT, 1), 1);
        participantData.DilatonMapping{participantIndex} = cell(size(pupilArray, 1), 1);

        %initiation of per minute fixation count and average duration (durationtimemapping)
        lastFixation = fixationStruct(1).startT(end, :);                                    %last fixation in array
        numberofMinutes = floor((lastFixation-firstTimeStamps{participantIndex, :})/30000); %number of minutes duration of experiment
        participantData.DurationTime{participantIndex} = cell(numberofMinutes, 2);          %initiate durationtime arrays

        %set initial value to 0 for all counts and durations
        zero_fields = {'FixationCount', 'Duration', 'FixVidCount', 'FixVidDuration', ...
          'FixOutCount', 'FixOutDuration', 'leftCount', 'leftDuration', ...
          'rightCount', 'rightDuration', 'faceCount', 'notfaceCount', ...
          'faceDuration', 'notfaceDuration'};

        for field = zero_fields
            participantData.(field{:}){participantIndex} = 0;
        end
        
        %set initial value to 0 for all values in durationtime per minute
        for i = 1:numberofMinutes
            participantData.DurationTime{participantIndex}{i, 1} = 0;
            participantData.DurationTime{participantIndex}{i, 2} = 0;
        end

        % Iterate through each fixation in the fixation array
        for fixationIndex = 1:size(fixationStruct.startT, 1)

            %total fixation count + 1
            participantData.FixationCount{participantIndex} = participantData.FixationCount{participantIndex} + 1;

            %get fixation start and end times (in ms)
            fixationStartTime = (fixationStruct.startT(fixationIndex) - firstTimeStamps{participantIndex, :});
            fixationEndTime = (fixationStruct.endT(fixationIndex)- firstTimeStamps{participantIndex, :});

            %calculate total fixation duration (ms) 
            participantData.Duration{participantIndex} = participantData.Duration{participantIndex} + ...
                (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;

            %set total duration and fixation count of each minute in the DurationTime variable
            for j = 1:numberofMinutes
                if fixationStartTime >= (j-1)*30000 && fixationEndTime < j*30000
                    participantData.DurationTime{participantIndex}{j, 1} = ...
                        participantData.DurationTime{participantIndex}{j, 1} + 1;
                    participantData.DurationTime{participantIndex}{j, 2} = ...
                        participantData.DurationTime{participantIndex}{j, 2} + ...
                        (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
                end
            end

            %fixation time mappings (instr 1, 2, or outside) 
            % Check if fixation time falls within the time range of Instruction 1
            if fixationStartTime >= participantData.Instruction1_Start(participantIndex) && ...
                fixationEndTime <= participantData.Instruction1_Finish(participantIndex)
                % Map fixation to Instruction 1
                participantData.FixationMapping{participantIndex}{fixationIndex} = 'Instruction1';
                participantData.FixVidCount{participantIndex} = participantData.FixVidCount{participantIndex} + 1;
                participantData.FixVidDuration{participantIndex} = participantData.FixVidDuration{participantIndex} + ...
                    (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
    
            % Check if fixation time falls within the time range of Instruction 2
            elseif fixationStartTime >= participantData.Instruction2_Start(participantIndex) && ...
                fixationEndTime <= participantData.Instruction2_Finish(participantIndex)
                % Map fixation to Instruction 2
                participantData.FixationMapping{participantIndex}{fixationIndex} = 'Instruction2';
                participantData.FixVidCount{participantIndex} = participantData.FixVidCount{participantIndex} + 1;
                participantData.FixVidDuration{participantIndex} = participantData.FixVidDuration{participantIndex} + ...
                    (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
            else
                % Map fixation to 'Outside' if it doesn't match any instruction
                participantData.FixationMapping{participantIndex}{fixationIndex} = 'Outside';
                participantData.FixOutCount{participantIndex} = participantData.FixOutCount{participantIndex} + 1;
                participantData.FixOutDuration{participantIndex} = participantData.FixOutDuration{participantIndex} + ...
                    (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
            end

            %only check if fixation is in video of course
            if strcmp(participantData.FixationMapping{participantIndex}{fixationIndex}, 'Instruction1') || ...
                    strcmp(participantData.FixationMapping{participantIndex}{fixationIndex}, 'Instruction2')
                %set mapping for on face or not face (face box is (630, 250;770, 450))
                if fixationStruct.medX(1, fixationIndex) >= 650 && fixationStruct.medX(1, fixationIndex) <= 890 && ...
                        fixationStruct.medY(1, fixationIndex) >= 220 && fixationStruct.medY(1, fixationIndex) <= 530
                    participantData.FaceMapping{participantIndex}{fixationIndex} = 'Face';
                    participantData.faceCount{participantIndex} = participantData.faceCount{participantIndex} + 1;
                    participantData.faceDuration{participantIndex} = participantData.faceDuration{participantIndex} + ...
                        (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
                elseif fixationStruct.medX(1, fixationIndex) >= 0 && fixationStruct.medX(1, fixationIndex) <= 1024 && ...
                        fixationStruct.medY(1, fixationIndex) >= 180 && fixationStruct.medY(1, fixationIndex) <= 575
                    participantData.FaceMapping{participantIndex}{fixationIndex} = 'notFace';
                    participantData.notfaceCount{participantIndex} = participantData.notfaceCount{participantIndex} + 1;
                    participantData.notfaceDuration{participantIndex} = participantData.notfaceDuration{participantIndex} + ...
                        (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
                else
                    participantData.FaceMapping{participantIndex}{fixationIndex} = 'Out';
                end

                %set mapping for left, right and outside the screen (screen resolution = 1024, 768)
                if fixationStruct.medX(1, fixationIndex) >= 0 && fixationStruct.medX(1, fixationIndex) < 512 && ...
                        fixationStruct.medY(1, fixationIndex) >= 180 && fixationStruct.medY(1, fixationIndex) <= 575
                    participantData.ScreenMapping{participantIndex}{fixationIndex} = 'Left';
                    participantData.leftCount{participantIndex} = participantData.leftCount{participantIndex} + 1;
                    participantData.leftDuration{participantIndex} = participantData.leftDuration{participantIndex} + ...
                        (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
                elseif fixationStruct.medX(1, fixationIndex) > 512 && fixationStruct.medX(1, fixationIndex) <= 1024 && ...
                        fixationStruct.medY(1, fixationIndex) >= 180 && fixationStruct.medY(1, fixationIndex) <= 575
                    participantData.ScreenMapping{participantIndex}{fixationIndex} = 'Right';
                    participantData.rightCount{participantIndex} = participantData.rightCount{participantIndex} + 1;
                    participantData.rightDuration{participantIndex} = participantData.rightDuration{participantIndex} + ...
                        (fixationStruct.endT(fixationIndex) - fixationStruct.startT(fixationIndex))/10;
                else
                    participantData.ScreenMapping{participantIndex}{fixationIndex} = 'Out';
                end
            end
        end

        %iterate through all dilation values in pupil dilation array
        for DilationIndex = 1:size(pupilArray, 1)
            % Check if dilation falls within the time range of Instruction 1
            dilationTime = pupilArray{DilationIndex, 1}*1000; %to miliseconds
            if dilationTime < participantData.Instruction1_Start(participantIndex) 
                participantData.DilationMapping{participantIndex}{DilationIndex} = 'Starting';
            elseif  dilationTime >= participantData.Instruction1_Start(participantIndex) && ...
                    dilationTime < participantData.Instruction1_Finish(participantIndex)
                participantData.DilationMapping{participantIndex}{DilationIndex} = 'Instruction1';
            % Check if dilation falls within the time range of Instruction 2
            elseif dilationTime >= participantData.Instruction2_Start(participantIndex) && ...
                    dilationTime < participantData.Instruction2_Finish(participantIndex)
                participantData.DilationMapping{participantIndex}{DilationIndex} = 'Instruction2';
            else
                participantData.DilationMapping{participantIndex}{DilationIndex} = 'Outside';
            end
        end

        %calculate average fixation duration per minute
        for k = 1:numberofMinutes
            participantData.DurationTime{participantIndex}{k, 2} = ...
            participantData.DurationTime{participantIndex}{k, 2}/participantData.DurationTime{participantIndex}{k, 1};
        end

        %average fixation duration of all fixations
        participantData.avgDuration{participantIndex} = participantData.Duration{participantIndex}/...
            participantData.FixationCount{participantIndex};

        %average fixation duration per time condition (outside or in video)
        participantData.avgFixVidDuration{participantIndex} = participantData.FixVidDuration{participantIndex}/...
            participantData.FixVidCount{participantIndex};
        participantData.avgFixOutDuration{participantIndex} = participantData.FixOutDuration{participantIndex}/...
            participantData.FixOutCount{participantIndex};

        %calculate average fixation duration per condition (left of screen,
        %right of screen, on face, not on face)
        participantData.avgleftDuration{participantIndex} = participantData.leftDuration{participantIndex}/...
            participantData.leftCount{participantIndex};
        participantData.avgrightDuration{participantIndex} = participantData.rightDuration{participantIndex}/...
            participantData.rightCount{participantIndex};
        participantData.avgfaceDuration{participantIndex} = participantData.faceDuration{participantIndex}/...
        participantData.faceCount{participantIndex};
        participantData.avgnotfaceDuration{participantIndex} = participantData.notfaceDuration{participantIndex}/...
            participantData.notfaceCount{participantIndex};

        fprintf('Participant %d data mapped\n', participantData.actualIndex(participantIndex, 1));
    end
end
