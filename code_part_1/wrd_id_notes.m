%% Create wrd_id and phr_id variables, unique identifiers for each word and phrase



%%
function[T, wrd_id] = wrd_id_notes(filename, T,role, wrd_id)

    path = '/Users/amui/Dropbox/d/textgrids/grids_phrase_corrected_not_FAVE_ready/';
    gr = ST_read_praat_textgrid([path filename 'rg.TextGrid']);

    % Handsegmented .TextGrid has both Gwrd and Rwrd, so get 
    % correct index
    if role == 'g'; wrd_tier = 3; else; wrd_tier = 1; end;        
    
    % Rounding of xmin and xmax to 3 decimal points necessary to be
    % compatible with T. This is a result of FAVE, which rounds to 3.
    % See explanation for rounding in commit: 
    words = struct2table(gr(wrd_tier).INT);
    [words.xmin,words.xmax] = deal(round(words.xmin,3),...
                                   round(words.xmax,3));


    %% Getting word annotations
    % Index of the correct tier, in case they're in different orders in
    % different .TextGrids.   Pop-up error if word notes tier is missing.
    wrd_note_tier = find(strcmp({gr(:).name}, 'notes'));
    if isempty(wrd_note_tier); 
        msgbox(['There is no notes tier:  ' filename 'rg'],'Error'); end;
    
    % Initialize column of word annotations in "words" table as {[]}
    words.word_annotations = repmat({[]}, height(words),1);
    words.word_annotations_2 = repmat({[]}, height(words),1);
    
    % If there are word notes -- there are none in some files 
    if ~(isempty(gr(wrd_note_tier).INT))
        
        % List of word annotations texts with their time points
        wrd_notes = {gr(wrd_note_tier).INT.mark};
        
        % Loop over the list word annotations, and match the time of each 
        %to the corresponding row according to time in table "words".
        for n = 1:length(wrd_notes);
            % Check whether it's an annotation for the present role
            if strcmp(wrd_notes{n}(end), role);
                % Determine the corresponding index in 'words' depeding on 
                % time
                note_time = gr(wrd_note_tier).INT(n).time;
                in =find(words.xmin<= note_time & words.xmax >= note_time);
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
    end;
 
    %% Adding wrd_id column and updating wrd_id output, adding annotations
    
    for i = 1:height(words);
        indices = find(T.beg >= words.xmin(i) & T.xEnd <= words.xmax(i));
        if ~isempty(indices);  % Problem with FAVE inconsistent rounding,
                               % change this when they respond.
        % Assign wrd_id to T.wrd_id and update wrd_id
        T.wrd_id(indices) = wrd_id;
        wrd_id = wrd_id + 1;
        
        % Assign annotations
        T.word_annotations(indices) = words.word_annotations(i);
        T.word_annotations_2(indices) = words.word_annotations_2(i);
        
        % Sanity check that the word from .TextGrid and from T are the same
        test = unique(T.word(indices));
        if ~strcmp(test{1}, words.text{i}); msgbox('Diff wrd','Error');end;
        
        else; %if ~isempty(indices);
            display(['word not added: ' words.text{i}]); end;
    end;

end

