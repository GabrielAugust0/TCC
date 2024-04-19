// Variáveis Constantes
const int CURRENT_PIN = 35;   // GPIO que irá sensoriar a corrente da bateria
const int VOLTAGE_PIN = 34;   // GPIO que irá sensoriar a tensão da bateria
const int RS = 10;            // Valor do resistor shunt
const int VOLTAGE_REF = 3.3;  // Tensão de referência para o conversor AD
const int tempo = 1000;       // Tempo para realizar uma nova aquisição de dados

// Variáveis globais
float sensorCorrente, sensorTensao;    // Variável que irá armazenar os dados pós conversor AD
String dados = "<";                    // String onde todos as informações serão armazenadas
float sum = 0, sum1 = 0, correnteFinal = 0, tensaoFinal = 0;
int tempoAtual = 0;

float ajuste_convAD(int data){

  return ( (2.3*pow(10,-8)*pow(data,3)) + (8.7*pow(10,-5)*pow(data,2)) + 1.016*data + 139.59); 
}

float ajuste_ina(float data){

  return 1.11*data + 0.11;
}

void setup() {

  // Inicializa o monitor serial
  Serial.begin(115200);

}

void loop() {

  sum = 0;
  sum1 = 0;

  if( (millis() - tempoAtual) > tempo){

    // Aquisição de 200 amostras para realizar a média
    for(int i = 0; i < 200; i++){

       sensorCorrente = ajuste_convAD(analogRead(CURRENT_PIN));
       sensorTensao   = ajuste_convAD(analogRead(VOLTAGE_PIN));
       sum  = sum + sensorCorrente;
       sum1 = sum1 + sensorTensao;
    }

    // Ajuste corrente 
    sensorCorrente = sum/200.0;
    sensorCorrente = (sensorCorrente * VOLTAGE_REF) / 4096.0;
    sensorCorrente = sensorCorrente / (10 * RS);  // Equação fornecida pelo datasheet do INA169
    correnteFinal = ajuste_ina(sensorCorrente);   // Ajuste realizado em cima da equação

    // Ajuste tensão
    sensorTensao = sum1/200.0;
    tensaoFinal = (sensorTensao * VOLTAGE_REF) / 4096.0;

    // Construção da string
    dados.concat(correnteFinal);
    dados.concat(":");
    dados.concat(tensaoFinal);
    dados.concat(":");
    dados.concat(millis());
    dados.concat(">");

    // Envio pela porta serial
    Serial.print(dados); 
    dados = "<";
    
    tempoAtual = millis();
    
  }

}
