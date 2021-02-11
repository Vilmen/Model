function signal_with_noise = Channel(constellation,EbN0_dB,EbN0min,EbN0max,modData,sps)
k = log2(constellation); %Нужно для SNR в дБ
modData_with_awgn = zeros((abs(EbN0min)+abs(EbN0max)+1),size(modData,1)); %Инициализируем массив промодулированных данных с шумом
signal_with_noise = zeros((abs(EbN0min)+abs(EbN0max)+1),size(modData,1));
for i = EbN0min:EbN0max
    %Внимание! Из snr вычитаем логарифм от коэффициента передискретизации
    snrdB = EbN0_dB(i+(abs(EbN0min)+1)) + 10*log10(k) - 10*log10(sps);

    modData_with_awgn(i+(abs(EbN0min)+1),:) = awgn(modData,snrdB,'measured'); %Добавляем к модулированным данным нашим созвездием белый Гауссоввый шум определённого уровня (он определяется значением счётчика цикла)

    
end
signal_with_noise = signal_with_noise + modData_with_awgn;
end