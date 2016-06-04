function playMe(filename, numPerNote)
% testMe(filename, numPerNote) tests your ability to play a short song.
%
% Inputs
%   filename, the filename to the music .mat file
%   numPerNote, number of instruments to play for each note

% prepare serial port
% fclose(instrfind);
true = 1;
false = 0;

com = serial('/dev/tty.usbmodem411', 'BaudRate', 115200);   % this is hardware dependent
fclose(instrfind);
fopen(com);

% load song
%load('sheetMusic/happyBirthday.mat')
%load('sheetMusic/jesu2.mat')
load(filename);

% the upper deciHertz for each row in seats
freqs = [1100, 1800, 3000, 4400, 6500, 9500];

load('workingSeats.mat'); % imports a 6x13 array with the address of the working instruments
seats = workingSeats;

rows = 6;
columns = 16;
% who's playing
free = zeros(rows,columns);

% prepare instrument choices
for iNote = 1:numel(note);
    
    % update free times (0 when available) 
    free = free .* (free > note(iNote).startTime);
    
    % determine availability
    available = ~free & (seats > 0);
    
    % determine the appropriate frequency row
    row = sum(freqs < 10*note(iNote).freq) + 1;
    if(row<1)
        row=1;
    end
    if(row>rows)
        row=rows;
    end
    % assign an instrument from the row
    assigned = 0;
    instrument(iNote) = {[]};
    for iRow = 1:columns
        if(available(row,iRow))
            instrument(iNote) = {[instrument{iNote} seats(row,iRow)]};
            free(row,iRow) = note(iNote).startTime + note(iNote).duration;
            assigned = assigned + 1;
            if(assigned == numPerNote)
                break;
            end
        end
    end
    while(assigned < numPerNote) % only loops if we didn't get enough
        disp(['Need ' num2str(numPerNote-assigned) ' more in row ' num2str(row) '!']);
        % take over the one who's been playing the longest
        freetemp = free;
        for iRow = 1:columns
            if(freetemp(row,iRow) == 0)
                freetemp(row,iRow) = NaN;
            end
        end
        [Y,I] = min(freetemp(row,:)); % get earliest time to be done
        instrument(iNote) = {[instrument{iNote} seats(row,I)]};
        free(row,I) = note(iNote).startTime + note(iNote).duration;
        assigned = assigned + 1;
    end
    % disp(['Assigned ' num2str(note(iNote).freq) ' to ' num2str(instrument{iNote})]);
    
    % visualize instrument selection
    %[r,c] = size(free);             
    %imagesc((1:c)+0.5,(1:r)+0.5,flipud(free==0));
    %colormap(gray);
    %grid on;
    %spy(flipud(free>0),'k.',100);
    %bar3(flipud(free>0));
    %pause(0.001);
end

disp('Play!');
playMusic(com, note, instrument);
disp('Done!');

% close serial port
fclose(com);


end