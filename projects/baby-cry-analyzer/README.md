# Baby Cry Analyzer

**Análise acústica exploratória com MATLAB e YAMNet — Diana Alves**

Um projeto que lê um ficheiro WAV local, calcula pontuações por categoria sonora com uma rede pré-treinada e apresenta a categoria com maior pontuação média e a pontuação de `Crying, sobbing`.


[Relatório científico](docs/relatorio-cientifico.md) · [Metodologia e reprodução](docs/reproducao.md) · [Observações em CSV](results/exploratory-observations.csv) · [Portefólio](https://diana-neurotech-portfolio.vercel.app/#baby-cry-analyzer)

## Funcionalidades

- Seleção de WAV ou indicação de caminho local, sem gravação de microfone ou envio de áudio.
- Validação de amostras, conversão de multicanal para mono e preenchimento explícito de entradas curtas.
- Pré-processamento oficial `yamnetPreprocess`, inferência em CPU e média das pontuações dos segmentos.
- Apresentação das cinco categorias mais pontuadas e de `Crying, sobbing`.
- Regra binária fixa para avaliação futura: choro apenas quando a categoria principal é `Crying, sobbing`.

`Crying, sobbing` é uma categoria acústica genérica; não é equivalente à categoria específica `Baby cry, infant cry`. Este projeto mantém a primeira para corresponder ao critério dos resultados históricos. Não combina nem troca estas classes depois de observar os resultados.

## Requisitos

- MATLAB **R2024a ou posterior**, Audio Toolbox e Deep Learning Toolbox.
- Rede YAMNet distribuída pela MathWorks, instalada no caminho do MATLAB.
- Ficheiros WAV com amostragem de pelo menos 16 kHz, duração até 300 s e amostras finitas no intervalo [-1,1]. O limite inferior de amostragem é uma decisão desta implementação para evitar apresentar conteúdo interpolado como informação de alta frequência.
- Internet apenas para instalar dependências/modelo; a análise é local. GPU não necessária.

Na Command Window, executar `[net,classes] = audioPretrainedNetwork("yamnet");`. Se o modelo estiver em falta, seguir a ligação de instalação apresentada pela MathWorks. Instalar os pesos **fora deste repositório**. Ver [documentação oficial](https://www.mathworks.com/help/audio/ref/audiopretrainednetwork.html).

## Início rápido

Descarregar o ZIP do repositório ou cloná-lo e abrir `projects/baby-cry-analyzer` como pasta atual no MATLAB:

```matlab
addpath('matlab');
result = baby_cry_detector; % Abre o seletor de WAV; cancelar devolve [].

% Alternativa sem interface gráfica:
result = baby_cry_detector('C:/dados-privados/exemplo.wav');
result.Ranking
```

## Resultados dos testes

Testei o projeto com duas gravações de choro infantil, uma gravação predominantemente silenciosa e uma gravação da minha voz. A tabela reúne as categorias e pontuações obtidas.

| Teste | Entrada descrita | Categoria principal | Pontuação principal | Pontuação de `Crying, sobbing` |
| --- | --- | --- | ---: | ---: |
| T01 | Choro infantil — rótulo «dor abdominal» | Crying, sobbing | 34,94% | 34,94% |
| T02 | Choro infantil — rótulo «desconforto» | Speech | 24,62% | 8,80% |
| T03 | Gravação predominantemente silenciosa | Silence | 78,34% | 0,11% |
| T04 | Fala da autora | Speech | 63,23% | 0,75% |

T02 evidencia uma falha do critério de categoria principal face à descrição da entrada como choro. T01, T03 e T04 apresentam categorias coerentes com as descrições fornecidas.

## Organização

```text
baby-cry-analyzer/
├── README.md
├── .gitignore
├── matlab/
│   ├── baby_cry_detector.m   # Interface de seleção e apresentação
│   ├── analyze_file.m        # Leitura, pré-processamento e inferência
│   ├── prepare_audio.m       # Validação e preparação das amostras
│   ├── summarize_scores.m    # Média temporal e regra de decisão
│   ├── binary_metrics.m      # Métricas para futura avaliação
│   └── evaluate_dataset.m    # Avaliação opcional de WAV rotulados
├── tests/
│   ├── test_core.m           # Lógica; não requer pesos YAMNet
│   └── smoke_yamnet.m        # Integração real com áudio sintético
├── docs/
│   ├── relatorio-cientifico.md
│   └── reproducao.md
└── results/
    └── exploratory-observations.csv
```

## Verificar o software

```matlab
testResults = runtests('tests/test_core.m');
assertSuccess(testResults);
addpath('tests');
smoke_yamnet;
```

Os testes unitários verificam média temporal, orientação das pontuações, empate, canais, padding e métricas com exemplos construídos. O smoke test verifica inferência real e integridade das saídas.


## Limitações e privacidade

A agregação pela média pode ocultar episódios breves. Fala, outros sons e ruído podem competir com a classe de choro. Há diferenças entre as distribuições de treino e de utilização; a classe genérica não é específica de bebés. Não se validaram causas de choro, precisão clínica ou desempenho em utilização contínua.

Nenhum áudio privado, nome original de gravação, identificador de criança, peso de rede ou dataset é incluído. O `.gitignore` ajuda a evitar adições acidentais, mas não substitui a revisão dos ficheiros antes de publicar. O código não inicia transferências de gravações nem guarda resultados automaticamente.

MATLAB, toolboxes, pesos YAMNet e dados de terceiros mantêm os seus próprios termos. As fontes científicas e técnicas estão indicadas no [relatório](docs/relatorio-cientifico.md#referências).
