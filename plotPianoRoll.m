function plotPianoRoll(data)
% plot notes over time
% data is of the format returned by midiInfo()

%% compute piano-roll:
[PR,t,nn] = piano_roll(data);

%% display piano-roll:
figure(1);
imagesc(t,nn,PR);
axis xy;
xlabel('time (sec)');
ylabel('note number');

end