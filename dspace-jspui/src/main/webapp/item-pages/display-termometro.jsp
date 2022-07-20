<%@page contentType="text/html;charset=UTF-8" %>

<%
    String pontuacaoProtocoloInteroperabilidade = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.interoperabilityprotocol");
    String pontuacaoIdentificadorPersistente = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.persistentidentifier");
    String pontuacaoInstituicaoEditora = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.publisher");
    String pontuacaoEditorResponsavel = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.editor");
    String pontuacaoModalidadePublicacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.modalityofpublication");
    String pontuacaoAvaliacaoPares = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.peerreview");
    String pontuacaoPublicacaoAvaliadores = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.reviewerspublication");
    String pontuacaoFormaPublicacaoAvaliadores = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.reviewerstypeofpublication");
    String pontuacaoExternalidadeAvaliacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.peerreviewexternality");
    String pontuacaoSubmissaoPrePrint = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.preprintsubmission");
    String pontuacaoSeloArmazenamento = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.sealcolor");
    String pontuacaoDisponibilizacaoDocumentos = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.time");
    String pontuacaoTipoAcesso = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.access");
    String pontuacaoCreativeCommons = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.creativecommons");
    String pontuacaoTaxaPublicacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.publicationfees");
    String pontuacaoCodigoEtica = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.codeofethics");
    String pontuacaoNormalizacaoBibliografica = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.referenceguidelines");
    String pontuacaoPlataformaPlagio = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.plagiarismdetection");
    String pontuacaoPreservacaoDigital = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.digitalpreservation");
    String pontuacaoExigenciaDadosPesquisa = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.researchdata");
    String pontuacaoRedesSociais = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.socialnetworks");
    String pontuacaoServicosInformacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.relation.informationservices");
%>


