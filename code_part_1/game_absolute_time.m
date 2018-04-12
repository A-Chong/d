
function[G] = game_absolute_time(GAME)

G = table();

for t=1:4;
    for block = 1:5;

tab = GAME(GAME.team == t & GAME.block == block,:);

% Breakdown of initial_trigger values into timestamp
tab.hour = tab.initial_trigger(:,4);
tab.minute = tab.initial_trigger(:,5);
tab.seconds = tab.initial_trigger(:,6);

% Substract 30 from those minutes that correspond to the smaller hour,
% and add 30 to those from the larger hour: 14:34-15:28 become 4-58 mins .
hours = unique(tab.hour);
if length(hours) == 2;
tab.minute(tab.hour==hours(1)) = tab.minute(tab.hour==hours(1))-30;
tab.minute(tab.hour >hours(1)) = tab.minute(tab.hour >hours(1))+30;
end;

% For each row, substract minute(1) from the minute(i) to normalize it
% multiply normalized minute by 60 and add seconds to take time to seconds
% scale.
for i = 1:height(tab);
    tab.start_absolute_seconds(i) = tab.minute(i) * 60 ...
                    + floor(tab.seconds(i)); % avoid when 59 s round 1 min
end;

    tab = [tab(:,1:6) tab(:, 37:end)];
    G = [G; tab];

    end;
end;

end

