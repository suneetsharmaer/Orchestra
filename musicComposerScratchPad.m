% scratchpad for composing new songs

%% make the mechatronics sheet music from a midi you found
% if you dig into 'makeSheetMusic' you can get fancy by choosing only
% certain tracks or channels.

note = makeSheetMusic('hotelCalifornia.mid');

% this 'song' is an A440, for tuning verification
% note.startTime = 0;
% note.freq = 440;
% note.duration = 2;

%% make sure it sounds ok

note2 = note(1:end);
makeMidiFromSheetMusic(note2, 'hotelCaliforniaVerify.mid')