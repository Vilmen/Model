%Функция, делающая децимацию
function signal_down = Decimation(signal, M)

signal_down = zeros(size(signal,1),size(signal,2)/M); %Инициализируем уменьшенный в M раз массив
for a = 1:size(signal,1)
for i = 1:size(signal_down,2)
    signal_down(a,i) = signal(a,i*M);
end
end
end