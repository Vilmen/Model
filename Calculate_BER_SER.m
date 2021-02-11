function [BER,SER] = Calculate_BER_SER(EbNomin,EbNomax,data,demodData)
SER = zeros(1,(abs(EbNomin)+abs(EbNomax)+1)); %Инициализируем массив, содержащий отношениея количеств ошибок к количеству передаваемых точек
BER = zeros(1,(abs(EbNomin)+abs(EbNomax)+1));


for i = EbNomin:EbNomax %Цикл, перебирающий разные значения шума и считающий количество неправильно принятых бит для задданого уровня шума
%Вычисление количества ошибок символа (numErrors) и коэффициента ошибок символа (BER)
[~, SER(i+(abs(EbNomin)+1))] = symerr(data,demodData(:,i+(abs(EbNomin)+1))); %numErrors показывает, сколько бит принято неверно, BER - отношение numErrors к N - количеству передаваемых точек
[~, BER(i+(abs(EbNomin)+1))] = biterr(data,demodData(:,i+(abs(EbNomin)+1))); 
end

%Поворачиваем матрицы, потому что semilogy почему-то не строит горизонтальные массивы
SER = (SER)';
BER = (BER)';
end