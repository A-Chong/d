%% Adds variables phr_id and phr_comments





%%
function[T, phr_id] = phr_id_notes(filename, T,role,phr_id)

    path = '/Users/amui/Dropbox/d/textgrids/grids_phrase_corrected_not_FAVE_ready/';
    gr = ST_read_praat_textgrid([path filename 'rg.TextGrid']);
          
    % Index of the correct tier, in case they're in different orders in
    % different .TextGrids.   Pop-up error if word notes tier is missing.
    phr_tier = find(strcmp({gr(:).name}, 'phrase_comments'));
    if isempty(phr_tier); 
        msgbox(['There is no phrase_comments tier: ' filename 'rg'],...
            'Error');
    end;
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
    end;

%% Output
phr_id = phr_id;
T = T;
    
end    