# Baby Cry Analyzer: análise acústica exploratória de choro com MATLAB e YAMNet

**Autora:** Diana Alves  
**Tipo de trabalho:** projeto e relatório técnico-científico  
**Data de preparação:** 22 de novembro de 2026  

## Resumo

Este trabalho apresenta um projeto MATLAB para análise de ficheiros WAV com YAMNet pré-treinada. O objetivo é explorar categorias acústicas e a pontuação associada a `Crying, sobbing`, sem inferir a causa do choro. Foram feitos quatro testes para testar o projeto final: duas gravações descritas como choro infantil, uma gravação predominantemente silenciosa e uma gravação de fala da autora. As pontuações de `Crying, sobbing` foram, respetivamente, 34,94%, 8,80%, 0,11% e 0,75%. A categoria principal foi `Crying, sobbing` no primeiro exemplo, `Speech` no segundo e no quarto, e `Silence` no terceiro.

**Palavras-chave:** processamento de áudio; MATLAB; YAMNet; choro infantil; classificação acústica; reprodutibilidade.

## 1. Introdução e objetivos

A análise computacional de áudio permite explorar representações tempo-frequência e redes pré-treinadas em tarefas educativas. A existência de uma categoria relacionada com choro numa rede geral de sons não demonstra, por si só, capacidade de reconhecer todos os choros infantis ou interpretar necessidades de um bebé.

O objetivo primário deste projeto é implementar um percurso transparente entre a leitura de áudio, o pré-processamento, a inferência e a interpretação das pontuações. Os objetivos secundários são documentar os quatro testes já realizados, tornar explícitas as limitações e disponibilizar um procedimento de avaliação que possa ser executado no futuro. Não são objetivos desta versão diagnosticar dor, distinguir fome de sono, emitir alertas clínicos ou apoiar decisões de cuidado.

Numa fase inicial, explorei a classificação de cinco causas do choro. Essa abordagem não ficou validada e decidi concentrar a versão final na análise de categorias acústicas com YAMNet. A classificação de causas não integra as funcionalidades deste projeto.

## 2. Fundamentação técnica

YAMNet é uma rede de classificação de eventos acústicos associada ao AudioSet, com 521 categorias, baseada na arquitetura MobileNet v1 e convoluções separáveis em profundidade [1,4]. O modelo geral fornece uma representação útil para explorar sons, mas o seu domínio de treino não garante adequação a uma tarefa específica de choro infantil.

O pré-processamento de referência utiliza áudio mono a 16 kHz, análise espectral em janelas curtas e representação log-mel. A documentação oficial descreve 64 bandas mel e blocos temporais de 96 quadros [1,2]. Na implementação deste projeto, o pré-processamento é delegado à função da MathWorks, evitando manter uma segunda implementação numérica.

É necessário distinguir a implementação de referência do TensorFlow da distribuição MATLAB: a documentação MathWorks apresenta uma rede com saída `softmax`, enquanto a implementação de referência possui o seu próprio processamento e parametrização [1,3]. Não se assume equivalência numérica entre plataformas, versões ou pesos. Em qualquer caso, apresentar uma pontuação numa escala de 0 a 100 não a transforma numa medida de acerto nem numa probabilidade calibrada para este contexto.

## 3. Materiais e proveniência

Para testar o projeto, utilizei quatro gravações: dois áudios de choro infantil com os rótulos de origem «dor abdominal» e «desconforto», uma gravação predominantemente silenciosa e uma gravação da minha voz. Os rótulos das causas pertencem aos dados de origem; não são previsões produzidas pelo programa.

Selecionei estes exemplos para observar a resposta do programa a choro e a outros sons. Os testes foram exploratórios, sem amostragem aleatória ou anotação independente. Cada linha dos resultados corresponde a uma gravação; os segmentos sobrepostos da rede não são tratados como observações independentes.

Registei as categorias principais e as pontuações apresentadas pelo programa. Os áudios permanecem privados. Não disponho, neste relatório, de um registo completo dos metadados de aquisição e das versões utilizados nos quatro testes, o que limita a reprodução exata dos valores.

## 4. Metodologia da versão publicada

### 4.1. Preparação do sinal

A entrada é um WAV local. O programa verifica a existência, extensão e duração antes de ler as amostras. São admitidas frequências inteiras a partir de 16 kHz e duração máxima de 300 s. As amostras devem ser finitas, reais e estar em [-1,1]. Estes limites são escolhas operacionais do projeto e não critérios clínicos.

