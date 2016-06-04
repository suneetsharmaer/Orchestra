function makeMidiFromSheetMusic(note, filename)
% Take some mechatronics sheet music and create a midi file you can play on
% your computer.  This is mostly useful for debugging new songs.

data = zeros(numel(note),6);
data(:,1) = 1;                              % all track 1
data(:,2) = 1;                              % all channel 1
data(:,3) = freq2midi([note.freq]');        % frequencies
data(:,4) = 100;                            % all volume 100
data(:,5) = [note.startTime]';              % start times
data(:,6) = data(:,5) + [note.duration]';   % stop times

midi_new = matrix2midi(data);
writemidi(midi_new, filename);