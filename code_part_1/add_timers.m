%% Create day_timer, week_timer, all_timer

function[ALL] = add_timers(ALL)

%% Make all day_timer go from 0 sec to 60 sec, since that measures the time
% in interaction, regardless of timestamp
for t=1:4;
    days = unique(ALL.day(ALL.team == t));
    
    for d = min(days):max(days);
        start = min(ALL.day_timer(ALL.day == d & ALL.team == t));
        final = max(ALL.day_timer(ALL.day == d & ALL.team == t));
        
        if start <0 & final >60*60;
            display(["team " num2str(t) " day " num2str(d) " is <0 and >60"]);
        end;
        
        cushion = abs(0 - start);
        
        if start < 0;
            ALL.day_timer(ALL.day == d & ALL.team == t) = ...
                ALL.day_timer(ALL.day == d & ALL.team == t) + cushion;
        else;
            ALL.day_timer(ALL.day == d & ALL.team == t) = ...
                ALL.day_timer(ALL.day == d & ALL.team == t) - cushion;            
        end;
        
    end;
end;



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
