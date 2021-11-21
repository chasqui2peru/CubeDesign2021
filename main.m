%Cargamos los datos
clc;clear;
load("main.mat");
deploy_antennas= nominal.getElement(1);
dep=deploy_antennas.Data;
batery=nominal.getElement(7);
tiempo=nominal.get(1).Time;
latitud=nominal.getElement(3);
longitud=nominal.getElement(4);

visFila=zeros(17281,1);
visibilidad=timeseries(visFila,tiempo);




tel=zeros(17281,1)-1;
%%%%Creamos los telecomandos y el plan de vuelo:
telecomandos=timeseries(tel,tiempo);

for i=1:1000
    telecomandos.data(500+i)=2;%Entrada al modo nominal
    telecomandos.data(2000+i)=4;%Entrada al modo transmitiendo
    %De ahi vuelve al estado nominal
end
for i=1:100
        telecomandos.data(4140+i)=4;
        telecomandos.data(10000+i)=3;
end
%Definimos la visibilidad de la estación trabajando con una longitud
% y latitud a partir de la cual
longCero=longitud.data(2000);
latCero=latitud.data(2000);
longVisible=longitud.data(2000:2120);
latVisible=latitud.data(2000:2120);


latMax=max(abs(latVisible));
latMin=min(abs(latVisible));

longMax=max(abs(longVisible));
longMin=min(abs(longVisible));

for i=1:17280
    if latitud.data(i)>latMin && latitud.data(i)<latMax && longitud.data(i)>longMin && longitud.data(i)<longMax
        visibilidad.data(i)=1;
    end
%     if longitud.data(i)>longMin && longitud.data(i)<longMax
%         visibilidad.data(i)=1;
%     end

end

subplot(2,1,1);
plot(deploy_antennas);
ylabel("Deploy")
xlabel("Tiempo(s)");
title("Despliegue de antenas");
subplot(2,1,2);
plot(visibilidad)
xlabel("Tiempo(s)");
ylabel("Visible")
title("Visibilidad de la estación")

figure
geoplot([latMin latMax],[longMax longMin],'-*')
figure 
plot(batery,'-o')
title("Voltaje de la batería")
ylabel("Voltaje(V)")
xlabel("Tiempo(s)");
open_system('mainStateflow.slx') 
sim('mainStateflow.slx',86400)
%Guardamos los datos
save salidas.mat batery longVisible latVisible telecomandos  visibilidad;
clearvars -except telecomandos;clc;
