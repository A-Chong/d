%% Add all other phones that are not vowels and fills word column appropriately



%%
function[T] = add_non_vows(filename,T,role)


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
        % See explanation for rounding in commit: 
        [xmin,xmax,text]=deal(round([gr(r).INT.xmin],3)',...
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
    
    %% Fill in all T.word rows comparing to words table
    for i=1:height(words)
        indices =find(T.beg>=words.xmin(i) &T.xEnd<=words.xmax(i));
        T.word(indices) = deal(words.text(i));
    end;    

end
