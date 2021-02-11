%Функция, делающая децимацию
%signal - передискретизованный сигнал с шумом (пока только awgn)
%sps (Samples per symbol) - во сколько раз будет децимирован сигнал
function signal_down_cut = Decimation(signal, sps, rrcFilter, filtlen)

%Старая версия без фильтра
%signal_down = zeros(size(signal,1),size(signal,2)/M); %Инициализируем уменьшенный в M раз массив
%for a = 1:size(signal,1)
%for i = 1:size(signal_down,2)
%    signal_down(a,i) = signal(a,i*M);
%end
%end%
for i = 1:size(signal,1)
signal_down(i,:) = upfirdn(signal(i,:), rrcFilter, 1, sps);
signal_down_cut(i,:) = signal_down(i,filtlen + 1:end - filtlen); % Account for delay
end

end