function signal_with_noise = Channel(constellation,EbN0_dB,EbN0min,EbN0max,modData)
k = log2(constellation); %Нужно для SNR в дБ
modData_with_awgn = zeros((abs(EbN0min)+abs(EbN0max)+1),size(modData,1)); %Инициализируем массив промодулированных данных с шумом
signal_with_noise = zeros((abs(EbN0min)+abs(EbN0max)+1),size(modData,1));
for i = EbN0min:EbN0max
    snrdB = EbN0_dB(i+(abs(EbN0min)+1)) + 10*log10(k);
    if(size(modData,1)==2000)
    modData_with_awgn(i+(abs(EbN0min)+1),:) = awgn(modData,snrdB,'measured'); %Добавляем к модулированным данным нашим созвездием белый Гауссоввый шум определённого уровня (он определяется значением счётчика цикла)
    else
    modData_with_awgn(i+(abs(EbN0min)+1),:) = awgn(modData,snrdB/sqrt(2),'measured');
    end
    %modData_with_awgn(i+(abs(EbN0min)+1),:) = my_awgn(snrdB,modData);
end
signal_with_noise = signal_with_noise + modData_with_awgn;
end