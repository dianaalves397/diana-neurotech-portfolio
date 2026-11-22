# Metodologia de execução e reprodução

## 1. Âmbito da reprodução

É possível reproduzir o procedimento computacional com WAV autorizados e executar os testes de software fornecidos. **Não é possível reproduzir exatamente os quatro valores históricos apenas com este repositório:** não se publicam os áudios, não há hashes disponíveis dos originais e não foi recuperado um registo completo das versões e parâmetros da execução original.

A implementação publicada foi reorganizada a partir do procedimento descrito na conversa. Acrescenta validação, limites de entrada, padding de áudios curtos, CPU explícita e testes; não se afirma identidade byte a byte com o script original. A disponibilidade do código não resolve estas limitações de rastreabilidade.

## 2. Preparar o ambiente

1. Instalar MATLAB R2024a+ com Audio Toolbox e Deep Learning Toolbox.
2. Instalar a rede indicada por `audioPretrainedNetwork("yamnet")`, usando a ligação fornecida pela própria função se necessário. Não adicionar o pacote de pesos ao Git.
3. Abrir a pasta deste projeto e executar `addpath('matlab')`.
4. Registar localmente `version`, `ver` e o commit do repositório. A lista completa de produtos pode ser guardada num registo privado; rever qualquer exportação antes de partilhar.
5. Executar os testes indicados no README. Guardar o resultado real, sem substituir falhas por valores históricos.

## 3. Procedimento fixo

| Etapa | Decisão publicada |
| --- | --- |
| Leitura | `audioinfo` antes de `audioread`; apenas WAV; máximo 300 s |
| Validação | Amostras finitas e reais, [-1,1]; amostragem inteira ≥16 kHz |
| Canais | Média aritmética dos canais, sem normalização de pico |
| Áudio curto | Completar com zeros até 1 s, devolvendo a duração do padding |
| Características | `yamnetPreprocess(mono,fs,OverlapPercentage=50)`; reamostragem interna |
| Modelo | `audioPretrainedNetwork("yamnet")`, sem retreino |
| Inferência | `minibatchpredict`, CPU, lotes de 32, formato de saída `BC` |
| Agregação | Média aritmética de cada classe sobre os segmentos devolvidos |
| Categoria principal | Máximo da média; em empate, primeiro índice da ordem do modelo |
| Pontuação de choro | Média da classe de nome exato `Crying, sobbing` |
| Regra binária | Positivo apenas se essa classe for a categoria principal |

A escolha da média não é a votação maioritária das categorias por segmento. Não se normaliza a amplitude nem se remove silêncio: estas operações poderiam alterar as pontuações e exigiriam uma nova versão do procedimento. O processamento do final do áudio segue a implementação de `yamnetPreprocess` da versão instalada; registar essa versão.

## 4. Registo privado recomendado

Para futuras experiências, guardar um identificador pseudónimo, hash SHA-256 do áudio, origem/licença/consentimento, rótulo e método de anotação, duração, frequência de amostragem, número de canais, data, versão MATLAB/toolboxes/modelo, commit, parâmetros e pontuações. Manter separada a correspondência entre identificador e pessoa. Os hashes e registos não são requisitos para executar o protótipo, mas permitem verificar que duas execuções usaram os mesmos dados.

O programa devolve duração, canais, frequência de amostragem, padding e versão MATLAB; não inclui caminho nem nome de entrada. A identificação dos pesos e a proveniência dos dados devem ser registadas separadamente pelo investigador. O CSV público contém só quatro observações agregadas históricas.

## 5. Diagnóstico de problemas

- **Função não encontrada:** confirmar a pasta atual, `addpath('matlab')`, versão e produtos instalados.
- **Pesos em falta:** seguir a mensagem de `audioPretrainedNetwork` e adicionar a pasta dos pesos ao caminho.
- **Formato de pontuações inesperado:** não transpor às cegas; confirmar as versões e o formato `BC`. O código deve recusar uma matriz incompatível.
- **WAV abaixo de 16 kHz:** a versão publicada recusa-o; uma simples reamostragem não recupera informação perdida. Documentar uma alteração do protocolo se esses dados forem necessários.
- **Memória insuficiente:** usar gravações mais curtas; não eliminar silenciosamente secções para produzir um resultado favorável.
- **Nenhuma previsão de choro:** a precisão positiva fica indefinida (`NaN`); isto não corresponde a 100% de precisão.

## 6. Critérios para uma futura avaliação quantitativa

Fixar a tarefa e a regra antes de observar o conjunto final. Reunir positivos e negativos variados; verificar os rótulos; separar gravações por bebé, pessoa, sessão e fonte; impedir que segmentos do mesmo áudio apareçam em divisões diferentes. Qualquer escolha de limiar deve ocorrer exclusivamente num conjunto de desenvolvimento.

`evaluate_dataset` processa WAV diretamente nas duas pastas, numa ordem determinística por nome. Não faz deteção automática de duplicados, divisão por participante, verificação de consentimento ou intervalos de confiança. Esses controlos continuam a ser responsabilidade do protocolo. Comparar o método com referências simples, apresentar contagens e incerteza, e analisar os erros. Não utilizar os quatro exemplos desta publicação para ajustar um limiar e depois comunicar desempenho como se fossem dados independentes.