Os canais são combinados pela média. Não é aplicada normalização de pico, remoção de silêncio ou filtragem adicional. Áudios com menos de um segundo são completados com zeros e a duração acrescentada é devolvida nos metadados. Este padding torna o processamento operacional, mas pode alterar as pontuações; não representa silêncio observado. A média dos canais também pode atenuar sinais em oposição de fase.

### 4.2. Extração e inferência

`yamnetPreprocess` realiza a preparação de características com sobreposição fixada em 50%. A rede é carregada com `audioPretrainedNetwork("yamnet")`. `minibatchpredict` executa a inferência em CPU, com lotes de 32 e saída explicitamente organizada como segmentos × classes [2,3,5]. Não se realiza retreino ou ajuste de hiperparâmetros aos quatro exemplos.

### 4.3. Agregação e decisão

Seja s(t,c) a pontuação da classe c no segmento t e T o número de segmentos. Define-se:

```text
pontuação_média(c) = (1/T) × soma_t s(t,c)
categoria_principal = argmax_c pontuação_média(c)
pontuação_choro = pontuação_média("Crying, sobbing")
decisão_choro = [categoria_principal == "Crying, sobbing"]
```

Em empate, mantém-se o primeiro índice na ordenação das classes da rede. O critério corresponde à categoria com maior média, não à classe mais frequente entre decisões por segmento. Também não significa que a categoria esteja presente durante toda a gravação.

`Crying, sobbing` e `Baby cry, infant cry` são categorias distintas. Utilizei `Crying, sobbing` como categoria de referência para a pontuação de choro nos quatro testes. Não se substitui a classe nem se somam pontuações após observar uma falha. Uma versão especificamente orientada à deteção de choro infantil exigiria definir antecipadamente outra regra e avaliá-la em dados independentes.

### 4.4. Validação do software e evidência experimental

São fornecidos testes unitários para agregação temporal, empates, matriz incompatível, conversão de canais, padding, silêncio e cálculo de métricas. Um teste de integração usa um WAV de zeros temporário para exercitar a rede, sem publicar gravações. Estes testes verificam contratos do software; não substituem uma avaliação da classificação em sons reais.



## 5. Resultados observados

| ID | Conteúdo descrito | Categoria principal | Pontuação principal | Pontuação de `Crying, sobbing` |
| --- | --- | --- | ---: | ---: |
| T01 | Choro infantil; rótulo de origem «dor abdominal» | Crying, sobbing | 34,94% | 34,94% |
| T02 | Choro infantil; rótulo de origem «desconforto» | Speech | 24,62% | 8,80% |
| T03 | Gravação predominantemente silenciosa | Silence | 78,34% | 0,11% |
| T04 | Fala da autora | Speech | 63,23% | 0,75% |

Apresento os valores com as duas casas decimais que registei durante os testes.

Em T01, a categoria principal é coerente com a descrição de choro, sem demonstrar a causa. Em T02, a regra publicada produziria uma decisão negativa apesar da descrição de choro, constituindo um possível falso negativo face a esse rótulo. T03 e T04 são coerentes, respetivamente, com silêncio e fala, nos exemplos particulares fornecidos.

Não se calcula uma percentagem global de acerto a partir destes quatro casos. A seleção por conveniência, a inexistência de rótulos independentes e a falta de um protocolo pré-definido impedem tratar essa percentagem como uma estimativa de desempenho. A pontuação de 34,94% em T01 não corresponde à precisão do sistema.

## 6. Discussão

Nos quatro testes, o programa produziu categorias e pontuações para as diferentes entradas. O resultado T02 mostra por que motivo execução sem erros e classificação correta são critérios distintos. Uma aplicação pode carregar o áudio e apresentar resultados válidos numericamente, mantendo uma decisão inadequada para a tarefa pretendida.

A média temporal pode reduzir a contribuição de episódios de choro breves num áudio misto. A competição entre categorias, a presença de fala e ruído, a distância ao microfone e diferenças entre dados de treino e utilização são hipóteses plausíveis para erros; não foram isoladas experimentalmente nestes testes. Não se atribui a falha T02 a uma causa acústica específica sem examinar o sinal e as pontuações temporais.

As pontuações baixas de choro em T03 e T04 são observações úteis, mas não demonstram robustez perante outras vozes, línguas, dispositivos, música, televisão ou condições ambientais. Também não sustentam desempenho em tempo real: o sistema publicado analisa ficheiros e não é um monitor contínuo.

## 7. Protocolo de avaliação quantitativa futura

A avaliação permanece **por realizar**. Propõe-se:

