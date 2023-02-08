<%@page contentType="text/html;charset=UTF-8" %>

<%
    String pontuacaoProtocoloInteroperabilidade = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.interoperabilityprotocol");
    String pontuacaoIdentificadorPersistente = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.persistentidentifier");
    String pontuacaoInstituicaoEditora = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.publisher");
    String pontuacaoEditorResponsavel = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.identifier.editor");
    String pontuacaoCodigoEtica = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.codeofethics");
    String pontuacaoNormalizacaoBibliografica = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.referenceguidelines");
    String pontuacaoPlataformaPlagio = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.plagiarismdetection");
    String pontuacaoRedesSociais = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.socialnetworks");
    String pontuacaoServicosInformacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.relation.informationservices");
    
    String pontuacaoModalidadePublicacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.modalityofpublication");
    List<MetadataValue> modalityOfPublicationValues = itemService.getMetadata(item, "dc", "description", "modalityofpublication", Item.ANY);
    
    String pontuacaoAvaliacaoPares = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.peerreview");
    List<MetadataValue> peerReviewValues = itemService.getMetadata(item, "dc", "description", "peerreview", Item.ANY);
    
    String pontuacaoPublicacaoAvaliadores = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.reviewerspublication");
    List<MetadataValue> reviewersPublicationValues = itemService.getMetadata(item, "dc", "description", "reviewerspublication", Item.ANY);
    
    String pontuacaoFormaPublicacaoAvaliadores = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.reviewerstypeofpublication");
    List<MetadataValue> reviewersTypeOfPublicationValues = itemService.getMetadata(item, "dc", "description", "reviewerstypeofpublication", Item.ANY);
    
    String pontuacaoExternalidadeAvaliacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.peerreviewexternality");
    List<MetadataValue> peerReviewExternalityValues = itemService.getMetadata(item, "dc", "description", "peerreviewexternality", Item.ANY);
    
    String pontuacaoSubmissaoPrePrint = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.preprintsubmission");
    List<MetadataValue> prePrintSubmissionValues = itemService.getMetadata(item, "dc", "rights", "preprintsubmission", Item.ANY);
    
    String pontuacaoSeloArmazenamento = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.sealcolor");
    List<MetadataValue> sealColorValues = itemService.getMetadata(item, "dc", "rights", "sealcolor", Item.ANY);
    
    String pontuacaoDisponibilizacaoDocumentos = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.time");
    List<MetadataValue> timeValues = itemService.getMetadata(item, "dc", "rights", "time", Item.ANY);
    
    String pontuacaoTipoAcesso = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.access");
    List<MetadataValue> accessValues = itemService.getMetadata(item, "dc", "rights", "access", Item.ANY);
    
    String pontuacaoCreativeCommons = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.creativecommons");
    List<MetadataValue> creativeCommonsValues = itemService.getMetadata(item, "dc", "rights", "creativecommons", Item.ANY);
    
    String pontuacaoTaxaPublicacao = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.publicationfees");
    List<MetadataValue> publicationFeesValues = itemService.getMetadata(item, "dc", "description", "publicationfees", Item.ANY);
    
    String pontuacaoPreservacaoDigital = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.description.digitalpreservation");
    List<MetadataValue> digitalPreservationValues = itemService.getMetadata(item, "dc", "description", "digitalpreservation", Item.ANY);
    
    String pontuacaoExigenciaDadosPesquisa = termometroService.calcularPontuacaoDoItemPorMetadado(item, "dc.rights.researchdata");
    List<MetadataValue> researchDataValues = itemService.getMetadata(item, "dc", "rights", "researchdata", Item.ANY);
   
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
        <div id="collapseOne" class="panel-collapse in"
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
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Identificador persistente</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoIdentificadorPersistente %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Identificador da instituição editora</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoInstituicaoEditora %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Identificador do editor responsável</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoEditorResponsavel %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Código de ética</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoCodigoEtica %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Padrão de normalização bibliográfica</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoNormalizacaoBibliografica %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Plataforma de detecção de plágio</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoPlataformaPlagio %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Redes sociais</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoRedesSociais %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 0 = 0 pontos<br>
                                    Quantidade de respostas: 1 = 1 ponto<br>
                                    Quantidade de respostas: 2 = 2 pontos<br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Serviços de informação</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoServicosInformacao %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    Quantidade de respostas: 1 = 0 pontos<br>
                                    Quantidade de respostas: 2 = 1 ponto<br>
                                    Quantidade de respostas: 3 = 2 pontos<br></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Modalidade de publicação</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoModalidadePublicacao %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String tradicional = printer.formatarApresentacaoMensagem(modalityOfPublicationValues, "Tradicional");
                                    	String aheadOfPrint = printer.formatarApresentacaoMensagem(modalityOfPublicationValues, "Ahead of print");
                                    	String fluxoContinuo = printer.formatarApresentacaoMensagem(modalityOfPublicationValues, "Fluxo contínuo");
                                    %>
                                    <%= tradicional %> = 0 pontos <br>
                                    <%= aheadOfPrint %> = 1 ponto <br>
                                    <%= fluxoContinuo %> = 2 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Modalidade de avaliação por pares</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoAvaliacaoPares %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String aberta = printer.formatarApresentacaoMensagem(peerReviewValues, "Avaliação aberta");
                                    	String duploCega = printer.formatarApresentacaoMensagem(peerReviewValues, "Avaliação duplo-cega");
                                    	String simplesCega = printer.formatarApresentacaoMensagem(peerReviewValues, "Avaliação simples-cega");
                                    %>
                                    <%= aberta %> = 2 pontos <br>
                                    <%= duploCega %> = 0 pontos <br>
                                    <%= simplesCega %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Publicação dos avaliadores</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoPublicacaoAvaliadores %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String publicacaoOpcaoA = printer.formatarApresentacaoMensagem(reviewersPublicationValues, 
                                    			"A revista publica somente o nome de avaliadores que participaram da avaliação de documentos aprovados para a publicação");
                                    	String publicacaoOpcaoB = printer.formatarApresentacaoMensagem(reviewersPublicationValues, 
                                    			"A revista publica o nome de todos os avaliadores que participaram da avaliação de documentos por determinado período");
                                    	String publicacaoOpcaoC = printer.formatarApresentacaoMensagem(reviewersPublicationValues, 
                                    			"A revista somente publica avaliadores que concordam com a publicação do seu nome");
                                    	String publicacaoOpcaoD = printer.formatarApresentacaoMensagem(reviewersPublicationValues, 
                                    			"A revista não publica o nome dos avaliadores, mas disponibiliza a lista de pesquisadores cadastrados como possíveis avaliadores");
                                    	String publicacaoOpcaoE = printer.formatarApresentacaoMensagem(reviewersPublicationValues, 
                                    			"A revista não publica nem revela o nome dos avaliadores");
                                    %>
                                    <%= publicacaoOpcaoA %> = 1 ponto <br>
                                    <%= publicacaoOpcaoB %> = 2 pontos <br>
                                    <%= publicacaoOpcaoC %> = 1 ponto <br>
                                    <%= publicacaoOpcaoD %> = 0 pontos <br>
                                    <%= publicacaoOpcaoE %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Forma de publicação do nome dos avaliadores</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoFormaPublicacaoAvaliadores %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String formaOpcaoA = printer.formatarApresentacaoMensagem(reviewersTypeOfPublicationValues, 
                                    			"A revista publica, no expediente, a listagem dos avaliadores que realizaram avaliações");
                                    	String formaOpcaoB = printer.formatarApresentacaoMensagem(reviewersTypeOfPublicationValues, 
                                    			"A revista publica, no corpo do documento aprovado na avaliação por pares, o nome dos avaliadores responsáveis");
                                    	String formaOpcaoC = printer.formatarApresentacaoMensagem(reviewersTypeOfPublicationValues, 
                                    			"A revista publica os pareceres resultantes das avaliações realizadas com o nome dos avaliadores");
                                    	String formaOpcaoD = printer.formatarApresentacaoMensagem(reviewersTypeOfPublicationValues, 
                                    			"A revista não publica o nome dos avaliadores, mas disponibiliza a lista de pesquisadores cadastrados como possíveis avaliadores");
                                    	String formaOpcaoE = printer.formatarApresentacaoMensagem(reviewersTypeOfPublicationValues, 
                                    			"A revista não publica, nem revela o nome dos avaliadores");
                                    %>
                                    <%= formaOpcaoA %> = 1 ponto <br>
                                    <%= formaOpcaoB %> = 1 ponto <br>
                                    <%= formaOpcaoC %> = 2 pontos <br>
                                    <%= formaOpcaoD %> = 0 pontos <br>
                                    <%= formaOpcaoE %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Externalidade da avaliação por pares</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoExternalidadeAvaliacao %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String externalidadeOpcaoA = printer.formatarApresentacaoMensagem(peerReviewExternalityValues, 
                                    			"A avaliação por pares é realizada, exclusivamente, por pesquisadores da instituição que edita a revista");
                                    	String externalidadeOpcaoB = printer.formatarApresentacaoMensagem(peerReviewExternalityValues, 
                                    			"A avaliação por pares é realizada por pesquisadores da instituiçao que edita a revista e por pesquisadores que são externos à instituição que edita a revista");
                                    	String externalidadeOpcaoC = printer.formatarApresentacaoMensagem(peerReviewExternalityValues, 
                                    			"A avaliação por pares é realizada, exclusivamente, por pesquisadores que são externos à instituição que edita a revista");
                                    %>
                                    <%= externalidadeOpcaoA %> = 0 pontos <br>
                                    <%= externalidadeOpcaoB %> = 1 ponto <br>
                                    <%= externalidadeOpcaoC %> = 2 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Permissão de submissão de preprint</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoSubmissaoPrePrint %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String submissaoOpcaoA = printer.formatarApresentacaoMensagem(prePrintSubmissionValues, 
                                    			"A revista aceita a submissão de preprints que já se encontram armazenados em outras plataformas");
                                    	String submissaoOpcaoB = printer.formatarApresentacaoMensagem(prePrintSubmissionValues, 
                                    			"A revista não aceita a submissão de preprints que já se encontram armazenados em outras plataformas");
                                    %>
                                    <%= submissaoOpcaoA %> = 2 pontos <br>
                                    <%= submissaoOpcaoB %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Selo de armazenamento e acesso</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoSeloArmazenamento %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String amarelo = printer.formatarApresentacaoMensagem(sealColorValues, 
                                    			"Amarela: permite o armazenamento e acesso das versões preprint dos documentos em repositórios institucionais/digitais");
                                    	String azul = printer.formatarApresentacaoMensagem(sealColorValues, 
                                    			"Azul: permite o armazenamento e acesso das versões pós-print dos documentos em repositórios institucionais/digitais");
                                    	String branco = printer.formatarApresentacaoMensagem(sealColorValues, 
                                    			"Branca: apresenta restrições para o armazenamento e acesso das versões preprint e pós-print dos documentos em repositórios institucionais/digitais");
                                    	String verde = printer.formatarApresentacaoMensagem(sealColorValues, 
                                    			"Verde: permite o armazenamento e acesso das versões preprint e pós-print dos documentos em repositórios institucionais/digitais");
                                    %>
                                    <%= amarelo %> = 1 ponto <br>
                                    <%= azul %> = 1 ponto <br>
                                    <%= branco %> = 0 pontos <br>
                                    <%= verde %> = 2 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Prazo para disponibilização de documentos</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoDisponibilizacaoDocumentos %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String prazoOpcaoA = printer.formatarApresentacaoMensagem(timeValues, "Imediatamente após a aceitação do documento");
                                    	String prazoOpcaoB = printer.formatarApresentacaoMensagem(timeValues, "Imediatamente após a publicação do documento");
                                    	String prazoOpcaoC = printer.formatarApresentacaoMensagem(timeValues, "Após finalizado o período de embargo");
                                    	String prazoOpcaoD = printer.formatarApresentacaoMensagem(timeValues, "Não permite o armazenamento");
                                    %>
                                    <%= prazoOpcaoA %> = 2 pontos <br>
                                    <%= prazoOpcaoB %> = 1 ponto <br>
                                    <%= prazoOpcaoC %> = 0 pontos <br>
                                    <%= prazoOpcaoD %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Tipo de acesso</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoTipoAcesso %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String acessoOpcaoA = printer.formatarApresentacaoMensagem(accessValues, "Acesso aberto imediato");
                                    	String acessoOpcaoB = printer.formatarApresentacaoMensagem(accessValues, "Acesso aberto após período de embargo");
                                    	String acessoOpcaoC = printer.formatarApresentacaoMensagem(accessValues, "Acesso restrito");
                                    	String acessoOpcaoD = printer.formatarApresentacaoMensagem(accessValues, "Acesso híbrido");
                                    %>
                                    <%= acessoOpcaoA %> = 2 pontos <br>
                                    <%= acessoOpcaoB %> = 1 ponto <br>
                                    <%= acessoOpcaoC %> = 0 pontos <br>
                                    <%= acessoOpcaoD %> = 1 ponto <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Licença Creative Commons</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoCreativeCommons %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:
                                    <%
                                    	String licencaOpcaoA = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite distribuição, remixagem, adaptação e criação a partir da obra, mesmo para fins comerciais, desde que seja atribuído o crédito ao autor da obra original (CC BY)");
                                    	String licencaOpcaoB = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite distribuição, remixagem, adaptação e criação a partir da obra, mesmo para fins comerciais, desde que seja atribuído o crédito ao autor da obra " +
                                                "original e que as novas criações utilizem a mesma licença da obra original (CC BY-SA)");
                                    	String licencaOpcaoC = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite redistribuição, comercial ou não comercial, desde que a obra não seja modificada e que seja atribuído o crédito ao autor (CC BY-ND)");
                                    	String licencaOpcaoD = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite remixagem, adaptação e criação a partir da obra, desde que seja atribuído o crédito ao autor e que a nova criação não seja usada para fins comerciais (CC BY-NC)");
                                    	String licencaOpcaoE = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite remixagem, adaptação e criação a partir da obra, para fins não comerciais, desde que seja atribuído o crédito ao autor da obra original e que as novas criações " +
                                                "utilizem a mesma licença da obra original (CC BY-NC-SA)");
                                    	String licencaOpcaoF = printer.formatarApresentacaoMensagem(creativeCommonsValues, 
                                    			"Permite redistribuição não comercial, desde que seja atribuído o crédito ao autor e que a obra não seja alterada de nenhuma forma (CC BY-NC-ND)");
                                    %>
                                    <%= licencaOpcaoA %> = 2 pontos <br>
                                    <%= licencaOpcaoB %> = 2 pontos <br>
                                    <%= licencaOpcaoC %> = 1 ponto <br>
                                    <%= licencaOpcaoD %> = 1 ponto <br>
                                    <%= licencaOpcaoE %> = 1 ponto <br>
                                    <%= licencaOpcaoF %> = 0 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Taxas de publicação</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoTaxaPublicacao %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String taxaOpcaoA = printer.formatarApresentacaoMensagem(publicationFeesValues, "A revista cobra taxa de submissão de artigos");
                                    	String taxaOpcaoB = printer.formatarApresentacaoMensagem(publicationFeesValues, "A revista cobra taxa de processamento de artigos (APC)");
                                    	String taxaOpcaoC = printer.formatarApresentacaoMensagem(publicationFeesValues, "A revista cobra taxa de submissão e de processamento de artigos");
                                    	String taxaOpcaoD = printer.formatarApresentacaoMensagem(publicationFeesValues, "A revista não cobra qualquer taxa de publicação");
                                    %>
                                    <%= taxaOpcaoA %> = 0 pontos <br>
                                    <%= taxaOpcaoB %> = 0 pontos <br>
                                    <%= taxaOpcaoC %> = 0 pontos <br>
                                    <%= taxaOpcaoD %> = 2 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol"><b>Estratégia de preservação digital</b></td>
                                <td class="oddRowEvenCol"><%= pontuacaoPreservacaoDigital %></td>
                            </tr>
                            <tr>
                                <td class="oddRowEvenCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String naoAdota = printer.formatarApresentacaoMensagem(digitalPreservationValues, "Ainda não adota política");
                                    	String lockss = printer.formatarApresentacaoMensagem(digitalPreservationValues, "LOCKSS");
                                    	String clockss = printer.formatarApresentacaoMensagem(digitalPreservationValues, "CLOCKSS");
                                    	String portico = printer.formatarApresentacaoMensagem(digitalPreservationValues, "Portico");
                                    	String pkpPn = printer.formatarApresentacaoMensagem(digitalPreservationValues, "PKP PN");
                                    	String archivematica = printer.formatarApresentacaoMensagem(digitalPreservationValues, "Archivematica");
                                    	String other = printer.formatarApresentacaoMensagem(digitalPreservationValues, "'other'");
                                    %>
                                    <%= naoAdota %> = 0 pontos <br>
                                    <%= lockss %> = 2 pontos <br>
                                    <%= clockss %> = 2 pontos <br>
                                    <%= portico %> = 2 pontos <br>
                                    <%= pkpPn %> = 2 pontos <br>
                                    <%= archivematica %> = 2 pontos <br>
                                    <%= other %> = 2 pontos <br>
                                </td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol"><b>Exigência de disponibilização de dados de pesquisa</b></td>
                                <td class="oddRowOddCol"><%= pontuacaoExigenciaDadosPesquisa %></td>
                            </tr>
                            <tr>
                                <td class="oddRowOddCol" colspan="2">
                                    Escala de respostas:<br>
                                    <%
                                    	String pesquisaOpcaoA = printer.formatarApresentacaoMensagem(researchDataValues, 
                                    			"A revista exige que os autores publiquem os dados que deram origem à pesquisa em repositórios e/ou revistas de dados");
                                    	String pesquisaOpcaoB = printer.formatarApresentacaoMensagem(researchDataValues, 
                                    			"A revista publica os dados que deram origem à pesquisa na própria revista");
                                    	String pesquisaOpcaoC = printer.formatarApresentacaoMensagem(researchDataValues, 
                                    			"A revista não exige que os autores publiquem os dados que deram origem à pesquisa");
                                    %>
                                    <%= pesquisaOpcaoA %> = 2 pontos <br>
                                    <%= pesquisaOpcaoB %> = 1 ponto <br>
                                    <%= pesquisaOpcaoC %> = 0 pontos <br>
                                </td>
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
    
</div>