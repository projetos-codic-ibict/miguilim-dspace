<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
    
    <%-- Page footer --%>
    <div class="social-media-icons">
        <a href="https://www.youtube.com/user/IBICTbr/" title="icon do youtube do ibict" target="_blank"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M21.5821 7.16905C21.3521 6.30296 20.6744 5.62086 19.8139 5.38938C18.2542 4.96875 12 4.96875 12 4.96875C12 4.96875 5.74586 4.96875 4.18613 5.38938C3.32565 5.6209 2.64794 6.30296 2.41792 7.16905C2 8.73889 2 12.0142 2 12.0142C2 12.0142 2 15.2895 2.41792 16.8593C2.64794 17.7254 3.32565 18.3791 4.18613 18.6106C5.74586 19.0312 12 19.0312 12 19.0312C12 19.0312 18.2541 19.0312 19.8139 18.6106C20.6744 18.3791 21.3521 17.7254 21.5821 16.8593C22 15.2895 22 12.0142 22 12.0142C22 12.0142 22 8.73889 21.5821 7.16905V7.16905ZM9.95453 14.9879V9.04046L15.1818 12.0143L9.95453 14.9879V14.9879Z" fill="black"/>
        </svg></a> 
        <a href="https://www.facebook.com/IBICTbr/" title="icon do facebook do ibict" target="_blank"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M16.6539 13.25L17.2094 9.63047H13.7364V7.28164C13.7364 6.29141 14.2215 5.32617 15.777 5.32617H17.3559V2.24453C17.3559 2.24453 15.9231 2 14.5531 2C11.693 2 9.82346 3.73359 9.82346 6.87188V9.63047H6.64417V13.25H9.82346V22H13.7364V13.25H16.6539Z" fill="black"/>
        </svg></a>
        <a href="https://twitter.com/ibictbr" title="icon do twitter do ibict" target="_blank"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19.9442 7.92639C19.9569 8.10405 19.9569 8.28175 19.9569 8.4594C19.9569 13.8782 15.8326 20.1219 8.29444 20.1219C5.97209 20.1219 3.81473 19.4492 2 18.2818C2.32996 18.3198 2.64719 18.3325 2.98985 18.3325C4.90607 18.3325 6.67006 17.6853 8.0787 16.5813C6.27666 16.5432 4.7665 15.363 4.24618 13.7386C4.50001 13.7766 4.7538 13.802 5.02032 13.802C5.38833 13.802 5.75638 13.7513 6.099 13.6625C4.22083 13.2817 2.81215 11.632 2.81215 9.6396V9.58886C3.35782 9.89343 3.99239 10.0838 4.66493 10.1091C3.56087 9.37308 2.83754 8.11675 2.83754 6.69541C2.83754 5.934 3.04055 5.23603 3.3959 4.62689C5.41369 7.1142 8.44671 8.73854 11.8477 8.91624C11.7843 8.61167 11.7462 8.29444 11.7462 7.97717C11.7462 5.71826 13.5736 3.87817 15.8452 3.87817C17.0254 3.87817 18.0914 4.3731 18.8401 5.17259C19.7665 4.99494 20.6548 4.65228 21.4416 4.18275C21.137 5.13455 20.4898 5.93404 19.6396 6.44162C20.4645 6.35283 21.264 6.12435 22 5.80713C21.4417 6.61928 20.7437 7.3426 19.9442 7.92639V7.92639Z" fill="black"/>
        </svg></a>
    </div> 
    <footer class="section-footer">
        <div style="display: flex; gap: 10px;">
            <span><img style="padding: 1.5rem;" height="100" src="<%= request.getContextPath() %>/image/logo-ibict.png" alt="icone de 60 anos do ibict"></span>
            <span><img style="padding: 1rem;" height="100" src="<%= request.getContextPath() %>/image/logo-gov.png" alt="icone do governo federal"></span>
        </div>
        <span><p class="footer-adress">Instituto Brasileiro de Informação em Ciência e Tecnologia (Ibict) <br> SAUS Quadra 5 - Lote 6 Bloco H - Asa sul - CEP: 70.070-912 - Brasília - DF</p></span>
    </footer>

    <script defer="defer" src="//barra.brasil.gov.br/barra_2.0.js" type="text/javascript"></script>

    </body>
</html>