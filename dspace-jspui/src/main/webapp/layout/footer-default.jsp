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
             <footer class="section-footer">
                <span><img height="40" src="<%= request.getContextPath() %>/image/footer-logo.png"></span>
                <span><p class="footer-adress">Instituto Brasileiro de Informação em Ciência e Tecnologia (Ibict) <br> SAUS Quadra 5 - Lote 6 Bloco H - Asa sul - CEP: 70.070-912 - Brasília - DF</p></span>
            </footer>
    </body>
</html>