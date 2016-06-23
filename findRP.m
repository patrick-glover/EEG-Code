function [ meanFlex, fs ] = findRP( data, fs, order, cutoff )
%FINDRP finds where voluntary action is present using EEG and EMG

fs = 5000;

plotTime = [-3 1];

EMGsignal = data(:,2);


plot(EMGsignal);
hold on;
plot(diff(EMGsignal));

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

plot(wristIsFlexing,ones(length(wristIsFlexing),1)*0.1,'g*');

L = length(wristIsFlexing);

disp(L);

%Above code should recognize a spike in EMG, filling WristIsFlexing with x values
%of the beginning of flexion

eeg = data(:,1).*0.0016;

%[b, a] = butter(order, cutoff/2500, 'high');
%eeg = filter(b,a,eeg);

%butter() filter unstable for some reason...

meanEEG = mean(eeg); 
stdEEG = std(eeg);

for i = length(wristIsFlexing):-1:1
    if((wristIsFlexing(i) + round(plotTime(2)*fs-1)) > length(EMGsignal))
        wristIsFlexing(i) = [];
    end
end
%Remove any epochs that go beyond total length of the recording

wristFlexEpochs = [];
for i = 1:length(wristIsFlexing)
       wristFlexEpochs(i,:) = eeg(wristIsFlexing(i)+floor(plotTime(1)*fs+1):wristIsFlexing(i)+floor(plotTime(2)*fs));
end
%Fills array with epochs centered around the onset of EMG



numberOfFlexEpochs = size(wristFlexEpochs,1);

figure;

for i=1:numberOfFlexEpochs
   temp = (wristFlexEpochs(i,:)*1.2)-mean(wristFlexEpochs(i,:)) + i*stdEEG;
   plot(temp, 'b');
   hold on;
end

figure;
yMat = [];
xMat = [];
for i = 1:numberOfFlexEpochs
    yMat = [yMat;linspace(1,size(wristFlexEpochs,2), size(wristFlexEpochs,2))];
    xMat = [xMat; i*ones(1,size(wristFlexEpochs,2))];
end
for i=1:numberOfFlexEpochs
plot3(xMat(i,:), yMat(i,:), wristFlexEpochs(i,:));
hold on;
end

%wristFlexEpochs(find(min(wristFlexEpochs, [], 2) < (meanEEG-2*stdEEG)),:)=[];
%wristFlexEpochs(find(min(wristFlexEpochs, [], 2) > (meanEEG-2*stdEEG)),:)=[];

%remove outliers

t = linspace(plotTime(1), plotTime(2), (plotTime(2)-plotTime(1))*fs);




figure;
xflip = [t(1 : end - 1) fliplr(t)];

%[plotTime(1) plotTime(2) min(min(wristFlexEpochs)) max(max(wristFlexEpochs))]

axis([plotTime(1) plotTime(2) min(min(wristFlexEpochs)) max(max(wristFlexEpochs))]);
%Above line is included because otherwise the plot window is not scaled to
%the data being plotted.

%for i = 1:size(wristFlexEpochs(:, i))
%    flexArray = wristFlexEpochs(i,:);
%    yflip = [flexArray(1 : end - 1) fliplr(flexArray)];
%    %patch(xflip, yflip, 'r', 'EdgeAlpha', 0.1, 'FaceColor', 'none');
%    hold on;
%end



meanFlex = mean(wristFlexEpochs) - mean(mean(wristFlexEpochs));
mlineFlex = plot (t, meanFlex, 'g', 'LineWidth',3);




title('Neural response to voluntary action');
xlabel('Time (s)');
ylabel('Response (Volts)');
%Labels the plot the axes and title.

end