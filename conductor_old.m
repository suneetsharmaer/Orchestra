clear all;

load('beet.mat'); % brings in 
ans = ans(1:1000,:);
players = importdata('players.csv'); % 1=address, 2=upper_f, sorted by 2

players(:,1)=hex2dec('43');

f_limits = [55, 110, 180, 300, 440, 650, 950, 1400, 3000];

buckets = 2*(ans(:,1)<f_limits(1));
for(i=2:length(f_limits))
    buckets = buckets + i*((ans(:,1)<f_limits(i))&(ans(:,1)>f_limits(i-1)));
    rows = find(players(:,3)==i);
    musicians{i} = players(rows,1);
end
musician = zeros(length(ans),1);
data = [buckets ans musician]; % bucket, actual F, time, duration


num_musicians(1) = 0;
for(j=2:9)    % for each bucket 
    num_musicians(j) = length(musicians{j});
    seats = musicians{j};       % pull the list of seats
    chair = 1;                 % start with first chair
    for(i=1:length(data))   % go through the song
        if(data(i,1)==j)    % need a musician
             data(i,5) = seats(chair);
             chair = chair+1;
             if(chair>num_musicians(j))
                 chair=1;
             end
%            musicians{j}
        end
        if(data(i,4)>2.5)
            data(i,4)=2.5;  % keep durations below the 8-bit max
        end
    end
end
    
samples = 10*data(end,3);

for(i=1:samples)
    rows = find(data(:,3)==i/10);
    music{i} = [data(rows,5) round(data(rows,2)) 100*data(rows,4)];
end

% parse into "instruments" (this could be vectorized, but I'm tired!)
for(i=1:samples)         % each 0.1 seconds
    instruments = music{i};     % pull the instrument matrix
    for(j=1:size(instruments,1))    % for each instrument
        instrument_string = num2str(instruments(j,1));
        freq = instruments(j,2);
        if(freq < 100)
            frequency_string = ['00' num2str(freq)];
        elseif(freq < 1000)
            frequency_string = ['0' num2str(freq)];
        else
            frequency_string = num2str(freq);
        end
        dur = instruments(j,3);
        if(dur < 10)
            duration_string = ['00' num2str(dur)];
        elseif(dur<99)
            duration_string = ['0' num2str(dur)];
        else
            duration_string = num2str(dur);
        end
        for(k=1:83)
            strings{i,j} = ['X' instrument_string frequency_string duration_string];
        end
        
    end
end

t = timer('TimerFcn',['set=strings{get(t,''TasksExecuted''),:};',... 
                      'for(i=1:size(set,1));',...
                      'disp(set(i,:));',...
                      'fprintf(m2,set(i,:));',...
                      'end;'],'StopFcn','fclose(m2);','Period',0.075,'ExecutionMode','fixedRate','TaskstoExecute',samples);

                  
m2 = serial('/dev/tty.usbmodem411','BaudRate', 115200);
fopen(m2);

start(t)