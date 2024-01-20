function plots(combinedStruct, participantDataMapped, firstTimeStamps)
% -------------------------------------------------------------------------
% Author: [Daniël Ris]
%
% Plots 3D fixations, Fixation Positions (weak vs strong), and heatmaps.
%
% Inputs:
%   - fixationArrays: Cell array containing fixation data for each participant.
%   - participantDataMapped: Table containing mapped participant data.
% -------------------------------------------------------------------------

    % Number of participants
    numParticipants = height(participantDataMapped);

    % Plot 3D Fixations
    plot3DFixations(combinedStruct, participantDataMapped, numParticipants, firstTimeStamps);

    % Plot Participants
    plotParticipants(combinedStruct, participantDataMapped, numParticipants);
    % 
    % Plot Condition Scatterplots
    % plotConditionScatterplots(combinedStruct, participantDataMapped, numParticipants);
    % 
    % Plot Condition Heatmaps
    plotConditionHeatmaps(combinedStruct, participantDataMapped, numParticipants);

    plotParticipantHist(participantDataMapped);

    plotMinuteData(participantDataMapped);
end

%% ---------------------------------------------- Plotting Fixations in 3D Scatterplot ---------------------------------------------- 
function plot3DFixations(combinedStruct, participantDataMapped, numParticipants, firstTimeStamps)
    % Preallocate arrays to store fixation data
    allFixations = zeros(0, 3);  % [Time (ms), X Value, Y Value]
    allCategories = cell(0, 1);
    allColors = zeros(0, 3);

    % Define colors for each category as RGB values
    categoryColors = containers.Map({'Instruction1', 'Instruction2', 'Outside'}, ...
        {[0.7372549019607844, 0.3137254901960784, 0.5647058823529412], ...
        [1, 0.6509803921568628, 0], [0, 0.24705882352941178, 0.3607843137254902]});

    % Iterate through each participant
    for participantIndex = 1:numParticipants

        % Get fixation array for the current participant
        fixationArray = combinedStruct(participantIndex);

        % Get FixationMapping for the current participant
        currentFixationMapping = participantDataMapped.FixationMapping{participantIndex};

        % Extract relevant data for valid fixations
        fixationTimes = fixationArray.startT - firstTimeStamps{participantIndex, :};
        fixationXValues = fixationArray.medX';
        fixationYValues = fixationArray.medY';  % Use Y values for the z-axis

        categories = currentFixationMapping;

        actualIndex = participantDataMapped.actualIndex(participantIndex);

        % Adjust color based on the actual index being odd or even
        if mod(actualIndex, 2) == 1  % Odd actualIndex
            colors = cellfun(@(cat) categoryColors(cat) * 0.7, categories, 'UniformOutput', false);
        else  % Even actualIndex
            colors = cellfun(@(cat) categoryColors(cat), categories, 'UniformOutput', false);
        end

        % Concatenate data to the overall arrays
        allFixations = [allFixations; fixationTimes, fixationXValues, fixationYValues];
        allCategories = [allCategories; categories];

        allColors = [allColors; cell2mat(colors)];
    end

    % Plot all fixations at once using scatter3 for a 3D scatter plot
    figure;
    scatter3(allFixations(:, 1), allFixations(:, 2), allFixations(:, 3), 18, allColors, 'filled', 'Marker', 'o');
    xlabel('Time (ms from start of experiment)');
    ylabel('X Value');
    zlabel('Y Value');
    title('Fixations Over Time (3D)');

    % Set specific boundaries for the axes
    xlim([0, 2.5e6]);   % Time axis
    ylim([-80, 1104]);     % X axis
    zlim([-80, 848]);      % Y axis

    % Add a transparent plane cutting through the middle of the y-axis
    yPlane = [512, 512, 512, 512];
    xPlane = [0, 2.5e6, 2.5e6, 0];
    zPlane = [-80, -80, 848, 848];
    patch(xPlane, yPlane, zPlane, 'k', 'FaceAlpha', 0.3); % 'k' for black color

    % Improve plot aesthetics
    grid on;
    grid minor;
end

