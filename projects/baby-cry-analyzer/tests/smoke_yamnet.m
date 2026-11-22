function smoke_yamnet
%SMOKE_YAMNET Real inference on temporary synthetic silence, not accuracy.
oldPath = path;
restorePath = onCleanup(@() path(oldPath)); %#ok<NASGU>
addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))),'matlab'));
filename = [tempname '.wav'];
cleanup = onCleanup(@() remove_temp(filename)); %#ok<NASGU>
audiowrite(filename,zeros(32000,1),16000);
r = analyze_file(filename);
assert(r.FrameCount >= 1);
assert(height(r.Ranking) == 521);
assert(isfinite(r.CryScore) && r.CryScore >= 0 && r.CryScore <= 1);
assert(~isfield(r,'Filename'));
disp('YAMNet smoke test passed. This is not a detection benchmark.');
end

function remove_temp(filename)
if isfile(filename), delete(filename); end
end
