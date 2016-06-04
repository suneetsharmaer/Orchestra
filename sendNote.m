function sendNote(com, instrument, freq, dur)
% sendNote() sends a serial packet to the conductor commanding one note
% played with frequency and duration.
%
% Inputs
%   com,        com port handle
%   instrument, instrument ID number (decimal)
%   frequency,  in Hz
%   duration,   in seconds

% make instrument string
if(instrument<100)
    instrument_string = ['0' num2str(instrument)];
else
    instrument_string = num2str(instrument);
end

% make frequency string
freq = round(freq*10);    % frequency in deciHz
if(freq < 100)
    frequency_string = ['00' num2str(freq)];
elseif(freq < 1000)
    frequency_string = ['0' num2str(freq)];
else
    frequency_string = num2str(freq);
end

% make duration string
dur = round(dur*100);  % duration in centiseconds
if(dur < 10)
    duration_string = ['00' num2str(dur)];
elseif(dur<99)
    duration_string = ['0' num2str(dur)];
else
    duration_string = num2str(dur);
end

% send serial packet
fprintf(com, ['X', instrument_string, frequency_string, duration_string]);

% display packet for debugging purposes
% disp(['X', instrument_string, frequency_string, duration_string]);

end
