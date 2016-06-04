function playMusic(com, note, instrument)
% playMusic() sends out a stream of serial packets to play a song.
%
% Inputs
%   com, a handle to an open serial port
%
%   note, an array of note structs
%
%       this is the "sheet music," and can be generated from midi files
%       automatically by makeSheetMusic()
%
%       for the k'th note
%           note(k).startTime,  is start time in seconds
%           note(k).freq,       is frequency in Hz
%           note(k).duration,   is duration in seconds
%
%   instruments, a cell array of lists of instrument IDs
%
%       this is a list of who plays what note
%
%       instrument{k} is a vector of instrument IDs who will all play
%           note(k) together

iNote = 1;
tic;
% while the song is not over
while (iNote <= numel(note))
    % if it is time for the next note
    if toc > note(iNote).startTime
        % have each player for the note play the note
        players = instrument{iNote};
        for ID = players
            sendNote(com, ID, note(iNote).freq, note(iNote).duration);
        end
        iNote = iNote+1;
    end
end