import serial
import time
import datetime

# Configurações da String
beginString = '<'
endString = '>'
tempo = datetime.datetime.now()
nomeArquivo = tempo.strftime("%Y-%m-%d_%H-%M-%S") + ".txt" # Grava o arquivo com a data e hora correspondente ao começo da aquisição dos dados

def read():
    global endString
    global beginString
    keyChars = "<>"
    message = ''

    while (esp32.inWaiting() > 0):
        message += esp32.readline(1).decode() # Transforma em string
    
    # Retira os caracteres de marcação e grava os dados no txt, pula para a próxima linha...
    if (beginString in message and endString in message): 
        for character in keyChars:
                message = message.replace(character, "")
        #print (message)
        arquivo.write(message+"\r\n")
        esp32.reset_input_buffer()
    
# Configurações da comunicação serial. Utilizar mesma porta e baudRate da IDE
esp32 = serial.Serial(port='COM5', baudrate=115200)
print(nomeArquivo)
while(True):
        
  arquivo = open(nomeArquivo, "a")
  time.sleep(0.1)  # Tempo em segundos
  read()           # Chama a função para ler os dados
  arquivo.close()