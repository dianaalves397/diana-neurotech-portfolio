function metrics = binary_metrics(truth,predicted)
%BINARY_METRICS File-level metrics; undefined divisions return NaN.
validateattributes(truth,{'logical','numeric'}, ...
    {'vector','nonempty','real','finite','integer','>=',0,'<=',1});
validateattributes(predicted,{'logical','numeric'}, ...
    {'vector','nonempty','real','finite','integer','>=',0,'<=',1});
truth = logical(truth(:));
predicted = logical(predicted(:));
if numel(truth) ~= numel(predicted) || ~any(truth) || ~any(~truth)
    error('babycry:Labels','Equal-length labels with both true classes are required.');
end
tp = sum(truth & predicted); tn = sum(~truth & ~predicted);
fp = sum(~truth & predicted); fn = sum(truth & ~predicted);
metrics = struct('N',numel(truth),'TP',tp,'TN',tn,'FP',fp,'FN',fn, ...
    'Accuracy',(tp+tn)/numel(truth),'Sensitivity',tp/(tp+fn), ...
    'Specificity',tn/(tn+fp),'Precision',safe_ratio(tp,tp+fp), ...
    'F1',safe_ratio(2*tp,2*tp+fp+fn));
metrics.BalancedAccuracy = (metrics.Sensitivity+metrics.Specificity)/2;
end

function value = safe_ratio(numerator,denominator)
if denominator == 0
    value = NaN;
else
    value = numerator/denominator;
end
end
