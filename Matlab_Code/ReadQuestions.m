function [slideQuestionsres] = ReadQuestions(ePrimeQuestions)
% -------------------------------------------------------------------------
% Author: [Daniël Ris]
%
% Extracts question answer values
%
% Inputs:
%   - ePrimeQuestions: Filepath to the ePrime question data file (.txt).
% -------------------------------------------------------------------------
    % Check if the ePrime file exists
    if ~exist(ePrimeQuestions, 'file')
        error('File does not exist: %s', ePrimeQuestions);
    end

    % Open the ePrime file
    fid = fopen(ePrimeQuestions, 'r');

    % Check if the file was opened successfully
    if fid == -1
        error('Could not open the file: %s', ePrimeQuestions);
    end

    % Read the ePrime text file into a table
    slideQuestions = readtable(ePrimeQuestions, 'Delimiter', '\t', VariableNamingRule='preserve');

    % Get the current column names
    currentColumnNames = slideQuestions.Properties.VariableNames;

    % Replace dots with underscores
    newColumnNames = cellfun(@(x) strrep(x, '.', '_'), currentColumnNames, 'UniformOutput', false);

    % Update the column names in the table
    slideQuestions.Properties.VariableNames = newColumnNames;

    slideQuestionsres = table();

    % Initialize the result table
    slideQuestionsres = table();

    % Battery ID1
    slideQuestionsres.ID1_1 = slideQuestions{1, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.ID1_2 = slideQuestions{1, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.ID1_3 = slideQuestions{1, 'InterSlides_S3Q3_Value'};
    slideQuestionsres.ID1_4 = slideQuestions{2, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.ID1_5 = slideQuestions{2, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.ID1_6 = slideQuestions{2, 'InterSlides_S3Q3_Value'};

    % Battery IM
    slideQuestionsres.IM_1 = slideQuestions{3, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.IM_2 = slideQuestions{3, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.IM_3 = slideQuestions{4, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.IM_4 = slideQuestions{4, 'InterSlides_S3Q2_Value'};

    % Battery IL1
    slideQuestionsres.IL1_1 = slideQuestions{5, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.IL1_2 = slideQuestions{5, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.IL1_3 = slideQuestions{5, 'InterSlides_S3Q3_Value'};
    slideQuestionsres.IL1_4 = slideQuestions{6, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.IL1_5 = slideQuestions{6, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.IL1_6 = slideQuestions{6, 'InterSlides_S3Q3_Value'};
    slideQuestionsres.IL1_7 = slideQuestions{7, 'InterSlides_S3Q1_Value'};
    slideQuestionsres.IL1_8 = slideQuestions{7, 'InterSlides_S3Q2_Value'};
    slideQuestionsres.IL1_9 = slideQuestions{7, 'InterSlides_S3Q3_Value'};
    
    % Battery C1
    slideQuestionsres.C1_1 = slideQuestions{8, 'MCslides_S3Q1_Value'};
    slideQuestionsres.C1_2 = slideQuestions{8, 'MCslides_S3Q2_Value'};
    slideQuestionsres.C1_3 = slideQuestions{8, 'MCslides_S3Q3_Value'};
    
    % Battery D1
    slideQuestionsres.D1_1 = slideQuestions{9, 'MCslides_S3Q1_Value'};
    slideQuestionsres.D1_2 = slideQuestions{9, 'MCslides_S3Q2_Value'};
    slideQuestionsres.D1_3 = slideQuestions{9, 'MCslides_S3Q3_Value'};
    slideQuestionsres.D1_4 = slideQuestions{10, 'MCslides_S3Q1_Value'};
    slideQuestionsres.D1_5 = slideQuestions{10, 'MCslides_S3Q2_Value'};
    slideQuestionsres.D1_6 = slideQuestions{10, 'MCslides_S3Q3_Value'};
    
    % Battery E1
    slideQuestionsres.E1_1 = slideQuestions{11, 'MCslides_S3Q1_Value'};
    
    % Battery E2
    slideQuestionsres.E2_1 = slideQuestions{12, 'MCslides_S3Q1_Value'};
    slideQuestionsres.E2_2 = slideQuestions{12, 'MCslides_S3Q2_Value'};
    slideQuestionsres.E2_3 = slideQuestions{12, 'MCslides_S3Q3_Value'};
    slideQuestionsres.E2_4 = slideQuestions{12, 'MCslides_Slider1_Value'};
    slideQuestionsres.E2_5 = slideQuestions{13, 'MCslides_S3Q1_Value'};
    slideQuestionsres.E2_6 = slideQuestions{13, 'MCslides_S3Q2_Value'};
    slideQuestionsres.E2_7 = slideQuestions{13, 'MCslides_S3Q3_Value'};
    
    % Battery F1
    slideQuestionsres.F1_1 = slideQuestions{14, 'MCslides_S3Q1_Value'};
    slideQuestionsres.F1_2 = slideQuestions{14, 'MCslides_S3Q2_Value'};
    slideQuestionsres.F1_3 = slideQuestions{14, 'MCslides_S3Q3_Value'};
    slideQuestionsres.F1_4 = slideQuestions{15, 'MCslides_S3Q1_Value'};
    slideQuestionsres.F1_5 = slideQuestions{15, 'MCslides_S3Q2_Value'};
    slideQuestionsres.F1_6 = slideQuestions{15, 'MCslides_S3Q3_Value'};
    
    % Battery G
    slideQuestionsres.G_1 = slideQuestions{16, 'MCslides_S3Q1_Value'};
    slideQuestionsres.G_2 = slideQuestions{16, 'MCslides_S3Q2_Value'};
    
    % Battery H
    slideQuestionsres.H_1 = slideQuestions{17, 'MCslides_S3Q1_Value'};
    slideQuestionsres.H_2 = slideQuestions{17, 'MCslides_S3Q2_Value'};
    slideQuestionsres.H_3 = slideQuestions{18, 'MCslides_S3Q1_Value'};
    
    % Battery I1
    slideQuestionsres.I1_1 = slideQuestions{19, 'MCslides_S3Q1_Value'};
    slideQuestionsres.I1_2 = slideQuestions{19, 'MCslides_S3Q2_Value'};
    slideQuestionsres.I1_3 = slideQuestions{19, 'MCslides_S3Q3_Value'};
    
    % Battery I2
    slideQuestionsres.I2_1 = slideQuestions{20, 'MCslides_S3Q1_Value'};
    slideQuestionsres.I2_2 = slideQuestions{20, 'MCslides_S3Q2_Value'};
    slideQuestionsres.I2_3 = slideQuestions{20, 'MCslides_S3Q3_Value'};
    
    % Battery J1
    slideQuestionsres.J1_1 = slideQuestions{21, 'MCslides_S3Q1_Value'};
    slideQuestionsres.J1_2 = slideQuestions{21, 'MCslides_S3Q2_Value'};
    slideQuestionsres.J1_3 = slideQuestions{21, 'MCslides_S3Q3_Value'};
    slideQuestionsres.J1_4 = slideQuestions{21, 'MCslides_Slider1_Value'};
    
    % Battery K
    slideQuestionsres.K_1 = slideQuestions{22, 'MCslides_S3Q1_Value'};
    slideQuestionsres.K_2 = slideQuestions{22, 'MCslides_S3Q2_Value'};
    
    % Battery L1
    slideQuestionsres.L1_1 = slideQuestions{23, 'MCslides_S3Q1_Value'};
    slideQuestionsres.L1_2 = slideQuestions{23, 'MCslides_S3Q2_Value'};
    slideQuestionsres.L1_3 = slideQuestions{23, 'MCslides_S3Q3_Value'};
    slideQuestionsres.L1_4 = slideQuestions{24, 'MCslides_S3Q1_Value'};
    slideQuestionsres.L1_5 = slideQuestions{24, 'MCslides_S3Q2_Value'};
    slideQuestionsres.L1_6 = slideQuestions{24, 'MCslides_S3Q3_Value'};
    slideQuestionsres.L1_7 = slideQuestions{25, 'MCslides_S3Q1_Value'};
    slideQuestionsres.L1_8 = slideQuestions{25, 'MCslides_S3Q2_Value'};
    slideQuestionsres.L1_9 = slideQuestions{25, 'MCslides_S3Q3_Value'};
    
    % Battery M
    slideQuestionsres.M_1 = slideQuestions{26, 'MCslides_S3Q1_Value'};
    slideQuestionsres.M_2 = slideQuestions{26, 'MCslides_S3Q2_Value'};
    slideQuestionsres.M_3 = slideQuestions{27, 'MCslides_S3Q1_Value'};
    slideQuestionsres.M_4 = slideQuestions{27, 'MCslides_S3Q2_Value'};
    
    % Battery N
    slideQuestionsres.N_1 = slideQuestions{28, 'MCslides_S3Q1_Value'};
    slideQuestionsres.N_2 = slideQuestions{28, 'MCslides_S3Q2_Value'};
    slideQuestionsres.N_3 = slideQuestions{29, 'MCslides_S3Q1_Value'};
    slideQuestionsres.N_4 = slideQuestions{29, 'MCslides_S3Q2_Value'};
    
    % Battery R
    slideQuestionsres.R_1 = slideQuestions{36, 'Multislide_S3Q1_Value'};
    slideQuestionsres.R_2 = slideQuestions{36, 'Multislide_S3Q2_Value'};
    
    % Battery S1
    slideQuestionsres.S1 = slideQuestions{37, 'Multislide_Choice1_Value'};
    
    % Battery S2
    slideQuestionsres.S2 = slideQuestions{38, 'Multislide_Choice1_Value'};
    
    % Battery S3
    slideQuestionsres.S3 = slideQuestions{39, 'Multislide_Choice1_Value'};
    
    % Battery T1
    slideQuestionsres.T1 = slideQuestions{40, 'Multislide_Choice1_Value'};
    
    % Battery T2
    slideQuestionsres.T2 = slideQuestions{41, 'Multislide_Choice1_Value'};
    
    % Battery T3
    slideQuestionsres.T3 = slideQuestions{42, 'Multislide_Choice1_Value'};
    
    % Battery U1
    slideQuestionsres.U1 = slideQuestions{43, 'Multislide_Choice1_Value'};
    
    % Battery V1
    slideQuestionsres.V1 = slideQuestions{44, 'Multislide_Choice1_Value'};
    
    % Battery V2
    slideQuestionsres.V2 = slideQuestions{45, 'Multislide_Choice1_Value'};
    
    % Battery V3
    slideQuestionsres.V3 = slideQuestions{46, 'Multislide_Choice1_Value'};
    
    % Battery W
    slideQuestionsres.W_1 = slideQuestions{47, 'Multislide_S3Q1_Value'};
    slideQuestionsres.W_2 = slideQuestions{47, 'Multislide_S3Q2_Value'};
    slideQuestionsres.W_3 = slideQuestions{48, 'Multislide_S3Q1_Value'};
    
    % Battery X1
    slideQuestionsres.X1 = slideQuestions{49, 'Multislide_Choice1_Value'};
    
    % Battery Y1
    slideQuestionsres.Y1 = slideQuestions{50, 'Multislide_Choice1_Value'};
    
    % Battery AA1
    slideQuestionsres.AA1 = slideQuestions{51, 'Multislide_Choice1_Value'};
    
    % Battery AB
    slideQuestionsres.AB_1 = slideQuestions{52, 'Multislide_S3Q1_Value'};
    slideQuestionsres.AB_2 = slideQuestions{52, 'Multislide_S3Q2_Value'};

    %amount of MC questions answered correctly
    MC_corr = 0;
    corrlist = [4, 2, 2, 5, 4, 5, 2, 4, 4, 3, 2];
    for i = 79:88
        index = i-78;
        if i < 83
            if slideQuestionsres{1, i} == corrlist(index)
                MC_corr = MC_corr + 1;
            end
        elseif i > 83
            if slideQuestionsres{1, i} == corrlist(index+1)
                MC_corr = MC_corr + 1;
            end
        else
            if slideQuestionsres{1, 83} == corrlist(index) || slideQuestionsres{1, 83} == corrlist(index+1)
                MC_corr = MC_corr + 1;
            end
        end
    end
    slideQuestionsres.MC_corr = MC_corr;
   

    % Close the ePrime file
    fclose(fid);

