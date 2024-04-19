close all
clear all

% Parâmetros da bateria
capacidade_total = 2.2;  % Capacidade total da bateria em mAh
soc_inicial = 0;         % Estado de Carga inicial

%arquivo = '2024-02-09_09-14-20.txt';    %% Carga com 1A
%arquivo = '2024-02-16_09-04-58.txt';
%arquivo = '2024-02-15_07-58-21.txt';    %% Descarga com carga variada
%arquivo = 'CA_2024-03-06_14-47-26.txt'; %% Carga com 1A
%arquivo = '2024-04-01_09-05-50.txt';    %% Carga com 0.5A
%arquivo = '2024-03-28_17-56-27.txt';    %% Carga com 0.5A
arquivo = '2024-04-02_08-10-24.txt';     %% Carga com 1.5A

# Lê os arquivos
dados = dlmread(arquivo, ':');
corrente = abs(dados(:, 1));
tensao = abs(dados(:,2));
millis = abs(dados(:,3));

corrente = corrente';

# Millisegundos para segundos
seg = millis / 1000;
horas = seg / 3600;
horas = horas';

figure

subplot(2, 1, 1);
plot(horas, tensao, 'r', 'LineWidth', 1.5);
title('Perfil de tensão durante a carga');
xlabel('Tempo (h)');
ylabel('Tensão (V)');
grid on;

subplot(2, 1, 2);
plot(horas, corrente, 'b', 'LineWidth', 1.5);
title('Perfil de durante a carga');
xlabel('Tempo (h)');
ylabel('Corrente (A)');
grid on;

# Parâmetros do metodo
soma_carga = 0;
soc = zeros(size(horas));

soc(1) = soc_inicial;

for i = 2:length(horas)

     deltaT = horas(i) - horas(i-1);
     soma_carga = soma_carga + abs(corrente(i)) * deltaT;

     soc(i) = soc(i-1) + (1/3600)*(soma_carga/capacidade_total);
     soc(i) = max(0, min(1, soc(i)));
end

%Soc através do OCV
SoC_OCV = ((tensao - 2.6) / (4.2 - 2.6)) * 100;

figure;
subplot(2, 1, 1);
plot(horas, 100*soc, 'r', 'LineWidth', 1.5);
title('SoC através do Método de Contagem de Coulomb');
xlabel('Tempo (h)');
ylabel('SoC');
grid on;

subplot(2, 1, 2);
%plot(horas, SoC_OCV, 'r', 'LineWidth', 1.5);
plot(horas, SoC_OCV, 'r', 'LineWidth', 1.5);
title('SoC através do método OCV');
xlabel('Tempo (h)');
ylabel('SoC');
grid on;
