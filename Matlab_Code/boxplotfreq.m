% Assuming participantTable is your table
% and MC_corr is the variable indicating correct answers

% Create a histogram to visualize the frequency of correct answers
% figure;
% histogram(slideTable.MC_corr, 'BinMethod', 'integers', 'Normalization', 'probability');
% title('Frequency of Correct Answers');
% xlabel('Number of Correct Answers');
% ylabel('Frequency');

% Create a histogram to visualize the count of participants for each correct answer
figure;
histogram(slideTable.MC_corr, 'BinMethod', 'integers', 'DisplayStyle', 'bar', 'EdgeColor', 'w');
title('Count of Participants for Each Correct Answer');
xlabel('Number of Correct Answers');
ylabel('Number of Participants');

% Create a boxplot for the distribution of correct answers
figure;
boxplot(slideTable.MC_corr, 'Labels', {}, 'Symbol', 'o', 'Whisker', 1.5, 'Widths', 0.6)
title('Boxplot of Correct Answers');
ylabel('Number of Correct Answers');

% Optionally, you can customize the x-axis labels with participant names
% xticklabels(participantTable.ParticipantID); % Commented out to remove x-labels

% Optionally, you can rotate the x-axis labels for better readability
% xtickangle(45);

% Adjust the figure size
figureWidth = 5; % Adjust the width of the figure as needed
figureHeight = 5; % Adjust the height of the figure as needed
set(gcf, 'Units', 'inches', 'Position', [0, 0, figureWidth, figureHeight]);

