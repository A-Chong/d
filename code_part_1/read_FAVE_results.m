%% Puts the content of FAVE output files into a Matlab table.
% Creates the final format of usable table, with variables:
%
% TO DO: finish writing comments and docummentation of all scripts used in
% code_part_1

warning('off','all');

for e = {'d', 'd2'}

    load(['/Users/amui/Dropbox/' e{1} ...
        '/tables_generated_by_Sam/game_data.mat']);
    
%% Process for both raw values and normalized
for output_type = {'*.output_norm.txt', '*.output.txt'}
    
%% Counters
t_counter = 1; % index counter for adding individual tables to struct 
                % containing all individual tables with giver and receiver 
                % roles. Needed above loop over giver and receiver
[wrd_id, phr_id] = deal(1); % initial value of variables wrd_id, phr_id, 
                % which are updated in call to function in wrd_phr_id.m                 

%% Folders containing FAVE output reads, both GIVER and RECEIVER
for rol = {'giver', 'receiver'}

file_path = ['/Users/amui/Dropbox/' e{1} ...
    '/FAVE-extract_Toolkit/output_files_' rol{1} '/'];

files = dir([file_path output_type{1}]);


    %% Timer to create time variables that resets for each day,
    % each week, or through the whole experiment
    
    % Keys for all diccionaries
    if e{1} == 'd'; 
        keySet = {'A', 'K', 'M', 'S'};
    else;           
        keySet = {'E', 'M', 'A', 'B'}; end;
    
    % Timer diccionaries
    valueSet = [0 0 0 0];
    day_timer = containers.Map(keySet,valueSet);
    week_timer = containers.Map(keySet,valueSet);
    all_timer = containers.Map(keySet,valueSet);
    
    % Counter diccionaries
    valueSet = [1 1 1 1];
    day_counter = containers.Map(keySet,valueSet);
    week_counter = containers.Map(keySet,valueSet);


    %% Main: loop over each output file as .csv and 
    % put the table in "results" struct 
    
    for f = 1:length(files)

        if f == 348;
            display('stop for testing'); end;
        
    filename = [file_path files(f).name];
    T = readtable(filename,'Delimiter','\t','HeaderLines',1,...
        'ReadVariableNames', true);
    
    % Leave out cases in which output from FAVE is an empty table. This 
    % accommodates  the corrupted files of day 5 of team 1 experiment 1 .
    if ~isempty(T);

    T(:,end) = []; % Last column is "", result from FAVE unnecessary

    % Delete 'glide' column. It's empty for some files thus some tables 
    % have NaNs and others have strings
    index = find(strcmp(T.Properties.VariableNames,'glide'));
    T(:,index) = [];
    
    % Add all other phones that are not vowels and fills word column
    % appropriately
    T = add_non_vows(files(f).name(1:15),T,rol{1}(1),e{1});

    % Create identification variables, 
    role = repmat(rol{1}(1), height(T),1);

        % Other identification variables, retrieve info from name of file
        ro = str2num(files(f).name(10:12));  % round
        round = repmat(ro, height(T), 1);
        te = str2num(files(f).name(14)); % team
        team = repmat(te, height(T),1);
        if te == 1 | te == 2; we = 1; else; we = 2; end; % week
        week = repmat(we, height(T),1);
        exp = repmat(str2num(files(f).name(7:8)),height(T),1); % experiment

        % Other identification variables, retrieve info from game_data.mat
        tab = GAME(GAME.round == ro & GAME.team == te,:);            
        pla = tab.(['pcode_' rol{1}(1)]){1};  % subject
        player = repmat(pla, height(T),1);
        if we == 1; da = tab.block; else; da = tab.block + 5; end; % day
        day = repmat(da(1), height(T),1);
        
    % Create wrd_id and phr_id variables, unique identifiers for each word
    % and phrase
    [T,phr_id] = phr_id_notes(files(f).name(1:15),T,role(1),phr_id,e{1});
    [T,wrd_id] = wrd_id_notes(files(f).name(1:15),T,role(1),wrd_id,e{1}); 
    
    % Add new variables to T
    T = [table(round) table(team) table(player) table(role) ...
        table(day) table(week) table(exp) T];

    % Change column names
    T.Properties.VariableNames(find(strcmp(T.Properties.VariableNames,...
        'beg'))) = {'t0'};
    T.Properties.VariableNames(find(strcmp(T.Properties.VariableNames,...
        'xEnd'))) = {'t1'};
    T.Properties.VariableNames(find(strcmp(T.Properties.VariableNames,...
        'vowel'))) = {'PHN'};
    T.Properties.VariableNames(find(strcmp(T.Properties.VariableNames,...
        'stress'))) = {'is_vowel'};    

    % Remove unnecessary variables
    indices_cols_remove = find(ismember(T.Properties.VariableNames,...
        {'B1', 'B2', 'B3','t','cd', 'fm','fp','fv','ps','fs', ...
        'style','nFormants'}));
    T(:,indices_cols_remove) = [];
    
    % Create day_timer column. Update day_timer and day_counter
    % accordingly to the team
    T.day_timer = T.t0 + day_timer(pla);
    day_timer(pla) = day_timer(pla) + max(T.t1);
    if day(1) > day_counter(pla); 
        day_counter(pla) = day(1); 
        day_timer(pla) = 0;
    end;
    % Create week_timer column, update week_timer counter.
    T.week_timer = T.t0 + week_timer(pla);
    week_timer(pla) = week_timer(pla) + max(T.t1);
    if week(1) > week_counter(pla); 
        week_counter(pla) = week(1);
        week_timer(pla) = 0; 
    end;
    % Create all_timer column.
    T.all_timer = T.t0 + all_timer(pla);
    all_timer(pla) = all_timer(pla) + max(T.t1);
    % All timer for day 5 exp 1 subject A, skip thay day for all_timer
    if pla == 'A' & exp(1) == 1 & da == 6 & day_timer(pla) == 0;
        T.all_timer = T.t0 + all_timer('K');
        all_timer(pla) = all_timer(pla) + max(T.t1);
    end;
    
    % Add to master struct
    results(t_counter).table = T;
    results(t_counter).name = files(f).name;
    
    % Update counter
    t_counter = t_counter + 1;
    
    end; %     if ~isempty(T);
    end; % for f = 1:length(files)

