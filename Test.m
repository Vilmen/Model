%BER - Bit Error Rate. Частота ошибок по битам,  характеризует количество
%битовых ошибок в единицу времени. Это количество битовых ошибок, деленное
%на общее число переданных битов в течение исследуемого периода времени.
%Коэффициент ошибок является безразмерной величиной и часто выражается в
%процентах.
clear all;
clc;
%% Конфигурация
constellation = 64; %Задаём размерность созвездия (2,4,16,64)
N_IQpoints = 2000; %Количетво точек, которые мы будем передавать через канал
M_upsample = 4; %Велечина, на которуюмы будем передискретизовывать сигнал (от 4 до 5)
filter_length = 31; %Длина КИХ-фильтра. ВНИМАНИЕ! Количество коэффициентов больше на 1
test_number = 5; %Так как в эквалайзире в рамках тестирования мы рассматриваем только один уровень шума, то для выбора конкретной передачи ч конкретным уровнем шума используется эта переменная

%Пределы отношения Eb к No 
EbN0min = -2; %Минимальный
EbN0max = 14; %Максимальный
EbN0_dB = (EbN0min:EbN0max)'; %Массив со значения шума в дБ (в количестве |EbN0min|+|EbN0max|+1 (единица берётся из-за ноля))
EbN0 = 10.^(EbN0_dB/10); %Значения шума в разах (в количестве 41)
%% Передатчик
arrange_constellation = (0:constellation-1)'; %Создаём вертикальный массив, который будем использовать для создания созвездия
points = qammod(arrange_constellation,constellation); %Создаём созвездие (вертикальный массив комплексных ненормированных точек)

data = randi([0 constellation-1],N_IQpoints,1); %Гененрируем случайным образом точки (такого размера, чтобы они не вывались за размеры созвездия), которые будем модулировать нашим созвездием

modData = genqammod(data,points); %Модулируем сгенерированные точки нашим созвездием

modData_with_upsample = Upsample(modData, M_upsample); %Передискретизованный сигнал на величину M
%% Канал
signal_with_noise = Channel(constellation,EbN0_dB,EbN0min,EbN0max,modData);
signal_with_noise_up = Channel(constellation,EbN0_dB,EbN0min,EbN0max,modData_with_upsample);
%% Приёмник
demodData = Rx(EbN0min,EbN0max,points,signal_with_noise);

modData_with_downsample = Decimation(signal_with_noise_up, M_upsample);
demodData_up_down = Rx(EbN0min,EbN0max,points,modData_with_downsample);
%% Анализ данных
%==========================================================================
%Считаем BER и SER
[BER,~] = Calculate_BER_SER(EbN0min,EbN0max, data, demodData); %Вычислим BER и SER до передискретизации
[BER_up_down,~] = Calculate_BER_SER(EbN0min,EbN0max, data, demodData_up_down);
BER_theor = berawgn(EbN0_dB,'qam',constellation);
%==========================================================================
%Эквалайзер
%ВНИМАНИЕ! Подразумевается, что фильтр знает и отправленный (без шумов), и принятый (с шумами) сигналы
d = floor((filter_length-1)/2);
a = zeros(size(modData,1),filter_length);
for i = 1:filter_length
    if i<d
        a(:,i) = circshift(modData, (-d+i));
    elseif i==d
        a(:,i) = modData;
    else
        a(:,i) = circshift(modData, (-d+i));
    end 
end
a = transpose(a);
a_MP = pinv(a);
h = conv(a_MP(:,test_number),modData_with_downsample(test_number,:), 'same');
%Делаем произведение данных вышедших из приёмника на передаточную функцию
%КИХ-фильтра
%y = conv(demodData_up_down(:,1),v, 'same');
%==========================================================================
%Построение графиков
figure(1);
semilogy(EbN0_dB,[BER_theor BER])
title(['Без передискретизации и децимации ',num2str(constellation),'-QAM']);
legend('BER theory', 'BER');
xlabel('Eb/No (dB)');
ylabel('BER');
grid;

figure(2);
semilogy(EbN0_dB,[BER_theor BER_up_down])
title(['После передискретизации и децимации ',num2str(constellation),'-QAM']);
legend('BER theory', 'BER');
xlabel('Eb/No (dB)');
ylabel('BER');
grid;