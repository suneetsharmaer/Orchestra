function testMe(ID)
% testMe() tests your ability to play a short song.
%
% Inputs
%   ID, your player ID number (in decimal, not hexadecimal)

% prepare serial port
% fclose(instrfind);
com = serial('COM4', 'BaudRate', 115200);   % this is hardware dependent
fclose(instrfind);
fopen(com);

% load song
%load('makingMusic/happyBirthday.mat')
load('makingMusic/happyBirthday.mat')

% prepare instrument choices
% in this case, there is only one instrument and it plays each note
for iNote = 1:numel(note);
    instrument(iNote) = {ID}; % important that instrument is a cell array!
end

disp('Play!');
playMusic(com, note, instrument);
disp('Done!');

% close serial port
fclose(com);


end