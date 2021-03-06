%% Adds variables phr_id and phr_comments





%%
function[T, phr_id] = phr_id_notes(filename, T,role,phr_id,e)

    path = ['/Users/amui/Dropbox/' e ...
        '/textgrids/grids_phrase_corrected_not_FAVE_ready/'];
    gr = ST_read_praat_textgrid([path filename 'rg.TextGrid']);
          
    % Index of the correct tier, in case they're in different orders in
    % different .TextGrids.   Pop-up error if word notes tier is missing.
    phr_tier = find(strcmp({gr(:).name}, 'phrase_comments'));
    if ~isempty(phr_tier); 
    
    % Apply only if the tier is not empty   
    if ~isempty(gr(phr_tier).INT);  
        
    % Table with phrase comments texts, xmin, and xmax, from grid file
    phrases = struct2table(gr(phr_tier).INT);
    
    %% Adding phr_id column and updating phr_id output

    for i=1:height(phrases);
        indices = find(T.beg >= phrases.xmin(i) & T.xEnd <= phrases.xmax(i));
        % Assign phr_id to T.phr_id and update phr_id
        T.phr_id(indices) = phr_id;
        phr_id = phr_id + 1;
        
        %% Assign phrase_comments
        T.phr_comment(indices) = phrases.text(i);
        if i==height(phrases); T.phr_comment(indices)={'end'}; end;
    end;
    
    %% Catch if there are no marks in phrase_comments tier
    else
        T.phr_id = repmat(0, height(T),1);
        T.phr_comment = repmat({[]},height(T),1);
    end; % if ~isempty(gr(phr_tier).INT);

    %% Catch if phrase_comments tier is missing 
    else;
        msgbox(['There is no phrase_comments tier: ' filename 'rg'],...
            'Error');
        display(['There is no phrase_comments tier: ' filename]);
    end; % if ~isempty(phr_tier);
%% Output
phr_id = phr_id;
T = T;
    
end    