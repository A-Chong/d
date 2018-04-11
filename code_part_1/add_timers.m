%% Create day_timer, week_timer, all_timer

function[ALL] = add_timers(ALL)

% %% Time at the beggining of day 1 week 1, for explanation of game
% % This has to be adjusted manually, since sometimes a team started at
% % the o'clock, sometimes at the half hour.
% if unique(ALL.exp) == 1;
%     ALL.day_timer(ALL.team == 1 & ALL.day == 1)
%     ALL.day_timer(ALL.team == 2 & ALL.day == 1)


%% Week counter
for te = 1:4;
    %figure;  % These commented lines are for testing, they generate 4 plots
    %colors = {'r', 'b', 'g', 'k', 'm'}
    days = unique(ALL.day(ALL.team == te));
    for da = 1:5;
        ALL.week_timer(ALL.team == te & ALL.day == days(da)) = ...
          ALL.day_timer(ALL.team == te & ALL.day == days(da)) + (da-1)*60*60;
      %plot((ALL.week_timer(ALL.team == te & ALL.day == days(da))/60)/60, ALL.norm_F1(ALL.team == te & ALL.day == days(da)), 'color', colors{da});
      %hold on;
    end;      
end;

%% All counter
players = unique(ALL.player);
for pla = 1:4;
    ALL.all_timer(ALL.player == players(pla) & ALL.week == 1) = ...
        ALL.week_timer(ALL.player == players(pla) & ALL.week == 1);
    
    ALL.all_timer(ALL.player == players(pla) & ALL.week == 2) = ...
        ALL.week_timer(ALL.player == players(pla) & ALL.week == 2) + 5*60*60; %plus 5 days of 1 hour each
end;

%% Week counter old
for te = 1:4;
    rounds = unique(ALL.round(ALL.team == te));
    
    counter = 0;
    for ro = 1:length(rounds)
        indices = (ALL.round == rounds(ro) & ALL.team == te);
        
        % Update value of week_timer by adding the maxtime from previous round
        ALL.spoken_week_timer(indices) = ALL.t0(indices) + counter;
        
        % Update counter to new max
        counter = max(ALL.spoken_week_timer(indices));   
    end;
      
end;

%% Day counter old
for te = 1:4;
    days = unique(ALL.day(ALL.team == te));
    
    for da = 1:length(days);
        rounds = unique(ALL.round(ALL.team == te & ALL.day == days(da)));
        
        counter = 0;
    
            for ro = 1:length(rounds)        
                indices = (ALL.day == days(da) & ALL.round == rounds(ro) & ALL.team == te);
        
                % Update value of day_timer by adding the maxtime from previous round
                ALL.spoken_day_timer(indices) = ALL.t0(indices) + counter;

                % Update counter to new max
                counter = max(ALL.spoken_day_timer(indices));
            end;
        
    end;
end;
%% All counter old

players = unique(ALL.player);

for pl = 1:length(players)
    teams = unique(ALL.team(ALL.player == players(pl)));
    
    ind_1 = (ALL.player == players(pl) & ALL.team == teams(1));
    ALL.spoken_all_timer(ind_1) = ALL.spoken_week_timer(ind_1);
    
    counter = max(ALL.spoken_week_timer(ALL.team == teams(1)));
    
    ind_2 = (ALL.player == players(pl) & ALL.team == teams(2));
    ALL.spoken_all_timer(ind_2) = ALL.spoken_week_timer(ind_2) + counter;
    
end;

end