<div class="panel-group" id="accordion" role="tablist"
     aria-multiselectable="true">
    <div class="panel panel-default">
        <div class="panel-heading" role="tab" id="headingOne">
            <a id="temometroCollapse" href="#collapseOne" class="panel-title" role="button" data-toggle="collapse"
               data-parent="#accordion"
               aria-expanded="false"
               aria-controls="collapseOne">
                <fmt:message key="termometro.display.header"/>
            </a>
        </div>
        <div id="collapseOne" class="panel-collapse collapse in"
             aria-expanded="false"
             role="tabpanel" aria-labelledby="headingOne">
            <div class="panel-body">
                <div class="header-termometro">
                    <h3><fmt:message key="termometro.display.title"/></h3>
                </div>

                <div class="container" id="div-termometro">
                    <canvas height=180 id="canvas-termometro" width=340></canvas>
                    <p>
                    <div id="preview-textfield"></div>
                    </p>
                </div>

                <div>
                    <h3>O que é o termômetro de Acesso Aberto?</h3>

                    <div class="descricao-termometro">
                        <p>Este termômetro tem como objetivo identificar o alinhamento das revistas científicas
                            brasileiras
                            cadastradas no Miguilim aos Movimentos de Acesso e de Ciência Aberta. Para fazer esta
                            medição, o
                            termômetro utiliza como parâmetro as respostas dadas pelo editor da revista a uma série de
                            metadados, sendo possível criar uma escala que mede o quão alinhada a revista está a estes
                            Movimentos.
                        </p>
                        <p>
                            As revistas que indicarem a resposta “Acesso aberto imediato” no campo “Tipo de acesso” e
                            cumprirem ao menos 80% dos critérios de abertura definidos pela Equipe Miguilim receberão um
                            selo de publicação em Acesso Aberto, que reconhece os esforços realizados pela revista para
                            colocar a Ciência ao alcance de todos.
                        </p>

                    </div>

                </div>
                <br/>
                <h3>Como a pontuação é atribuída?</h3>
                <p>A pontuação indicada no termômetro leva em consideração as respostas dadas a 22 campos do registro da
                    revista. Estes campos dizem respeito à abertura do processo editorial da revista como um todo e
                    relacionam-se à questões de transparência, disseminação e acesso aos conteúdos, direitos autorais,
                    interoperabilidade, ética, dentre outros.</p>
                <p>Os campos considerados são:</p>
                <ul>
                    <li>Protocolo de interoperabilidade</li>
                    <li>Identificador persistente</li>
                    <li>Identificador da instituição editora</li>
                    <li>Identificador do editor responsável</li>
                    <li>Modalidade de publicação*</li>
                    <li>Modalidade de avaliação por pares*</li>
                    <li>Publicação dos avaliadores*</li>
                    <li>Forma de publicação do nome dos avaliadores*</li>
                    <li>Externalidade da avaliação por pares*</li>
                    <li>Permissão de submissão de preprint*</li>
                    <li>Selo de armazenamento e acesso*</li>
                    <li>Prazo para disponibilização de documentos*</li>
                    <li>Tipo de acesso*</li>
                    <li>Licenças Creative Commons*</li>
                    <li>Taxas de publicação*</li>
                    <li>Código de ética</li>
                    <li> Padrão de normalização bibliográfica</li>
                    <li>Plataforma de detecção de plágio</li>
                    <li>Estratégia de preservação digital*</li>
                    <li>Exigência de disponibilização de dados de pesquisa*</li>
                    <li>Redes sociais</li>
                    <li>Serviços de informação*</li>
                </ul>
                <p>
                    Para cada um dos 22 campos a revista pode pontuar entre 0 (zero), 1 (um) ou 2 (dois) pontos, sendo 2
                    (dois) a pontuação máxima para cada um. Deste modo, ao pontuar 2 (dois) em cada um dos 22 campos a
                    revista atinge a pontuação máxima, de 44 pontos. O selo será atribuído àquelas revistas que marcarem
                    36 pontos ou mais, que correspondem a 80% da pontuação máxima e indicarem a resposta “Acesso aberto
                    imediato” no campo “Tipo de acesso”.
                </p>
                <p>Nos campos de preenchimento textual basta que o campo seja preenchido para que a revista receba o
                    valor máximo referente a ele (2 pontos). Caso o campo seja deixado em branco, a pontuação será 0
                    (zero).
                </p>
                <p>Nos campos de múltipla escolha foram atribuídas pontuações diferentes para cada uma das opções de
                    respostas, mas seguindo sempre a mesma escala, ou seja, de 0 (zero) a 2 (dois). Deste modo, quanto
                    mais aberta for a política editorial da revista, maior será sua pontuação.</p>
                <p>Para os campos repetitivos, sejam eles textuais ou de múltipla escolha, basta que a revista preencha
                    o campo uma vez ou indique a resposta com a opção que relaciona a política mais aberta para receber
                    os dois pontos pelo campo.
                </p>
                <br/>
                <div class="detalhamento-pontuacao">
                    <h3>Detalhes da pontuação</h3>

                    <table class="table panel-body">
                        <thead>
                        <tr>
                            <th class="oddRowEvenCol">Campos avaliados</th>
                            <th class="oddRowEvenCol">Pontuação obtida</th>
                        </tr>
                        </thead>
                        <tbody>

                        <tr>
                            <td class="oddRowEvenCol"><b>Protocolo de interoperabilidade</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoProtocoloInteroperabilidade %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Identificador persistente</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoIdentificadorPersistente %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Identificador da instituição editora</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoInstituicaoEditora %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Identificador do editor responsável</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoEditorResponsavel %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Código de ética</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoCodigoEtica %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Padrão de normalização bibliográfica</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoNormalizacaoBibliografica %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Plataforma de detecção de plágio</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoPlataformaPlagio %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Redes sociais</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoRedesSociais %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Quantidade de respostas: 0 = 0
                                pontos<br>Quantidade
                                de respostas: 1 = 1 ponto<br>Quantidade de respostas: 2 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Serviços de informação</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoServicosInformacao %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>
                                Quantidade de respostas: 1 = 0 ponto<br>
                                Quantidade de respostas: 2 = 1 ponto<br>
                                Quantidade de respostas: 3 = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Modalidade de publicação</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoModalidadePublicacao %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Tradicional = 0 ponto<br>Ahead
                                of
                                print = 1
                                ponto<br>Fluxo contínuo = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Modalidade de avaliação por pares</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoAvaliacaoPares %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Avaliação aberta = 2
                                pontos<br>Avaliação
                                duplo-cega = 0 ponto<br>Avaliação simples-cega = 0 ponto<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Publicação dos avaliadores</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoPublicacaoAvaliadores %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>A revista publica somente o
                                nome de
                                avaliadores
                                que participaram da avaliação de documentos aprovados para a publicação = 1 ponto<br>A
                                revista publica o
                                nome de todos os avaliadores que participaram da avaliação de documentos por determinado
                                período = 2
                                pontos<br>A revista somente publica avaliadores que concordam com a publicação do seu
                                nome =
                                1 ponto<br>A
                                revista não publica o nome dos avaliadores, mas disponibiliza a lista de pesquisadores
                                cadastrados como
                                possíveis avaliadores = 0 ponto<br>A revista não publica nem revela o nome dos
                                avaliadores
                                = 0
                                pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Forma de publicação do nome dos avaliadores</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoFormaPublicacaoAvaliadores %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>
                                A revista publica, no expediente, a listagem dos avaliadores que realizam avaliações = 1
                                ponto <br>
                                A revista publica, no corpo do documento aprovado na avaliação por pares, o nome dos
                                avaliadores responsáveis = 1 ponto<br>
                                A revista publica os pareceres resultantes das avaliações realizadas com o nome dos
                                avaliadores = 2 pontos<br>
                                A revista não publica o nome dos avaliadores, mas disponibiliza a lista de pesquisadores
                                cadastrados como possíveis avaliadores = 0 ponto<br>
                                A revista não publica, nem revela o nome dos avaliadores = 0 ponto
                            </td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Externalidade da avaliação por pares</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoExternalidadeAvaliacao %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>A avaliação por pares é
                                realizada,
                                exclusivamente, por pesquisadores da instituição que edita a revista = 0 ponto<br>A
                                avaliação por pares
                                é realizada por pesquisadores da instituiçao que edita a revista e por pesquisadores que
                                são
                                externos à
                                instituição que edita a revista = 1 ponto<br>A avaliação por pares é realizada,
                                exclusivamente, por
                                pesquisadores que são externos à instituição que edita a revista = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Permissão de submissão de preprint</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoSubmissaoPrePrint %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>A revista aceita a submissão
                                de
                                preprints que
                                já se encontram armazenados em outras plataformas = 2 pontos<br>A revista não aceita a
                                submissão de
                                preprints que já se encontram armazenados em outras plataformas = 0 ponto<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Selo de armazenamento e acesso</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoSeloArmazenamento %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Amarela: permite o
                                armazenamento e
                                acesso das
                                versões preprint dos documentos em repositórios institucionais/digitais = 1 ponto<br>Azul:
                                permite o
                                armazenamento e acesso das versões pós-print dos documentos em repositórios
                                institucionais/digitais = 1
                                ponto<br>Branca: apresenta restrições para o armazenamento e acesso das versões preprint
                                e
                                pós-print dos
                                documentos em repositórios institucionais/digitais = 0 ponto<br>Verde: permite o
                                armazenamento e acesso
                                das versões preprint e pós-print dos documentos em repositórios institucionais/digitais
                                = 2
                                pontos<br>
                            </td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Prazo para disponibilização de documentos</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoDisponibilizacaoDocumentos %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>
                                Imediatamente após a aceitação do documento = 2 pontos<br>
                                Imediatamente após a publicação do documento = 1 ponto<br>
                                Após finalizado o período de embargo = 0 ponto<br>
                                Não permite o armazenamento = 0 ponto<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Tipo de acesso</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoTipoAcesso %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>Acesso aberto imediato = 2
                                pontos<br>Acesso
                                aberto após período de embargo = 1 ponto<br>Acesso restrito = 0 ponto<br>Acesso híbrido
                                = 1
                                ponto<br>
                            </td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Licença Creative Commons</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoCreativeCommons %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Permite distribuição,
                                remixagem,
                                adaptação e
                                criação a partir da obra, mesmo para fins comerciais, desde que seja atribuído o crédito
                                ao
                                autor da
                                obra original (CC BY) = 2 pontos<br>Permite distribuição, remixagem, adaptação e criação
                                a
                                partir da
                                obra, mesmo para fins comerciais, desde que seja atribuído o crédito ao autor da obra
                                original e que as
                                novas criações utilizem a mesma licença da obra original (CC BY-SA) = 2 pontos<br>Permite
                                redistribuição, comercial ou não comercial, desde que a obra não seja modificada e que
                                seja
                                atribuído o
                                crédito ao autor (CC BY-ND) = 1 ponto<br>Permite remixagem, adaptação e criação a partir
                                da
                                obra, desde
                                que seja atribuído o crédito ao autor e que a nova criação não seja usada para fins
                                comerciais (CC
                                BY-NC) = 1 ponto<br>Permite remixagem, adaptação e criação a partir da obra, para fins
                                não
                                comerciais,
                                desde que seja atribuído o crédito ao autor da obra original e que as novas criações
                                utilizem a mesma
                                licença da obra original (CC BY-NC-SA) = 1 ponto<br>Permite redistribuição não
                                comercial,
                                desde que seja
                                atribuído o crédito ao autor e que a obra não seja alterada de nenhuma forma (CC
                                BY-NC-ND) =
                                0
                                pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Taxas de publicação</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoTaxaPublicacao %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>A revista cobra taxa de
                                submissão
                                de artigos =
                                0 ponto<br>A revista cobra taxa de processamento de artigos (APC) = 0 ponto<br>A
                                revista
                                cobra taxa de
                                submissão e de processamento de artigos = 0 ponto<br>A revista não cobra qualquer taxa
                                de
                                publicação = 2
                                pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Estratégia de preservação digital</b></td>
                            <td class="oddRowEvenCol"><%= pontuacaoPreservacaoDigital %></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol" colspan="2">Escala de respostas:<br>Ainda não adota política = 0
                                pontos<br>LOCKSS
                                = 2 pontos<br>CLOCKSS = 2 pontos<br>Portico = 2 pontos<br>PKP PN = 2 pontos<br>Archivematica
                                = 2
                                pontos<br>'other' = 2 pontos<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol"><b>Exigência de disponibilização de dados de pesquisa</b></td>
                            <td class="oddRowOddCol"><%= pontuacaoExigenciaDadosPesquisa %></td>
                        </tr>
                        <tr>
                            <td class="oddRowOddCol" colspan="2">Escala de respostas:<br>
                                A revista exige que os autores publiquem os dados que deram origem à pesquisa em
                                repositórios e/ou revistas de dados = 2 pontos<br>
                                A revista publica
                                os dados que deram origem à pesquisa na própria revista = 1 ponto<br>
                                A revista não exige que os autores publiquem os dados que deram origem à pesquisa = 0
                                ponto<br></td>
                        </tr>
                        <tr>
                            <td class="oddRowEvenCol"><b>Soma dos pontos da revista:</b></td>
                            <td class="oddRowEvenCol"><b><%= pontuacaoTotalTermometro %> (<%= porcentagemPontuacaoTermometro %>%)</b></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="panel panel-default">
        <div class="panel-heading" role="tab" id="headingH5">
            <a href="#collapseH5" class="panel-title collapsed" role="button" data-toggle="collapse"
               data-parent="#accordion"
               aria-expanded="false"
               aria-controls="collapseH5">
                <fmt:message key="termometroh5.display.header"/>
            </a>
        </div>

        <div id="collapseH5" class="panel-collapse collapse"
             aria-expanded="false"
             role="tabpanel" aria-labelledby="headingH5">
            <div class="panel-body">
                <div class="indiceh5">
                    <h3>
                        <fmt:message key="termometroh5.display.title"/>
                    </h3>
                    <% if (pontuacaoIndiceH5 != null) { %>
                        <span>
                            <%=pontuacaoIndiceH5%>
                        </span>
                    <%} else {%>
                        <p>O Índice H5 desta revista não foi informado</p>
                    <% }%>
                </div>
                <h3>O que é o Índice H5?</h3>
                <p>O H5 é um índice do Google que busca quantificar o impacto de uma revista com base no número
                    de
                    citações
                    obtidas pelos artigos da revista nos últimos 5 anos. Para compreender o cálculo do Índice H5
                    de
                    maneira
                    simples deve-se considerar o seguinte: se uma revista possui um H5 de 10 é porque nos
                    últimos 5
                    anos ela
                    publicou pelo menos 10 artigos que foram citados ao menos 10 vezes.</p>
            </div>
        </div>
    </div>
</div>