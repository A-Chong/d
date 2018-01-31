%% Used in read_FAVE_results.m
% Adds any annotations from the hand segmentation to the final data table.
%
% INPUT:
%       filename: string, filename of .TextGrid for which info is collected
%       T: table in which each row is a phone, with data from filename.
%       role: char, role of the player of the analysis.
%
% OUTPUT:
%       word_note: string array of length == height(T). Each entry
%           corresponds to a row in T, even if it's an empty ('') one. It
%           corresponds to within-word annotations for the speaker. So all
%           phones of the same word will have the same annotation.
%       phrase_note: string array of length == height(T). Same as word_note
%           but for within_phrase annotations, so that all phones of words 
%           of the same phrase will have the same annotation.

%function[T] = grid_annotations(filename, T, role);

    path = '/Users/amui/Dropbox/d/textgrids/grids_phrase_corrected_not_FAVE_ready/';
    gr = ST_read_praat_textgrid([path filename 'rg.TextGrid']);
    
    %% Create table of handsegmented .TextGrid to compare to given vowel
    % table T
        % Handsegmented .TextGrid has both Gphn and Rphn, so get 
        % correct index
        if role == 'g'; r = 4; else; r = 2; end;     

        % Given vowel table T has time rounded to 3 decimals, in order to
        % facilitate comparison, round to 3 decimals table from
        % handsegmented .TextGrid
        [xmin,xmax,text] = deal(round([gr(r).INT.xmin],3)',...
                                round([gr(r).INT.xmax],3)',...
                                {gr(r).INT.text}');
        data = [table(xmin) table(xmax) table(text)];
        
       % Creating table of missing phones with their corresponding beg and
       % end times
       b = table();     
       for i = 0:height(T)
            if i==0;
                a = data(data.xmax <= T.beg(1),:);
            elseif i == height(T)
                a = data(data.xmin >= T.xEnd(i),:);            
            elseif T.xEnd(i) < T.beg(i+1);
                a = data(data.xmin >= T.xEnd(i) & data.xmax <= T.beg(i+1),:);
            end;
            b = [b; a];
       end;

        % Adding missing phones, and their times, to input table T
        ind_1 = height(T)+1;  ind_2 = height(T) +height(b);
        T.beg(end+1:ind_2) = b.xmin;
        T.xEnd(ind_1:ind_2) = b.xmax;
        T.vowel(ind_1:ind_2) = b.text;        
        
        % Sort table
        T = sortrows(T,'beg');
        
 
    %% Make "words" table from .TextGrid corresponding Gwrd|Rwrd tier
    [xmin,xmax,text] = deal(round([gr(r-1).INT.xmin],3)',...
                            round([gr(r-1).INT.xmax],3)',...
                            {gr(r-1).INT.text}');
    words = [table(xmin) table(xmax) table(text)];

    %% Getting word annotations
    % Index of the correct tier, in case they're in different orders in
    % different .TextGrids.   Pop-up error if word notes tier is missing.
    index = find(strcmp({gr(:).name}, 'notes'));
    if isempty(index); 
        msgbox(['There is no notes tier:  ' filename 'rg'],'Error'); end;
    
    % Initialize column of word annotations in "words" table as {[]}
    words.word_annotations = repmat({[]}, height(words),1);
    words.word_annotations_2 = repmat({[]}, height(words),1);
    % List of word annotations texts with their time points, from grid file
    wrd_notes = {gr(index).INT.mark};
    % Loop over the list word annotations, and match the time of each to
    % the corresponding row according to time in table "words".
    for n = 1:length(wrd_notes);
        % Check whether it's an annotation for the present role
        if strcmp(wrd_notes{n}(end), role);
            % Determine the corresponding index in 'words' depeding on time
            note_time = gr(index).INT(n).time;
            in =find(words.xmin <= note_time & words.xmax >= note_time);
            % Save the annonation text in the relevant column
            if isempty(words.word_annotations{in});
                words.word_annotations(in) = {wrd_notes{n}(1:end-2)};
            elseif isempty(words.word_annotations_2{in});
                words.word_annotations_2(in) = {wrd_notes{n}(1:end-2)};
            else;
                msgbox(['There are > 2 annotations for word ' ...
                    words.text{in} ' in ' filename 'rg  at' ...
                    num2str(words.xmin(in))],'Problem');
            end;
        end;
    end;            
     
    %% Make "phrase" table from .TextGrid corresponding phrase_comments tier
    % Index of the correct tier, in case they're in different orders in
    % different .TextGrids.   Pop-up error if word notes tier is missing.
    index = find(strcmp({gr(:).name}, 'phrase_comments'));
    if isempty(index); 
        msgbox(['There is no phrase_comments tier: ' filename 'rg'],...
            'Error');end;
    % Table with phrase comments texts, xmin, and xmax, from grid file
    phrase = struct2table(gr(index).INT);    
    
    %% Getting phrase annotations

    % Loop over the list phrase comments, and match the time of each to
    % the corresponding rows according to time in table "words".
    for p = 1:length(phr_comments)
        if ~isempty(gr(index).INT(p).text);
            % Find indices of 'words' table that are within the time range
            % of the phrase
        end;
    end;
    
  %% Fill in all T.word rows comparing to words table
    for i=1:height(words)
        indices =find(T.beg>=words.xmin(i) &T.xEnd<=words.xmax(i));
        T.word(indices) = deal(words.text(i));
    end;
            
        
    %% Changing column names -- put this in read_FAVE_results
    beg_index = find(strcmp(T.Properties.VariableNames,'beg'));
    T.Properties.VariableNames(beg_index) = {'t0'};
    end_index = find(strcmp(T.Properties.VariableNames,'xEnd'));
    T.Properties.VariableNames(end_index) = {'t1'};
    T.Properties.VariableNames(1) = {'PHN'}; 

%end

