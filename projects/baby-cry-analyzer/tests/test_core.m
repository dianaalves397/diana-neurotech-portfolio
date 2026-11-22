function tests = test_core
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
folder = fullfile(fileparts(fileparts(mfilename('fullpath'))),'matlab');
testCase.TestData.OldPath = path;
addpath(folder);
end

function teardownOnce(testCase)
path(testCase.TestData.OldPath);
end

function testMeanAcrossFrames(testCase)
r = summarize_scores([0.7 0.2 0.1; 0.1 0.8 0.1], ...
    ["Crying, sobbing","Speech","Silence"]);
verifyEqual(testCase,r.CryScore,0.4,'AbsTol',1e-12);
verifyEqual(testCase,r.TopClass,"Speech");
verifyFalse(testCase,r.IsCryTopClass);
verifyEqual(testCase,r.FrameCount,2);
end

function testSingleFrameAndTie(testCase)
r = summarize_scores([0.5 0.5],["Speech","Crying, sobbing"]);
verifyEqual(testCase,r.TopClass,"Speech");
verifyFalse(testCase,r.IsCryTopClass);
end

function testBadScores(testCase)
verifyError(testCase,@() summarize_scores([0.2;0.8], ...
    ["Speech","Crying, sobbing"]),'babycry:ScoreShape');
verifyError(testCase,@() summarize_scores([0.2 0.8], ...
    ["Speech","Silence"]),'babycry:MissingClass');
end

function testStereoAndPadding(testCase)
[x,meta] = prepare_audio([0.2 -0.2;0.4 0.4],16000);
verifySize(testCase,x,[16000 1]);
verifyEqual(testCase,x(1:2),[0;0.4],'AbsTol',1e-12);
verifyEqual(testCase,meta.OriginalChannels,2);
verifyEqual(testCase,meta.PaddingSeconds,15998/16000);
end

function testSilenceStaysZero(testCase)
[x,meta] = prepare_audio(zeros(32000,1),16000);
verifyEqual(testCase,x,zeros(32000,1));
verifyEqual(testCase,meta.PaddingSeconds,0);
end

function testMetrics(testCase)
m = binary_metrics([1 1 1 0 0],[1 0 1 1 0]);
verifyEqual(testCase,[m.TP m.TN m.FP m.FN],[2 1 1 1]);
verifyEqual(testCase,m.Accuracy,0.6,'AbsTol',1e-12);
verifyEqual(testCase,m.Sensitivity,2/3,'AbsTol',1e-12);
verifyEqual(testCase,m.Specificity,0.5);
m = binary_metrics([1 0],[0 0]);
verifyTrue(testCase,isnan(m.Precision));
verifyEqual(testCase,m.F1,0);
verifyError(testCase,@() binary_metrics([1 1],[1 0]),'babycry:Labels');
end
