# Como reproduzir o projeto

Este documento explica como preparei e executei o **Baby Cry Analyzer** e como qualquer pessoa pode testar o projeto no MATLAB.

O programa recebe um ficheiro WAV, prepara o áudio para a YAMNet e apresenta as categorias sonoras com maior pontuação. O processamento é feito localmente no computador.

## 1. O que é necessário

Para executar o projeto usei:

- MATLAB R2024a ou mais recente;
- Audio Toolbox;
- Deep Learning Toolbox;
- rede pré-treinada YAMNet da MathWorks;
- um ficheiro de áudio em formato WAV.

A YAMNet pode ser carregada no MATLAB com:

```matlab
[net,classes] = audioPretrainedNetwork("yamnet");
```

Se a rede ainda não estiver instalada, o próprio MATLAB apresenta a opção para instalar os ficheiros necessários.

## 2. Preparar o projeto

Depois de descarregar ou clonar o repositório, abrir no MATLAB a pasta:

```text
projects/baby-cry-analyzer
```

Em seguida, adicionar a pasta que contém o código:

```matlab
addpath('matlab');
```

A partir daqui o programa já pode ser executado.

## 3. Executar a análise

A forma mais simples é escrever:

```matlab
result = baby_cry_detector;
```

É aberta uma janela para escolher o ficheiro WAV.

Também é possível indicar diretamente o caminho do áudio:

```matlab
result = baby_cry_detector('C:/dados/exemplo.wav');
```

Para consultar o ranking das categorias obtidas:

```matlab
result.Ranking
```

## 4. O que acontece ao áudio

Organizei o código em várias funções para separar cada etapa do processamento.

O funcionamento é o seguinte:

1. o programa confirma que o ficheiro existe e que é WAV;
2. lê as informações do áudio e as respetivas amostras;
3. se existirem vários canais, converte o áudio para mono através da média dos canais;
4. se o áudio tiver menos de 1 segundo, completa o sinal com zeros;
5. utiliza `yamnetPreprocess` para preparar o áudio para a YAMNet;
6. executa a rede pré-treinada;
7. calcula a pontuação média de cada categoria ao longo dos segmentos analisados;
8. ordena as categorias e apresenta as cinco com maior pontuação;
9. apresenta também a pontuação da categoria `Crying, sobbing`.

Na versão atual usei 50% de sobreposição no pré-processamento e a inferência é feita em CPU.

## 5. Ficheiros aceites

Para manter o funcionamento do programa previsível, defini algumas verificações na entrada:

- apenas ficheiros WAV;
- frequência de amostragem igual ou superior a 16 kHz;
- duração máxima de 300 segundos;
- amostras de áudio válidas dentro do intervalo esperado pelo MATLAB.

O programa não normaliza automaticamente o volume nem remove silêncio antes da análise.

## 6. Estrutura do código

Os principais ficheiros MATLAB são:

| Ficheiro | Função |
| --- | --- |
| `baby_cry_detector.m` | inicia a análise e apresenta os resultados |
| `analyze_file.m` | coordena a leitura, pré-processamento e inferência |
| `prepare_audio.m` | prepara e valida o áudio |
| `summarize_scores.m` | calcula e organiza as pontuações |
| `binary_metrics.m` | contém funções de cálculo de métricas |
| `evaluate_dataset.m` | permite analisar conjuntos de WAV organizados por classes |

Esta separação tornou o projeto mais simples de testar e de alterar sem colocar toda a lógica num único script.

## 7. Testar se o código está a funcionar

Incluí testes para verificar partes principais do processamento.

Na pasta do projeto executar:

```matlab
testResults = runtests('tests/test_core.m');
assertSuccess(testResults);
```

Também existe um teste de integração com a YAMNet:

```matlab
addpath('tests');
smoke_yamnet;
```

Se estes testes terminarem sem erros, as principais funções do projeto estão a ser executadas corretamente no ambiente instalado.

## 8. Resultados que obtive

Para testar o projeto utilizei duas gravações de choro infantil, uma gravação predominantemente silenciosa e uma gravação da minha voz.

Os resultados que registei estão no ficheiro:

```text
results/exploratory-observations.csv
```

Os áudios usados nesses testes não estão incluídos no repositório. Por isso, quem descarregar o projeto pode reproduzir o mesmo procedimento com outros ficheiros WAV, mas não necessariamente obter exatamente os mesmos valores que obtive nos meus testes.

## 9. Problemas mais comuns

### A YAMNet não é encontrada

Executar:

```matlab
[net,classes] = audioPretrainedNetwork("yamnet");
```

e seguir a indicação do MATLAB para instalar a rede caso seja necessário.

### O MATLAB não encontra as funções do projeto

Confirmar que a pasta atual é `projects/baby-cry-analyzer` e executar novamente:

```matlab
addpath('matlab');
```

### O ficheiro WAV não é aceite

Confirmar a extensão, a duração e a frequência de amostragem do áudio.

### O resultado é diferente do meu

As pontuações podem variar se forem utilizados outros áudios ou versões diferentes do MATLAB, das toolboxes ou da rede. O objetivo deste documento é permitir repetir o procedimento do projeto e perceber como o código foi executado.
