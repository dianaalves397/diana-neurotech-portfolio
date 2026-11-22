function result = summarize_scores(scores,classes)
%SUMMARIZE_SCORES Mean frame scores; fixed top-class cry decision.
validateattributes(scores,{'double','single'}, ...
    {'2d','real','finite','nonempty','>=',0,'<=',1});
classes = string(classes(:));
if size(scores,2) ~= numel(classes) || numel(unique(classes)) ~= numel(classes)
    error('babycry:ScoreShape','Expected frames-by-unique-classes scores.');
end
cryIndex = find(classes == "Crying, sobbing");
if numel(cryIndex) ~= 1
    error('babycry:MissingClass','Expected the class Crying, sobbing.');
end
means = mean(double(scores),1)';
[topScore,topIndex] = max(means); % MATLAB returns the first index on a tie.
[ordered,index] = sort(means,'descend');
result.TopClass = classes(topIndex);
result.TopScore = topScore;
result.CryScore = means(cryIndex);
result.IsCryTopClass = result.TopClass == "Crying, sobbing";
result.FrameCount = size(scores,1);
result.Ranking = table(classes(index),ordered, ...
    'VariableNames',{'Class','MeanScore'});
end
