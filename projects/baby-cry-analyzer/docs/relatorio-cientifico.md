# Baby Cry Analyzer: análise acústica exploratória de choro com MATLAB e YAMNet

**Autora:** Diana Alves  
**Tipo de trabalho:** protótipo académico e relatório técnico-científico  
**Data de preparação:** 22 de novembro de 2026  
**Estado da evidência:** quatro observações históricas reportadas; sem avaliação quantitativa independente; versão reorganizada sem execução MATLAB confirmada neste ambiente.

## Resumo

Este trabalho apresenta um protótipo MATLAB para análise de ficheiros WAV com YAMNet pré-treinada. O objetivo é explorar categorias acústicas e a pontuação associada a `Crying, sobbing`, sem inferir a causa do choro. Foram documentados quatro testes de conveniência previamente reportados: duas gravações descritas como choro infantil, uma gravação predominantemente silenciosa e uma gravação de fala da autora. As pontuações de `Crying, sobbing` foram, respetivamente, 34,94%, 8,80%, 0,11% e 0,75%. A categoria principal foi `Crying, sobbing` no primeiro exemplo, `Speech` no segundo e no quarto, e `Silence` no terceiro. O segundo exemplo expõe uma limitação da decisão baseada na categoria principal. Estes dados demonstram comportamentos observados em casos particulares e não permitem estimar precisão, sensibilidade ou generalização. A contribuição inclui organização do código, explicitação das decisões de processamento, documentação dos erros e um protocolo de avaliação futura. Não são publicados áudios privados ou pesos da rede.

**Palavras-chave:** processamento de áudio; MATLAB; YAMNet; choro infantil; classificação acústica; reprodutibilidade.

## 1. Introdução e objetivos

A análise computacional de áudio permite explorar representações tempo-frequência e redes pré-treinadas em tarefas educativas. A existência de uma categoria relacionada com choro numa rede geral de sons não demonstra, por si só, capacidade de reconhecer todos os choros infantis ou interpretar necessidades de um bebé.

O objetivo primário deste projeto é implementar um percurso transparente entre a leitura de áudio, o pré-processamento, a inferência e a interpretação das pontuações. Os objetivos secundários são documentar os quatro testes já realizados, tornar explícitas as limitações e disponibilizar um procedimento de avaliação que possa ser executado no futuro. Não são objetivos desta versão diagnosticar dor, distinguir fome de sono, emitir alertas clínicos ou apoiar decisões de cuidado.

O historial de desenvolvimento menciona ainda uma experiência de classificação de cinco causas do choro, cujo melhor resultado teria ficado abaixo de uma referência baseada em prever sempre «fome». Não foram recuperados resultados numéricos verificáveis, protocolo, partições ou artefactos suficientes dessa experiência. Por isso, a referência é apenas contextual: não se apresenta uma tabela de desempenho, não se reconstitui uma experiência inexistente e não se inclui um classificador de causas como funcionalidade validada.

## 2. Fundamentação técnica

YAMNet é uma rede de classificação de eventos acústicos associada ao AudioSet, com 521 categorias, baseada na arquitetura MobileNet v1 e convoluções separáveis em profundidade [1,4]. O modelo geral fornece uma representação útil para explorar sons, mas o seu domínio de treino não garante adequação a uma tarefa específica de choro infantil.

O pré-processamento de referência utiliza áudio mono a 16 kHz, análise espectral em janelas curtas e representação log-mel. A documentação oficial descreve 64 bandas mel e blocos temporais de 96 quadros [1,2]. Na implementação deste projeto, o pré-processamento é delegado à função da MathWorks, evitando manter uma segunda implementação numérica.

É necessário distinguir a implementação de referência do TensorFlow da distribuição MATLAB: a documentação MathWorks apresenta uma rede com saída `softmax`, enquanto a implementação de referência possui o seu próprio processamento e parametrização [1,3]. Não se assume equivalência numérica entre plataformas, versões ou pesos. Em qualquer caso, apresentar uma pontuação numa escala de 0 a 100 não a transforma numa medida de acerto nem numa probabilidade calibrada para este contexto.

## 3. Materiais e proveniência

As fontes dos resultados são as descrições e valores da conversa de desenvolvimento disponibilizada pela autora. Os dois primeiros exemplos foram descritos como gravações de choro com rótulos de origem «dor abdominal» e «desconforto». Os outros correspondem a silêncio predominante e à voz da autora. Os rótulos das causas não foram confirmados clinicamente nem previstos pelo protótipo.

Não estão disponíveis para esta publicação identificadores públicos inequívocos, hashes, duração, características de aquisição, anotação independente ou versões completas do ambiente original. As imagens da conversa e os ficheiros de áudio não são distribuídos. Consequentemente, os valores são tratados como **observações históricas reportadas**, e não como uma repetição experimental realizada durante a preparação deste relatório.

Não houve recrutamento, amostragem aleatória, cálculo de dimensão amostral ou conjunto de teste independente documentado. A unidade da tabela é a gravação descrita, não cada segmento produzido pela rede. Segmentos sobrepostos de um mesmo áudio não constituem observações independentes.

## 4. Metodologia da versão publicada

### 4.1. Preparação do sinal

A entrada é um WAV local. O programa verifica a existência, extensão e duração antes de ler as amostras. São admitidas frequências inteiras a partir de 16 kHz e duração máxima de 300 s. As amostras devem ser finitas, reais e estar em [-1,1]. Estes limites são escolhas operacionais do protótipo e não critérios clínicos.

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

