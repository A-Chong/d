%% Loads VOW_norm.mat from d/tables/ . and determines outliers. 
% Creates is_outlier column with 0 for good data points and 1 for outliers. 
% Prints out summary of % of outliers by instance, with total of data and
% amount on data that is outliers.
%	
% -	Outlier exclusion criteria: 
%              Tokens where the F1 or F2 was more than three standard 
%               deviations away from the mean. This was based on the group 
%               mean for each formant for each word. In disyllabic words, 
%               the procedure was applied based on the syllable to which 
%               the vowel belonged.


%%
function[VOW] = outliers(VOW)

warning('off','all');

    
    %% Syllable division
    VOW.syll = ones(height(VOW),1);
    
    next_syll = 1;  % counter for syllable number
    for i = 1:height(VOW);
        if VOW.phn_id(i) == 1961;
            line_for_debugging = true;
        end;
        if ismember(VOW.word{i}, ...
            {'sbot' 'hicep' 'kvee' 'yvee' 'unfilled' 'triangle' 'circle'});
            if next_syll == 1;
                % Check that the next phone is actually the same word.
                % Update next_syll for the next phone to be marked 2
                if strcmp(VOW.word{i+1},VOW.word{i});
                    next_syll = 2;
                % If the next phone is a different word, this could be a 
                % case of pronounced /sbaot/ not /ehsbaot/ or /kviy/  not
                % /kihviy/.
                % Simply mark current phone as syllable 2, do not update
                % next_syll.
                elseif ismember(VOW.word{i},{'sbot','kvee'}); 
                    VOW.syll(i) = 2;
                % If next word is different and current is not kvee or sbot
                % this could be a shortened vowel that FAVE didn't read.
                % Mark current syllable as 9999, do not update next_syll.
                else;
                    VOW.syll(i) = 9999;
                end;
            else
                VOW.syll(i) = 2;
                next_syll = 1;
            end;
        end;
    end;
    
    % Fixing those flagged for the other syllable missing
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'triangle')& strcmp(VOW.PHN,'AY')) = 1;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'triangle')& strcmp(VOW.PHN,'AH')) = 2;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'unfilled')& strcmp(VOW.PHN,'AH')) = 1;    
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'unfilled')& strcmp(VOW.PHN,'IH')) = 2;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'circle')& strcmp(VOW.PHN,'ER')) = 1;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'circle')& strcmp(VOW.PHN,'AH')) = 2;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'hicep')& strcmp(VOW.PHN,'AY')) = 1;
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'hicep')& strcmp(VOW.PHN,'IH')) = 1;    
    VOW.syll(VOW.syll == 9999 & ...
        strcmp(VOW.word,'hicep')& strcmp(VOW.PHN,'EH')) = 2;
    
    x = VOW(VOW.syll == 9999,:);
    if height(x) > 0; display('CHECK SYLL 9999'); end;
    
    %% Outlier exclusion
    
    % -	Outlier exclusion criteria: 
%              Tokens where the F1 or F2 was more than three standard 
%               deviations away from the mean. This was based on the group 
%               mean for each formant for each word. In disyllabic words, 
%               the procedure was applied based on the syllable to which 
%               the vowel belonged.
    
    VOW.is_outlier = zeros(height(VOW),1);
    
    % Track total outliers
    outlier_counter = 0;       relevant_vow_counter = 0;
    
    % Using only location, shape, color, texture, horizontal, vertical,size
    words = {'big' 'blue' 'cad' 'cat' 'circle' 'down' 'filled' 'green' ...
        'hicep' 'kvee' 'large' 'left' 'little' 'qeed' 'qeet' 'red' 'right'...
        'sbot' 'small' 'star' 'triangle' 'unfilled' 'up' 'yvee'};
    
    % Loop over each word
    for w=1:length(words);
        w_tab = VOW(strcmp(VOW.word, words{w}) & VOW.syll~=9999,:);
        
        % Loop over each syllable -- or just one if monosyllabic
        for s=1:max(w_tab.syll);
            s_tab = w_tab(w_tab.syll == s,:);
            
            % Get mean F1, mean F2
            mF1 = mean(s_tab.norm_F1);
            mF2 = mean(s_tab.norm_F2);
            
            % Get std F1, std F2
            sF1 = std(s_tab.norm_F1);
            sF2 = std(s_tab.norm_F2);
            
            % Get upper and lower limits for F1 and F2: mean +/- 3*std
            upperF1 = mF1 + 3 * sF1;
            lowerF1 = mF1 - 3 * sF1;
            upperF2 = mF2 + 3 * sF2;
            lowerF2 = mF2 - 3 * sF2;
            
            % Get phn_id of those phones in s_tab that are outliers
            outs = (s_tab.norm_F1 > upperF1) | (s_tab.norm_F1 < lowerF1) ...
                | (s_tab.norm_F2 > upperF2) | (s_tab.norm_F2 < lowerF2);
            
            phid_outliers = s_tab.phn_id(outs);
            
            % Assign value outlier based on phn_id in VOW
            VOW.is_outlier(ismember(VOW.phn_id,phid_outliers)) = 1;
            
            total = height(s_tab);
            outls = sum(outs);
            perc_outlier = num2str(round(outls/total,3));
            display(['    ' words{w} '  syll: ' num2str(s) ...
                '   Total: ' num2str(total) '  Outliers: ' num2str(outls)...
                '   % outlier: '  perc_outlier]);

            outlier_counter = outlier_counter+outls;
            relevant_vow_counter = relevant_vow_counter + total;
        end;        
    end;
    
    % Display total data statement of outliers
    perc_outliers = round(outlier_counter/relevant_vow_counter,2);
    display(['Total relevant vowels: ' num2str(relevant_vow_counter)...
        '   Total outliers: ' num2str(outlier_counter) ...
        '   % as outliers: ' num2str(perc_outliers)]);
    
 end    
