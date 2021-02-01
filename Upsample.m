%Функция, делающая передискретизацию
function signal_up = Upsample(signal, M)
signal_up = zeros(1,size(signal,1)*M); %Инициализируем увеличенный в M раз массив
for i = 1:size(signal,1)
    signal_up(i*M) = signal(i);
end
signal_up = transpose(signal_up);
end