`Crying, sobbing` e `Baby cry, infant cry` são categorias distintas. Mantém-se a primeira porque é a categoria para a qual foram reportados os valores históricos. Não se substitui a classe nem se somam pontuações após observar uma falha. Uma versão especificamente orientada à deteção de choro infantil exigiria definir antecipadamente outra regra e avaliá-la em dados independentes.

### 4.4. Validação do software e evidência experimental

São fornecidos testes unitários para agregação temporal, empates, matriz incompatível, conversão de canais, padding, silêncio e cálculo de métricas. Um teste de integração usa um WAV de zeros temporário para exercitar a rede, sem publicar gravações. Estes testes verificam contratos do software; não substituem uma avaliação da classificação em sons reais.

A preparação desta publicação incluiu revisão estática do código e consulta às APIs oficiais. Não havia MATLAB instalado no ambiente utilizado; não se afirma que os testes fornecidos passaram nem que a versão reorganizada reproduziu as quatro pontuações. Esta distinção evita atribuir ao código novo evidência proveniente de uma execução anterior.

## 5. Resultados observados

| ID | Conteúdo descrito | Categoria principal | Pontuação principal | Pontuação de `Crying, sobbing` |
| --- | --- | --- | ---: | ---: |
| T01 | Choro infantil; rótulo de origem «dor abdominal» | Crying, sobbing | 34,94% | 34,94% |
| T02 | Choro infantil; rótulo de origem «desconforto» | Speech | 24,62% | 8,80% |
| T03 | Gravação predominantemente silenciosa | Silence | 78,34% | 0,11% |
| T04 | Fala da autora | Speech | 63,23% | 0,75% |

Os valores são apresentados com as duas casas decimais originalmente reportadas; não estão disponíveis pontuações por segmento ou valores sem arredondamento.

Em T01, a categoria principal é coerente com a descrição de choro, sem demonstrar a causa. Em T02, a regra publicada produziria uma decisão negativa apesar da descrição de choro, constituindo um possível falso negativo face a esse rótulo. Esta interpretação depende de aceitar a descrição da entrada, que não foi auditada de forma independente. T03 e T04 são coerentes, respetivamente, com silêncio e fala, nos exemplos particulares fornecidos.

Não se calcula uma percentagem global de acerto a partir destes quatro casos. A seleção por conveniência, a inexistência de rótulos independentes e a falta de um protocolo pré-definido impedem tratar essa percentagem como uma estimativa de desempenho. A pontuação de 34,94% em T01 não corresponde à precisão do sistema.

## 6. Discussão

O conjunto de observações é compatível com um protótipo capaz de produzir categorias e pontuações para diferentes entradas. O resultado T02 mostra por que motivo execução sem erros e classificação correta são critérios distintos. Uma aplicação pode carregar o áudio e apresentar resultados válidos numericamente, mantendo uma decisão inadequada para a tarefa pretendida.

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

- Apenas quatro casos históricos, sem reexecução, amostragem representativa ou anotação independente.
- Falta de metadados e artefactos suficientes para reproduzir exatamente os valores reportados.
- Classe de choro genérica, sem validação específica para bebés ou causas de choro.
- Possível perda de eventos breves pela média e influência de padding, canais, ruído e domínio de aquisição.
- Ausência de calibração, análise por subgrupos, intervalos de confiança e validação externa.
- Compatibilidade e execução da versão reorganizada ainda não confirmadas em MATLAB neste ambiente.

Os áudios não são publicados, incluindo a voz da autora. Também não se incluem nomes originais, identificadores de crianças, pesos da rede ou datasets volumosos. Os exemplos sintéticos dos testes são criados temporariamente. Dados futuros exigem autorização e tratamento apropriado à sua origem; rótulos sensíveis e correspondências de identidade devem permanecer em registos privados.

As instruções permitem reproduzir o **procedimento** e testar o **software** com outros WAV autorizados. Não prometem reproduzir os **resultados históricos exatos** sem os originais e o ambiente correspondente. Esta restrição é deliberada e explicitada, preservando a privacidade.

## 9. Conclusão

O Baby Cry Analyzer documenta uma aplicação académica de processamento de áudio e inferência com uma rede pré-treinada. Os quatro testes reportados incluem respostas coerentes com algumas entradas e uma classificação principal discordante num exemplo descrito como choro. A contribuição reside na implementação transparente, organização e análise crítica dos resultados. Não foi demonstrada precisão geral, identificação de causas ou utilidade clínica. Uma avaliação independente e a execução dos testes da versão publicada constituem os próximos passos verificáveis.

## Referências

Fontes técnicas consultadas em 22 de novembro de 2026. As observações T01–T04 provêm do registo privado de desenvolvimento fornecido pela autora, não destas referências.

1. TensorFlow Models. **YAMNet — model documentation and reference implementation**. [README oficial](https://github.com/tensorflow/models/blob/master/research/audioset/yamnet/README.md).
2. MathWorks. **yamnetPreprocess — Preprocess audio for YAMNet classification**. [Documentação oficial](https://www.mathworks.com/help/audio/ref/yamnetpreprocess.html).
3. MathWorks. **audioPretrainedNetwork — Pretrained audio neural networks**. [Documentação oficial](https://www.mathworks.com/help/audio/ref/audiopretrainednetwork.html).
4. Gemmeke, J. F., et al. (2017). **Audio Set: An ontology and human-labeled dataset for audio events**. ICASSP, 776–780. [DOI: 10.1109/ICASSP.2017.7952261](https://doi.org/10.1109/ICASSP.2017.7952261).
5. MathWorks. **minibatchpredict — Mini-batched neural network prediction**. [Documentação oficial](https://www.mathworks.com/help/deeplearning/ref/minibatchpredict.html).
