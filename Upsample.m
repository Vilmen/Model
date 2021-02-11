%Функция, делающая передискретизацию
%signal - передаваемые точки во временной области (или в частотной после модуляции???)
%sps (Samples per symbol) - во сколько раз будет передискретизован сигнал
function [signal_up,rrcFilter] = Upsample(signal, sps, filtlen)
%Старая версия без фильтра
%Сначала дополняем сигнал нулевыми отсчётами
%signal_up = zeros(1,size(signal,1)*sps); %Инициализируем увеличенный в M раз массив
%for i = 1:size(signal,1)
    %signal_up(i*sps) = signal(i);
%end
%signal_up = transpose(signal_up);%

%Делаем передискретизацию, после чего используем фильтр нижних частот, чтобы уменьшить явление алиасинга (наложение спектров)
%RRC (Root-raised-cosine filter)
rolloff = 0.2;     % Rolloff factor

rrcFilter = rcosdesign(rolloff, filtlen, sps); %Generate the square-root, raised cosine filter coefficients.
%fvtool(rrcFilter,'Analysis','Impulse'); %Импульсная характеристика фильтра
signal_up = upfirdn(signal, rrcFilter, sps); %Upsample and filter the data for pulse shaping.
end