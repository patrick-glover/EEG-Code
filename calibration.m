FileNameStr = 'BYB_Recording_2016-06-21_15.40.36.wav'; %Make sure file is in current folder
[rundata fs] = audioread(FileNameStr);

testSignal = rundata;
figure;
avgSignal = mean(testSignal);
plot((testSignal-avgSignal).* 0.0016);

