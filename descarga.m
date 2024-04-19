    % Parâmetros da bateria
capacidade_total = 2.2;  % Capacidade total da bateria em mAh
soc_inicial = 1;         % Estado de Carga inicial

%arquivo = '2024-02-15_07-58-21.txt';  %% Descarga com carga variada
%arquivo = '2024-03-05_12-48-37.txt';  % Descarga com carga variada 05/03
%arquivo = 'DES_2024-03-12_10-25-40.txt'; %% Descarga com 1A
%arquivo = '2024-04-01_12-05-08.txt';     %% Descarga com 1.5A
%arquivo = '2024-04-02_12-47-36.txt';     %% Descarga com 0.5A
arquivo  = '2024-04-03_13-11-40.txt';     %% Descarga com 2A

# Lê os arquivos
dados = dlmread(arquivo, ':');
corrente = abs(dados(:, 1));
tensao = abs(dados(:,2));
millis = abs(dados(:,3));

tam = length(corrente);

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

     %deltaT = trapz(horas(i-1:i), corrente(i-1:i));  % Trapezoidal integration
     soma_carga = soma_carga + abs(corrente(i)) * deltaT;

     %soc(i) = soc_inicial - (1/3600)*(soma_carga/capacidade_total);
     soc(i) = soc(i-1) - (1/3600)*(soma_carga/capacidade_total);
     soc(i) = max(0, min(1, soc(i)));

end

corrente = corrente';

tam1 = length(corrente);

soma = 0;

%Soc através do OCV
SoC_OCV = ((tensao - 2.6) / (4.2 - 2.6)) * 100;

tam = length(SoC_OCV);

% Plota a corrente e o SoC simulado
figure;

subplot(2, 1, 1);
plot(horas, SoC_OCV, 'b', 'LineWidth', 1.5);
title('Simulação do método OCV');
xlabel('Tempo (h)');
ylabel('SoC (%)');
grid on;

subplot(2, 1, 2);
plot(horas, 100*soc, 'r', 'LineWidth', 1.5);
title('Simulação do Método de Contagem de Coulomb');
xlabel('Tempo (h)');
ylabel('SoC (%)');
grid on;
