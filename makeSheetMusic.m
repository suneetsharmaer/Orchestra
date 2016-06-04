function note = makeSheetMusic(midiFilename)
% makeSheetMusic() processes a midi file and returns a sequence of musical
% notes with start times, frequencies, and durations
%
% Input
%   midiFilename, file name of midi file (make sure Matlab will find it)
%
% Output
%   note, a array of note structs
%       note(k)             is the k'th note struct
%       note(k).startTime   is the note start time in seconds
%       note(k).freq        is the frequence in Hz
%       note(k).duration    is the duration in seconds
%
% Comments
%   -Array of structs 'notes' is ordered by the note start times.
%   -Multiple notes may have the same start time.
%   -Midi music often has multiple tracks and multiple channels.  This
%       function includes everything in the sheet music.  If you want to be
%       more selective, you can write your own function that filters out
%       rows of 'data' before recompiling into the array 'note'.
%
% Matlab syntax reminders
%   v = [note(k).startTime] is a vector containing all start times


% extract all midi information
midi = readmidi(midiFilename);  % lots of midi metadata

% extract midi note information
% [trackNumber, channelNumber, noteNumber (pitch), velocity (volume),
%           timeOn, timeOff, messageNumberOn, messageNumberOff]
data = midiInfo(midi,0);                % extract midi notes
% data = data(data(:,1)==2,:);            % get only track 1

% make sheet music
% an array of note structs in order of initiation
noteData = [data(:,5), midi2freq(data(:,3)), data(:,6)-data(:,5)];
noteData = sortrows(noteData,1);

for k = 1:size(noteData,1)
    note(k).startTime = noteData(k,1);  % start time
    note(k).freq = noteData(k,2);       % frequency in Hz
    note(k).duration = noteData(k,3);   % duration in seconds
end

end