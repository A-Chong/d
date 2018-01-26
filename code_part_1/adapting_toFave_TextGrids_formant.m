%%
% Reads .TextGrids as the result from handsegmentation, checks with 
% dictionary that all words are spelled correctly, and turns the .TextGrids 
% into a format expected by FAVE.
%
% IMPORTANT: Does not need input arguments, but do pay attention to input 
% and output folders.
	
% Input:
% 	Handsegmented .TextGrid files from experiment 1, stored in folder :
%   grids_phrase_corrected_not_FAVE_ready
% 
% Output:
%   .TextGrid files ready to be read by FAVE. This function creates folder:
%   FAVE_formatted

% Functions:
% 	ST_read_praat_textgrid.m
% 	ST_write_praat_textgrid.m
% 	FAVE_modify_text.m
%   dictionary.m

%% Folders for input and output files

folder = '/Users/amui/d/textgrids/';

% Input textgrids
path = [folder 'grids_phrase_corrected_not_FAVE_ready/'];
origin_dir = dir(path);
origin_dir(1:3) = []; % Delete first three instances,because they are:
                      % '.','..', and '.DS_Store'

% Output textgrids
mkdir([folder 'FAVE_formatted/'], ['FAVE_rcver/']);
mkdir([folder 'FAVE_formatted/'], ['FAVE_giver/']);

output_folders = containers.Map;
output_folders('r') = [folder 'FAVE_formatted/FAVE_rcver/'];
output_folders('g') = [folder 'FAVE_formatted/FAVE_giver/'];

%% Main body
%  Read each .TextGrid file, get main 4 tiers, adapt annotations to the 
%  style used by FAVE, and save output.

for file = 1:length(origin_dir)
    
    % Read the individual .TextGrid file
    Grid(file).read = ST_read_praat_textgrid([path origin_dir(file).name])
    
    % Ignore cases like TexGrid(212) because file 117 is corrupt
    if length(Grid(file).read) > 1; 
        
        % Use only Gphn, Gwrd, Rphn, Rwrd tiers, and ignore the rest.
        tiers = {'Rphn', 'Rwrd', 'Gphn', 'Gwrd'};
        for t = 1:4;
            index = find(strcmp({Grid(file).read(:).name}, tiers{t}));
            TextGrid(file).read(t) = Grid(file).read(index);
        end;        
        
        % Dictionary check, call to dictionary.m
        for role = [2,4]
            words  = TextGrid(file).read(role).INT;
            phones = TextGrid(file).read(role-1).INT;
            
            for w = [1:length(words)];
                index_t0 = find([phones.xmin] == words(w).xmin);
                index_t1 = find([phones.xmin] == words(w).xmax);
                                
                word = words(w).text;
                phone = [phones(index_t0:index_t1-1).text];
                
                match = dictionary(word, phone);
                if strcmp(match, 'correct') == 'False';
                    fprintf('word');
                    fprintf('origin_dir(file).name(1:15)');                      
                end;                                    
            end;
        end;
        
        % Adapt each of the relevant tiers to FAVE format, and save them
        % in dictionary named tier_book with their name as key ('Rphn','Gwrd',etc.) 
        tier_book = containers.Map;  % -- dictionary object
        for tier = 1:4
            a = TextGrid(file).read(tier).INT;
            tier_name = TextGrid(file).read(tier).name;
            TextGrid(file).read(tier).INT = Fave_modify_text(a, tier_name);
            
            tier_book(tier_name) = TextGrid(file).read(tier);
        end;
        
        % Create and save role-specific structures
        for role = {'r','g'};
            switch role{1};                
               case 'r';
                 [read(1),read(2)] = deal(tier_book('Rphn'),tier_book('Rwrd'));
                case 'g';
                 [read(1),read(2)] = deal(tier_book('Gphn'),tier_book('Gwrd'));
            end;
            ST_write_praat_textgrid(read,[output_folders(role{1}) ...
                origin_dir(file).name(1:15) role{1} '.TextGrid']);
        end;
            
%     % Saving .TextGrid file containing both Giver AND Receiver
%     filename = [folder 'FAVE_formatted/' ...
%         origin_dir(file).name];
%     ST_write_praat_textgrid(TextGrid(file).read, filename)
    
    
    end;   % if length(TextGrid(211).read) > 1;
end;
