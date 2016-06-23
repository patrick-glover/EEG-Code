FileNameStr = 'BYB_Recording_2016-06-20_15.48.07.wav'; %Make sure file is in current folder
[rundata fs] = audioread(FileNameStr);
fileName = regexprep(FileNameStr,'_',' ');
TitleString = sprintf('Neural responses to voluntary action: %s', fileName);

order = 4;
cutoff = 0.5;

[meanRP, fs2] = findRP(rundata, fs, order, cutoff);
[mcMeanArray, mcMean, mcStd, mcStdArray, montecarlo] = MonteCarloSimulationRP( rundata, fs , order, cutoff);
%Run findRP and MonteCarloSimulationRP

plotTime = [-3 1];

maxLimit = 0;
minLimit = 0;

stdValue = 2;

t = linspace( plotTime(1), plotTime(2), length(meanRP) );

for i=1:length(meanRP)
    latency(i) = i*2-length(meanRP);
end

if(max(meanRP) > mcMean+stdValue*mcStd)
    maxLimit = max(meanRP);
end
if(max(meanRP) < mcMean+stdValue*mcStd)
    maxLimit = mcMean+stdValue*mcStd;
end

if(min(meanRP) < mcMean-stdValue*mcStd)
    minLimit = min(meanRP);
end
if(min(meanRP) > mcMean-stdValue*mcStd)
    minLimit = mcMean-stdValue*mcStd;
end
%Establish dimensions for graph based on max/min of data

figure;
axis([plotTime(1) plotTime(2) min(min(montecarlo)) max(max(montecarlo))]);
hold on;

plot(t, montecarlo, 'Color', [0.5 0.5 0.5]);
plot(t, meanRP, 'b', 'LineWidth', 2);
hold off;


figure;
axis([plotTime(1) plotTime(2) (minLimit-.0001) (maxLimit+.0001)]);
%Above line is included because otherwise the plot window is not scaled to
%the data being plotted.

hold on;
plot(t, meanRP, 'g');
plot(t, mcMeanArray , 'b');

%hline(mcMean+stdValue*mcStd,'b:','95% CI');
%hline(mcMean-stdValue*mcStd,'b:','95% CI');
plot(t, (mcStdArray .*2) + mcMean, 'b:');
plot(t, (ones(1, length(mcStdArray)).*mcMean) - (mcStdArray .*2), 'b:');



%Confidence intervals are 2 SD in either direction from Monte Carlo mean

vline((0),'k:','Action onset');
title(TitleString);
xlabel('Time (s)');
ylabel('Response (Volts)');

legend('RP','Monte Carlo');
set(legend,'Location','NorthWest');
hold off;

