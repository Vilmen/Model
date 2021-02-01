%Функция, демодулирующая принятые точки
function demodData = Rx(EbNomin,EbNomax,points,signal)
demodData = zeros(size(signal,2),(abs(EbNomin)+abs(EbNomax)+1)); %Инициализируем массив принятых данных

for i = EbNomin:EbNomax
    demodData(:,i+(abs(EbNomin)+1)) = genqamdemod(signal(i+(abs(EbNomin)+1),:),points); %Демодулируем зашумлённые данные
end
end