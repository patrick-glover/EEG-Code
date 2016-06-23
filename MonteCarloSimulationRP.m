function [ mcMeanArray, mcMean, mcStd, mcStdArray, montecarlo] = MonteCarloSimulationRP( data, fs , order, cutoff)

plotTime = [-3 1];

fs = 5000;

EMGsignal = data(:,2);

%plot(EMGsignal);

counter = 1;
i=1;

wristIsFlexing = [];

while ((i <= length(EMGsignal)-1))
    if(abs(EMGsignal(i+1) - EMGsignal(i)) <= 0.01) %this threshold will need tuning 
        i=i+1;
    else
        wristIsFlexing(counter) = (i-50);
        counter = counter+1; 
        i = i + (fs/2); 
    end        
end
% Fills array with the time where each wrist flex begins

eeg = data(:,1);

%[b, a] = butter(order, cutoff/2500, 'high');
%eeg = filter(b,a,eeg);


meanEEG = mean(eeg); 
stdEEG = std(eeg);

randomSampleBegin = 1+-fs*plotTime(1); 
%Sets the lower bound for the randomly generated data points. This is the
%lowest point at which 1 second of data can be collected around
randomSampleEnd = length(eeg)-fs*plotTime(2);
%Sets the upper bound for the randomly generated data points. This is the
%highest point at which 1 second of data can be collected around 

montecarlo = [];
randomRP = [];

for iMonty = 1:100
    randomSampleTimes = randi(round(randomSampleEnd-randomSampleBegin),length(wristIsFlexing),1)+ round(randomSampleBegin);
    
    for i = 1:length(wristIsFlexing)
           randomRP(i,:) = eeg([randomSampleTimes(i)+round(plotTime(1)*fs)+1:randomSampleTimes(i)+round(plotTime(2)*fs)]);
    end
    
   % randomRP(find(min(randomRP, [], 2) < (meanEEG-2*stdEEG)),:)=[];
   % randomRP(find(max(randomRP, [], 2) > (meanEEG+2*stdEEG)),:)=[];
    
    montecarlo(iMonty,:) = mean(randomRP) - mean(mean(randomRP));
    
end

%sum(sum(isnan(montecarlo)))

mcMeanArray = mean(montecarlo);
mcStdArray = std(montecarlo);

mcMean = sum(mcMeanArray)/length(montecarlo);
mcStd = sum(mcStdArray)/length(montecarlo);

t = linspace( plotTime(1), plotTime(2), size(randomRP,2));


figure;
axis([plotTime(1) plotTime(2) min(min(montecarlo)) max(max(montecarlo))]);

xflip = [t(1 : end - 1) fliplr(t)];

for i = 1:100
    mcArray = montecarlo(i,:);
    yflip = [mcArray(1 : end - 1) fliplr(mcArray)];
    patch(xflip, yflip, 'r', 'EdgeAlpha', 0.1, 'FaceColor', 'none');
    hold on;
end

mline = plot(t, mean(montecarlo),'b','LineWidth',3);
%Plots the mean line of all individual Monte Carlo lines

title('Monte Carlo Points Average');
xlabel('Time (s)');
ylabel('Response (Volts)');
%Labels the plot the axes and title.


end

