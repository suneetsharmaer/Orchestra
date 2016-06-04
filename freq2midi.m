function m = freq2midi(f)
% this isn't quite right, but it's close enough
% this function is only used when making a new midi file from mechatronics
% sheet music, usually for debugging purposes.

% m = 12*log2(f/440)+57;        % some dude on the internet
m = 69 + 12 * log2(f./440);     % wikipedia

end