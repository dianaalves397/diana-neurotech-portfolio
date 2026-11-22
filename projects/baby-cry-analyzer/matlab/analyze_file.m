function result = analyze_file(filename)
%ANALYZE_FILE Read a local WAV and run a fixed pretrained YAMNet pipeline.
arguments
    filename (1,1) string
end
if ~isfile(filename)
    error('babycry:MissingFile','The selected file does not exist.');
end
[~,~,extension] = fileparts(filename);
if ~strcmpi(extension,'.wav')
    error('babycry:FileType','Select a WAV file.');
end
info = audioinfo(filename);
% Refuse long inputs before allocating their samples. No silent truncation.
if info.Duration > 300
    error('babycry:TooLong','Maximum supported duration is 300 seconds.');
end
[audio,fs] = audioread(filename);
[mono,metadata] = prepare_audio(audio,fs);
persistent net classes
if isempty(net)
    [net,classes] = audioPretrainedNetwork("yamnet");
end
features = yamnetPreprocess(mono,fs,OverlapPercentage=50);
if isempty(features)
    error('babycry:NoFrames','Preprocessing produced no frames.');
end
% Explicit batch-by-class output avoids ambiguous dimension inference.
scores = minibatchpredict(net,features,InputDataFormats="SSCB", ...
    OutputDataFormats="BC",ExecutionEnvironment="cpu",MiniBatchSize=32);
if isa(scores,'dlarray')
    scores = extractdata(scores);
end
result = summarize_scores(double(scores),classes);
result.DurationSeconds = metadata.DurationSeconds;
result.OriginalSampleRate = fs;
result.OriginalChannels = metadata.OriginalChannels;
result.PaddingSeconds = metadata.PaddingSeconds;
result.MATLABRelease = string(version('-release'));
result.Model = "MathWorks audioPretrainedNetwork yamnet";
result.OverlapPercentage = 50;
% Deliberately omit file paths, names, waveform and identifiable metadata.
end