1. Definir previamente a tarefa binária, a classe-alvo, o tratamento de misturas e o nível da decisão (gravação ou evento).
2. Reunir áudios de choro e não choro de proveniência autorizada, com diversidade de pessoas, dispositivos, ambientes e fontes. Justificar a dimensão da amostra em função da incerteza pretendida.
3. Obter rótulos verificados, documentar divergências e remover duplicados. Separar participantes, sessões e fontes entre desenvolvimento e teste; não repartir segmentos do mesmo áudio entre conjuntos.
4. Fixar a regra atual ou escolher limiares apenas num conjunto de desenvolvimento separado. Manter o conjunto final fechado até à avaliação.
5. Apresentar a matriz de confusão com contagens e denominadores, juntamente com métricas e intervalos de confiança adequados à dependência entre gravações. Se existirem várias gravações por bebé, considerar essa estrutura na estimativa da incerteza.
6. Comparar com referências triviais, analisar erros e relatar exclusões, falhas de leitura e dados em falta. Não apresentar apenas os casos favoráveis.

Para TP, TN, FP e FN definidos ao nível da gravação:

| Medida | Definição |
| --- | --- |
| Exatidão / accuracy | (TP + TN) / N |
| Sensibilidade / recall | TP / (TP + FN) |
| Especificidade | TN / (TN + FP) |
| Precisão positiva / precision | TP / (TP + FP) |
| F1 | 2TP / (2TP + FP + FN) |
| Exatidão equilibrada | (sensibilidade + especificidade) / 2 |

Denominadores nulos devem ser assinalados como indefinidos. O código de avaliação exige ambas as classes reais, devolve `NaN` quando apropriado e não implementa intervalos de confiança nem controla independência dos dados. Estes aspetos devem ser acrescentados ao protocolo antes de qualquer afirmação de desempenho. Não existem valores observados destas métricas nesta publicação.

## 8. Limitações, privacidade e reprodutibilidade

- Apenas quatro testes exploratórios, sem amostragem representativa ou anotação independente.
- Falta de metadados e artefactos suficientes para reproduzir exatamente os valores reportados.
- Classe de choro genérica, sem validação específica para bebés ou causas de choro.
- Possível perda de eventos breves pela média e influência de padding, canais, ruído e domínio de aquisição.
- Ausência de calibração, análise por subgrupos, intervalos de confiança e validação externa.

Mantive os áudios privados, incluindo a gravação da minha voz. Também não se incluem nomes originais, identificadores de crianças, pesos da rede ou datasets volumosos. Os exemplos sintéticos dos testes são criados temporariamente. Dados futuros exigem autorização e tratamento apropriado à sua origem; rótulos sensíveis e correspondências de identidade devem permanecer em registos privados.

As instruções permitem reproduzir o **procedimento** e testar o **software** com outros WAV autorizados. Não prometem reproduzir os **resultados exatos** sem os originais e o ambiente correspondente. Esta restrição é deliberada e explicitada, preservando a privacidade.

## 9. Conclusão

Com este projeto, implementei um percurso de análise de áudio em MATLAB, desde a leitura de WAV até à apresentação das categorias e pontuações da YAMNet. Testei a resposta a duas gravações de choro, silêncio e fala. O segundo áudio de choro foi classificado principalmente como `Speech`, mostrando uma limitação que deve ser estudada com mais dados. Estes testes permitiram explorar o funcionamento do projeto; uma avaliação quantitativa independente será necessária para estimar o desempenho de deteção.

## Referências

Fontes técnicas consultadas em 22 de novembro de 2026. Os resultados T01–T04 correspondem aos testes que realizei no projeto; as referências seguintes fundamentam os métodos utilizados.

1. TensorFlow Models. **YAMNet — model documentation and reference implementation**. [README oficial](https://github.com/tensorflow/models/blob/master/research/audioset/yamnet/README.md).
2. MathWorks. **yamnetPreprocess — Preprocess audio for YAMNet classification**. [Documentação oficial](https://www.mathworks.com/help/audio/ref/yamnetpreprocess.html).
3. MathWorks. **audioPretrainedNetwork — Pretrained audio neural networks**. [Documentação oficial](https://www.mathworks.com/help/audio/ref/audiopretrainednetwork.html).
4. Gemmeke, J. F., et al. (2017). **Audio Set: An ontology and human-labeled dataset for audio events**. ICASSP, 776–780. [DOI: 10.1109/ICASSP.2017.7952261](https://doi.org/10.1109/ICASSP.2017.7952261).
5. MathWorks. **minibatchpredict — Mini-batched neural network prediction**. [Documentação oficial](https://www.mathworks.com/help/deeplearning/ref/minibatchpredict.html).
