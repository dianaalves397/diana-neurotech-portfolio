function [mono,metadata] = prepare_audio(audio,fs)
%PREPARE_AUDIO Validate samples, average channels and pad short inputs.
validateattributes(audio,{'double','single'}, ...
    {'2d','real','finite','nonempty'},mfilename,'audio');
validateattributes(fs,{'numeric'}, ...
    {'scalar','real','finite','integer','>=',16000},mfilename,'fs');
if any(abs(audio(:)) > 1)
    error('babycry:Amplitude','Audio samples must be within [-1,1].');
end
metadata.DurationSeconds = size(audio,1)/fs;
metadata.OriginalChannels = size(audio,2);
mono = mean(double(audio),2);
if metadata.DurationSeconds > 300
    error('babycry:TooLong','Maximum supported duration is 300 seconds.');
end
% One second exceeds the receptive duration of a YAMNet input patch.
% Padding is disclosed; it is not evidence of observed silence.
padSamples = max(0,fs-size(mono,1));
mono = [mono; zeros(padSamples,1)];
metadata.PaddingSeconds = padSamples/fs;
end
