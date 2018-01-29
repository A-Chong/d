%% Puts the content of FAVE output files into a Matlab table.

% warning('off','all');
%% Folders containing FAVE output reads, both raw values and normalized
file_path = '/Users/amui/Dropbox/d/FAVE-extract_Toolkit/output_files/';

files_raw = dir([file_path '*.output.txt']);
files_norm = dir([file_path '*.output_norm.txt']);                       

%% Read data as .csv tables and place them in a struct named "results"

% Process for both raw and normalized outputs
for files = [files_raw, files_norm]
    
%% Main: loop over each output file as .csv and put the table in "results" struct    
for f = 1:length(files)

filename = [file_path files_raw(f).name];
T = readtable(filename,'Delimiter','\t','HeaderLines',1,'ReadVariableNames', true);

T(:,end) = []; % Last column is "", result from FAVE unnecessary

% Delete 'glide' column. It's empty for some files thus some tables have
% NaNs and others have strings
index = find(strcmp(T.Properties.VariableNames,'glide'));
T(:,index) = [];

% Create identification variables
round = repmat(str2num(files_raw(f).name(12)), height(T), 1);
team = repmat(str2num(files_raw(f).name(14)),height(T),1);
player = repmat(' ', height(T),1);
role = repmat(' ', height(T),1);

T = [table(round) table(team) table(player) T];

% Add to master struct
results(f).table = T;
results(f).name = files_raw(f).name;

end; % for f = 1:length(files)

%% Concatenate all tables from struct into single table with readings from all files

% Initialize table with first file
VOW = results(1).table;

for f=2:length(results)
    % Skip corrupted file
    if (size(results(f).table,1) > 0) & (size(results(f).table,2) == size(VOW,2))
        VOW = [VOW; results(f).table];
    end;
end;

%% Saving table

% Name table depending on whether it's files_norm or files_raw
table_name = regexp(files(1).name,'\.[a-z_]+\.', 'match');
if regexp(table_name{1},'norm'); table_name='_norm'; else; table_name=''; end; 

save(['/Users/amui/Dropbox/d/tables/VOW_' table_name '.mat'], 'VOW');

end;



