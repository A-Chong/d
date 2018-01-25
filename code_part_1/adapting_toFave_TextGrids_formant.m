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

%% Folders for input and output files

folder = '/Users/amui/d/textgrids/';

% Input textgrids
path = [folder 'grids_phrase_corrected_not_FAVE_ready/'];
origin_dir = dir(path);
origin_dir(1:3) = []; % Delete first three instances,because they are:
                      % '.','..', and '.DS_Store'

% Output textgrids
mkdir([folder 'FAVE_formatted']);
modified_dir = [folder 'FAVE_formatted/'];

%% Main body
%  Read each .TextGrid file, get main 4 tiers, adapt annotations to the 
%  style used by FAVE, and save output.

for file = 1:length(origin_dir)
    
    % Read the individual .TextGrid file
    TextGrid(file).read = ST_read_praat_textgrid([path origin_dir(file).name])
    
    % Ignore cases like TexGrid(212) because file 117 is corrupted
    if length(TextGrid(file).read) > 1; 
        
        % Use only Gphn, Gwrd, Rphn, Rwrd tiers, and ignore the rest.
        Rphn = TextGrid(file).read(find(strcmp({TextGrid(file).read(:).name}, 'Rphn')));
        Rwrd = TextGrid(file).read(find(strcmp({TextGrid(file).read(:).name}, 'Rwrd')));
        Gphn = TextGrid(file).read(find(strcmp({TextGrid(file).read(:).name}, 'Gphn')));
        Gwrd = TextGrid(file).read(find(strcmp({TextGrid(file).read(:).name}, 'Gwrd')));
        
        TextGrid(file).read(1) = Rphn;
        TextGrid(file).read(2) = Rwrd;
        TextGrid(file).read(3) = Gphn;
        TextGrid(file).read(4) = Gwrd;
        
        TextGrid(file).read(5:end) = [];
        
        % Dictionary check
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
        
        % Adapt to FAVE format each of the relevant tiers
        for tier = 1:4
            a = TextGrid(file).read(tier).INT;
            name = TextGrid(file).read(tier).name;
            TextGrid(file).read(tier).INT = Fave_modify_text(a, name);
        end;
    
        % Create Giver-only structure
        Giver(file).read(1) = TextGrid(file).read(3);
        Giver(file).read(2) = TextGrid(file).read(4);
    
    % Saving Giver .TextGrid file    
    file_name = [modified_dir 'Giver_FAVE_modified_' ...
        origin_dir(file).name(1:15) 'g.TextGrid'];    

    ST_write_praat_textgrid(Giver(file).read, file_name);    
    
%     % Saving .TextGrid file containing both Giver AND Receiver
%     giv_rec_filename = [modified_dir 'FAVE_modified_' ...
%         origin_dir(file).name];
%     ST_write_praat_textgrid(TextGrid(file).read, giv_rec_filename)
    
    
    end;   % if length(TextGrid(211).read) > 1;
end;
