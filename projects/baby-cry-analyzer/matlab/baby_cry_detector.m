function result = baby_cry_detector(filename)
%BABY_CRY_DETECTOR Select a WAV file and display YAMNet acoustic scores.
% No recording, playback, upload or automatic saving is performed.
if nargin == 0
    [name, folder] = uigetfile({'*.wav','WAV audio'}, 'Select local audio');
    if isequal(name,0)
        result = [];
        return
    end
    filename = fullfile(folder,name);
end
result = analyze_file(filename);
fprintf('\nBaby Cry Analyzer | exploratory acoustic analysis\n');
fprintf('Top class: %s (%.2f%% score)\n',result.TopClass,100*result.TopScore);
fprintf('Crying, sobbing: %.2f%% score\n',100*result.CryScore);
fprintf('Frames: %d | Input duration: %.2f s\n',result.FrameCount,result.DurationSeconds);
fprintf('Scores are not accuracy estimates or diagnoses.\n');
disp(result.Ranking(1:min(5,height(result.Ranking)),:));
end