%% ---------------------------------------------- Plotting Fixation Locations in Scatterplot ---------------------------------------------- 
function plotParticipants(combinedStruct, participantDataMapped, numParticipants)
    % Iterate through each participant
    figure;
    for participantIndex = 1:numParticipants
        % Get fixation array for the current participant
        fixationArray = combinedStruct(participantIndex);

        % Get the actual index for the current participant
        actualIndex = participantDataMapped.actualIndex(participantIndex);

        % Determine color based on whether actualIndex is odd or even
        if mod(actualIndex, 2) == 1  % Odd actualIndex (Weak condition)
            participantColor = [1, 0.7607843137254902, 0.0392156862745098];  % Yellow
        else  % Even actualIndex (Strong condition)
            participantColor = [0.047058823529411764, 0.4823529411764706, 0.8627450980392157];  % Blue
        end

        % Plot fixations for each participant without markers
        scatter(fixationArray.medX, fixationArray.medY, 18, participantColor, "filled");
        hold on;
    end

    xLine = [512, 512];
    yLine = [-80, 848];
    line(xLine, yLine, 'Color', 'k', 'LineStyle', '--');

    % Plot legend with blue dot for "Weak" and red dot for "Strong"
    legend([scatter(0, 0, 50, [1, 0.7607843137254902, 0.0392156862745098], 'filled', 'DisplayName', 'Weak'), ...
            scatter(0, 0, 50, [0.047058823529411764, 0.4823529411764706, 0.8627450980392157], 'filled', 'DisplayName', 'Strong')], ...
            'Location', 'best');

    xlim([-80, 1104]);   % Time axis
    ylim([-80, 848]);     % X axis

    % Add labels and title
    xlabel('X Value');
    ylabel('Y Value');
    title('Fixations by Condition (Weak: Blue, Strong: Red)');
    hold off;
end


%% ---------------------------------------------- Plotting Condition Scatterplots ---------------------------------------------- 
function plotConditionScatterplots(combinedStruct, participantDataMapped, numParticipants)
    % Plot Weak Condition
    figure;
    plotConditionScatter(combinedStruct, participantDataMapped, numParticipants, 'Weak');
    title('All Participants - Weak Condition');

    % Plot Strong Condition
    figure;
    plotConditionScatter(combinedStruct, participantDataMapped, numParticipants, 'Strong');
    title('All Participants - Strong Condition');
end

% function plotConditionScatter(combinedStruct, participantDataMapped, numParticipants, condition)
%     % Hardcoded colors for video one (red) and video two (blue)
%     video1Color = [1, 0, 0]; % Red
%     video2Color = [0, 0, 1]; % Blue
% 
%     % Concatenate fixation data for all participants in the specified condition
%     allFixations = [];
%     allColors = [];
% 
%     % Iterate through each participant
%     for participantIndex = 1:numParticipants
%         % Get fixation array for the current participant
%         fixationArray = fixationArrays{participantIndex};
% 
%         % Get the actual index for the current participant
%         actualIndex = participantDataMapped.actualIndex(participantIndex);
% 
%         % Get the fixation mapping for the current participant
%         currentFixationMapping = participantDataMapped.FixationMapping{participantIndex};
% 
%         % Check if the condition matches the actual index (Weak or Strong)
%         if (mod(actualIndex, 2) == 1 && strcmp(condition, 'Weak')) || ...
%            (mod(actualIndex, 2) == 0 && strcmp(condition, 'Strong'))
% 
%             % Identify valid indices where FixationMapping is not empty
%             validIndices = ~cellfun(@isempty, currentFixationMapping);
% 
%             % Determine color based on video (Video1 or Video2)
%             if strcmp(condition, 'Weak')
%                 colors = repmat(video1Color, sum(validIndices), 1);
%             else
%                 colors = repmat(video2Color, sum(validIndices), 1);
%             end
% 
%             % Concatenate data for all participants
%             allFixations = [allFixations; fixationArray(validIndices, 1:2)];
%             allColors = [allColors; colors];
%         end
%     end
% 
%     % Plot fixations for all participants in the specified condition
%     scatter(allFixations(:, 1), allFixations(:, 2), 18, allColors, 'filled');
%     xlim([-80, 1104]);   % Time axis
%     ylim([-80, 848]);     % X axis
%     xLine = [512, 512];
%     yLine = [-80, 848];
%     line(xLine, yLine, 'Color', 'k', 'LineStyle', '--');
%     xlabel('X Value');
%     ylabel('Y Value');
%     title(['All Participants - ', condition, ' Condition']);
% 
% end

