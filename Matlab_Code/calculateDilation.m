function [calculatedDilation] = calculateDilation(participantDataMapped, combinedPupil)
    numParticipants = height(participantDataMapped);
    calculatedDilation = participantDataMapped(:, {'actualIndex', 'DilationMapping'});
    calculatedDilation.Baseline = cell(size(calculatedDilation, 1), 1);
    calculatedDilation.avgVideo = cell(size(calculatedDilation, 1), 1);
    calculatedDilation.avgChange = cell(size(calculatedDilation, 1), 1);
    for i = 1:numParticipants
        pupilArray = combinedPupil.CellArrays{i};
        pupilMapping = participantDataMapped.DilationMapping{i};
        dilationSum = 0;
        dilationSumVideo = 0;
        n_starting = 0;
        n_video = 0;
        for j = 1:size(pupilArray, 1)
            if strcmp(pupilMapping{1, j}, 'Outside')
                n_starting = n_starting + 1;
                dilationSum = dilationSum + ((pupilArray{j, 2} + pupilArray{j, 3})/2);
            elseif strcmp(pupilMapping{1, j}, 'Starting')
                n_starting = n_starting + 1;
                dilationSum = dilationSum + ((pupilArray{j, 2} + pupilArray{j, 3})/2);
            else
                n_video = n_video + 1;
                dilationSumVideo = dilationSumVideo + ((pupilArray{j, 2} + pupilArray{j, 3})/2);
            end
        end
        calculatedDilation.Baseline{i} = dilationSum/n_starting;
        calculatedDilation.avgVideo{i} = dilationSumVideo/n_video;
        calculatedDilation.avgChange{i} = ((calculatedDilation.avgVideo{i}-calculatedDilation.Baseline{i})/calculatedDilation.Baseline{i})*100;
        fprintf('Participant %d dilation change calculated\n', i);
    end
end