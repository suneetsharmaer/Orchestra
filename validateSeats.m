function validateSeats(vetted)
% validsateSeats(vetted) test each instrument
%
% Inputs
%   vetted, set to 1 to use only those that passed the "Happy Birthday"
%   test

true = 1;
false = 0;

com = serial('/dev/tty.usbmodem411', 'BaudRate', 115200);   % this is hardware dependent
fclose(instrfind);
fopen(com);

if(vetted)
    % pass in just the DECIMAL seat address
    % validateSeats(hex2dec('3F'))
    % table contains only those instruments that have passed the "Happy
    % Birthday" test
    seats = [vetted; vetted; vetted; vetted; vetted; vetted];
else
    % all instruments
    % validateSeats(0);
    seats = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31;
             32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47;
             48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63;
             64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79;
             80, 81, 82, 83, 84,111, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95;
             96, 97, 98, 99,100,101,102,103,104,105,106,107,108,109,110,  0];
end

freqs = [800, 1100, 1800, 3000, 4400, 6500, 9500];

[rows, cols] = size(seats);

exit = false;

% matrix to hold working status
working = zeros(rows, cols);

for row = 1:rows % go through each row
    frequency = (freqs(row+1) + freqs(row))/20;
    for col = 1:cols % go through each seat
        if(~exit && seats(row,col) > 0) % they've been vetted
            proceed = false;
            while(~proceed & ~exit)
                sendNote(com, seats(row,col), frequency, 0.5);
                result = questdlg(['Sent ' num2str(frequency) 'Hz to Instrument ' num2str(seats(row,col))],'Seat Validator','Success','Retry','Fail','Success');
                switch(result)
                    case 'Success'
                        proceed = 1;
                        working(row,col) = 1;
                    case 'Retry'
                        % let it loop
                    case 'Fail'
                        proceed = 1;
                        working(row,col) = 0;
                    case 'Exit'
                        exit = true;
                end
            end
        end
    end
end
fclose(com);

workingSeats = seats .* working;
save('workingSeats.mat','workingSeats');

end