%% ---------------------------------------------- Plotting Condition Heatmaps ----------------------------------------------
function plotConditionHeatmaps(combinedStruct, participantDataMapped, numParticipants)
    % Initialize arrays to store x and y values for weak and strong conditions
    weakFixations = table('Size', [0, 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'x', 'y'});
    strongFixations = table('Size', [0, 2], 'VariableTypes', {'double', 'double'}, 'VariableNames', {'x', 'y'});

    % Loop through participants and fixations
    for i = 1:size(participantDataMapped, 1)
        % Check if participant is in the weak or strong condition
        isWeakCondition = mod(participantDataMapped.actualIndex(i), 2) == 1;

        % Loop through fixations
        for j = 1:size(combinedStruct(i).startT, 1)
            if strcmp(participantDataMapped.FixationMapping{i}{j, 1}, 'Instruction1') || ...
                    strcmp(participantDataMapped.FixationMapping{i}{j, 1}, 'Instruction2')
                % Extract x and y values
           
                currentFixation = table(combinedStruct(i).medX(j)', combinedStruct(i).medY(j)', 'VariableNames', {'x', 'y'});

                % Concatenate to the appropriate table based on condition
                if isWeakCondition
                    weakFixations = [weakFixations; currentFixation];
                else
                    strongFixations = [strongFixations; currentFixation];
                end
            end
        end
    end

    % Extract numerical matrices from tables
    weakFixationsMatrix = table2array(weakFixations);
    strongFixationsMatrix = table2array(strongFixations);

    % Extract x and y columns for both conditions
    xDataWeak = weakFixationsMatrix(:, 1);
    yDataWeak = weakFixationsMatrix(:, 2);

    xDataStrong = strongFixationsMatrix(:, 1);
    yDataStrong = strongFixationsMatrix(:, 2);


    % Set the common minimum and maximum values for x and y
    minX = 0; % Replace with your desired minimum x-value
    maxX = 1024; % Replace with your desired maximum x-value
    minY = 0;  % Replace with your desired minimum y-value
    maxY = 768;  % Replace with your desired maximum y-value

    % Set the number of bins for x and y
    numBinsX = 125; % Adjust as needed
    numBinsY = 125; % Adjust as needed

    % Specify bin edges for x and y
    xEdges = linspace(minX, maxX, numBinsX + 1);
    yEdges = linspace(minY, maxY, numBinsY + 1);

    % Create 2D histograms for both conditions with the same color limits
    hConditionWeak = histcounts2(xDataWeak, yDataWeak, xEdges, yEdges);
    hConditionStrong = histcounts2(xDataStrong, yDataStrong, xEdges, yEdges);

    % Determine the common color limits for both heatmaps
    commonColorLimits = [0, max([max(hConditionWeak(:)), max(hConditionStrong(:))])];

    % Display the heatmaps side by side
    figure;

    % Heatmap for weak condition
    subplot(2, 1, 1);
    imagesc(xEdges, yEdges, hConditionWeak');
    colormap("hot"); % Change the colormap if needed
    colorbar;
    title('Fixation Heatmap - Weak');
    xlabel('X-axis');
    ylabel('Y-axis');
    caxis(commonColorLimits); % Set common color limits

    set(gca, 'YDir', 'normal');

    % Heatmap for strong condition
    subplot(2, 1, 2);
    imagesc(xEdges, yEdges, hConditionStrong');
    colormap("hot"); % Change the colormap if needed
    colorbar;
    title('Fixation Heatmap - Strong');
    xlabel('X-axis');
    ylabel('Y-axis');
    caxis(commonColorLimits); % Set common color limits

    set(gca, 'YDir', 'normal');
end

function plotParticipantHist(participantDataMapped)
    % Extract unique participant indexes
    participants = unique(participantDataMapped.actualIndex);

    % Initialize an array to store the number of fixations for each participant
    fixationsCount = zeros(size(participants));

    % Calculate the number of fixations for each participant
    k = 1;
    for i = 1:height(participants)
        participantIndex = participants(i);
        fixationsCount(i) = height(participantDataMapped.FixationMapping{k});
        k = k+1;
    end

    % Create a bar chart
    figure;
    bar(1, fixationsCount);
    xlabel('Participant Index');
    ylabel('Number of Fixations');
    title('Fixations per Participant');

    % Optionally, add participant labels to the x-axis
    xticks(participants);


    % Show the plot
    grid on;
end

function plotMinuteData(participantDataMapped)
    % Get the number of participants
    numParticipants = size(participantDataMapped, 1);

    % Set up a figure
    figure;

    % Iterate through each participant
    for participantIndex = 1:numParticipants
        % Extract the DurationTime array for the current participant
        durationTimeArray = participantDataMapped.DurationTime{participantIndex};
    
        % Extract the fixation durations (second column)
        fixationDurations = cell2mat(durationTimeArray(:, 2));
    
        % Plot the data for the current participant with a unique color and 'o' marker
        scatter(1:numel(fixationDurations), fixationDurations, 'DisplayName', sprintf('Participant %d', participantIndex), 'Marker', 'o');
    
        hold on; % Keep the current plot for overlaying
    end

    % Add labels, legend, and set y-axis limits
    xlabel('Minutes');
    ylabel('Average Fixation Duration (seconds)');
    title('Fixation Duration Over Time for Each Participant');
    legend('Location', 'best');

    % Set y-axis limits to [0, 500]
    ylim([0, 500]);

    % Show the grid
    grid on;

end
