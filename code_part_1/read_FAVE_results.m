%% Puts the content of FAVE output files into a Matlab table.

warning('off','all');
load('/Users/amui/Dropbox/d/tables_generated_by_Sam/game_data.mat');

%% Process for both raw values and normalized
for output_type = {'*.output.txt', '*.output_norm.txt'}
    
%% Folders containing FAVE output reads, both GIVER and RECEIVER
t_counter = 1; % index counter for adding individual tables to struct 
                % containing all individual tables with giver and receiver 
                % roles. Needed above loop over giver and receiver

for role = {'giver', 'receiver'}

file_path = ['/Users/amui/Dropbox/d/FAVE-extract_Toolkit/output_files_' ...
    role{1} '/'];

files = dir([file_path output_type{1}]);

    %% Main: loop over each output file as .csv and 
    % put the table in "results" struct 
    
    for f = 1:length(files)

    filename = [file_path files(f).name];
    T = readtable(filename,'Delimiter','\t','HeaderLines',1,...
        'ReadVariableNames', true);

    T(:,end) = []; % Last column is "", result from FAVE unnecessary

    % Delete 'glide' column. It's empty for some files thus some tables 
    % have NaNs and others have strings
    index = find(strcmp(T.Properties.VariableNames,'glide'));
    T(:,index) = [];

    % Create identification variables, 
    rol = repmat(role{1}(1), height(T),1);

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
        pla = tab.(['pcode_' role{1}(1)]){1};  % subject
        player = repmat(pla, height(T),1);
        if we == 1; da = tab.block; else; da = tab.block + 5; end; % day
        day = repmat(da, height(T),1);
            

    T = [table(round) table(team) table(player) table(rol) ...
        table(day) table(week) table(exp) T];

    % Add to master struct
    results(t_counter).table = T;
    results(t_counter).name = files(f).name;
    
    % Update counter
    t_counter = t_counter + 1;
    
    end; % for f = 1:length(files)

%%
end; % for role = {'giver', 'receiver'}
%% Concatenate all tables from struct into single table with readings from all files

% Initialize table with first file
VOW = results(1).table;

for f=2:length(results)
    % Skip corrupted file
    if (size(results(f).table,1) > 0) & (size(results(f).table,2) == size(VOW,2))
        VOW = [VOW; results(f).table];
    end;
end;

    % Create identification variable vow_id
    vow_id = linspace(1,height(VOW), height(VOW))';
    VOW = [table(vow_id) VOW];

%% Saving table

% Name table depending on whether it's files_norm or files_raw
table_name = regexp(files(1).name,'\.[a-z_]+\.', 'match');
if regexp(table_name{1},'norm'); table_name='_norm'; else; table_name=''; end; 

save(['/Users/amui/Dropbox/d/tables/VOW' table_name '.mat'], 'VOW');

end;