%%
end; % for role = {'giver', 'receiver'}
%% Concatenate all tables from struct into single table with readings from all files

% Initialize table with first file
ALL = results(1).table;

for f=2:length(results)
    % Skip corrupted file
    if (size(results(f).table,1) > 0) & (size(results(f).table,2) == size(ALL,2))
        ALL = [ALL; results(f).table];
    end;
end;

    % Create identification variable phn_id
    phn_id = linspace(1,height(ALL), height(ALL))';
    ALL = [table(phn_id) ALL];
    
%% VOW and ALL tables
% In reality, the table so far contains "all" phones so it should be called 
% 'ALL', and this is important as it becomes the reference table.
% For ease of analysis, it is better to save a table that contains only
% vowels, more apt to the name 'VOW'.

% Eliminating 5th day for subject A in experiment 1, damaged files
if exp(1) == 1;
    ALL(~(ALL.player == 'A' & ALL.day == 5),:);
end;

% Adjust naming to avoid overlap of letter codes between subjects of exp 1
% and exp 2 -- two A and two M originally used.
if strcmp(e{1}, 'd2');
    ALL.player(find(ALL.player == 'A')) = deal('N');
    ALL.player(find(ALL.player == 'M')) = deal('G');
end;

%
VOW = ALL(ALL.is_vowel == 1,:);

%% Saving tables

% Name table depending on whether it's files_norm or files_raw
table_name = regexp(files(1).name,'\.[a-z_]+\.', 'match');
if regexp(table_name{1},'norm'); table_name='_norm'; else; table_name=''; end; 

save(['/Users/amui/Dropbox/' e{1} '/tables/ALL' table_name '.mat'], 'ALL');
writetable(ALL,['/Users/amui/Dropbox/' e{1} '/tables/ALL' table_name '.csv'],...
    'Delimiter',','); 

save(['/Users/amui/Dropbox/' e{1} '/tables/VOW' table_name '.mat'], 'VOW');
writetable(VOW,['/Users/amui/Dropbox/' e{1} '/tables/VOW' table_name '.csv'],...
    'Delimiter',','); 


end;

end;

