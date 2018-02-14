%% Author: AChong  Last updated: 10/19/2016
%% subject_data_entering.m
%  - input: none, this is to fill out subject_data.mat interactively
%  - output: 
%  - description:
%  -  called from: formants_overnight.m
%  - functions called from here: none
% 	codes for answers:  1 = no/week 1    2 = yes/ week 2     0 = no difference/neutral


%%
for s=1:4;
    subjects(s).experiment = input('Experiment number 1 or 2 :');
    subjects(s).name = input('Enter full name: ');
    subjects(s).initial = input('Enter name initial: ');
    subjects(s).age = input('Age');
    subjects(s).native_language =  input('Native language: ');
    subjects(s).other_languages = input('Other languages you are fluent in');
    subjects(s).q1_time_of_day_preference =  input('q1_time_of_day_preference later, earlier, no difference: ');
    subjects(s).q2_week_perform_best = input('q2_week_perform_best week 1, week 2, no difference: ');
    subjects(s).q3_enjoy_playing_game = input('q3_enjoy_playing_game yes, no, neutral: ');
    subjects(s).q4_week_enjoy_game_better = input('q4_week_enjoy_game_better week 1, week 2, no difference: ');
    subjects(s).q5_changes_instructions_weekToWeek = input('q5_changes_instructions_weekToWeek Nothing, This:     ');
    subjects(s).q6_noise_cancellation_effect = input('q6_noise_cancellation_effect No, yes, neutral :');
    subjects(s).q7_preferred_teammate_to_compete_against_others = input('q7_preferred_teammate_to_compete_against_others week 1, week 2, no difference: ');
    subjects(s).q8_best_teammate_at_receiving_instructions = input('q8_best_teammate_at_receiving_instructions week 1, week 2, no difference: ');
    subjects(s).q9_best_teammate_at_giving_instructions = input('q9_best_teammate_at_giving_instructions week 1, week 2, no difference: ');
    subjects(s).q10_enjoy_playing_with_teammate_of_week1 = input('q10_enjoy_playing_with_teammate_of_week1 yes, no, neutral :  ');
    subjects(s).q11_enjoy_playing_with_teammate_of_week2 = input('q11_enjoy_playing_with_teammate_of_week2 yes, no, neutral :  ');
    subjects(s).q12_what_would_make_experience_more_enjoyable = input('q12_what_would_make_experience_more_enjoyable Nothing, This:     ');
    subjects(s).q13a_intersted_doing_well_competition_NO = input('q13a_intersted_doing_well_competition_NO 0 or 1');
    subjects(s).q13b_intersted_doing_well_competition_betweenGAMES = input('q13b_intersted_doing_well_competition_betweenGAMES 0 or 1');
    subjects(s).q13c_intersted_doing_well_competition_betweenTEAMS = input('q13c_intersted_doing_well_competition_betweenTEAMS 0 or 1');

    subjects(s).q14_interact_with_teammates_outside_lab = input('q14_interact_with_teammates_outside_lab No,   Yes, describe : ');
    subjects(s).q15_any_comments = input('Any comments : ');
end; 

subject_table = struct2table(subjects);

e = subjects(1).experiment;
if e==1; e = ''; else; e = str2num(e); end;
save(['/Users/amui/Dropbox/d' e '/tables/subject_data.mat'], 'subject_table');
writetable(subject_table,['/Users/amui/Dropbox/d' e ...
    '/tables/subject_data.csv'], 'Delimiter',',');
