function [metrics,results] = evaluate_dataset(rootFolder)
%EVALUATE_DATASET Optional future evaluation; does not save or publish data.
% rootFolder/choro and rootFolder/nao_choro must each contain WAV files.
arguments
    rootFolder (1,1) string
end
folders = ["choro","nao_choro"];
truth = false(0,1); predicted = false(0,1);
cryScore = zeros(0,1); topClass = strings(0,1);
for c = 1:2
    folder = fullfile(rootFolder,folders(c));
    listing = dir(folder);
    listing = listing(~[listing.isdir]);
    isWav = endsWith(string({listing.name}),'.wav','IgnoreCase',true);
    files = listing(isWav);
    if isempty(files)
        error('babycry:EmptyDataset','Each label folder must contain WAV files.');
    end
    [~,order] = sort(string({files.name}));
    files = files(order);
    for k = 1:numel(files)
        % Any read/inference error aborts evaluation: no silent exclusions.
        r = analyze_file(fullfile(files(k).folder,files(k).name));
        truth(end+1,1) = (c == 1); %#ok<AGROW>
        predicted(end+1,1) = r.IsCryTopClass; %#ok<AGROW>
        cryScore(end+1,1) = r.CryScore; %#ok<AGROW>
        topClass(end+1,1) = r.TopClass; %#ok<AGROW>
    end
end
metrics = binary_metrics(truth,predicted);
results = table((1:numel(truth))',truth,predicted,cryScore,topClass, ...
    'VariableNames',{'LocalIndex','TrueCry','PredictedCry','CryScore','TopClass'});
disp(metrics);
end
