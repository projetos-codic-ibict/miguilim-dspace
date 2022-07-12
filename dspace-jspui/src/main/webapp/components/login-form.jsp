<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Component which displays a login form and associated information
  --%>
  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
	<div class="panel-body">
    <div class="feedback-form">
     <form name="loginform" class="form-horizontal" id="loginform" method="post" action="<%= request.getContextPath() %>/password-login">  
      <a href="<%= request.getContextPath() %>/register"><fmt:message key="jsp.components.login-form.newuser"/></a><br>
	    <span><fmt:message key="jsp.components.login-form.enter"/></span>
		<div>
      <label for="tlogin_email"><fmt:message key="jsp.components.login-form.email"/></label>
      <input class="feedback-field" type="text" name="login_email" id="tlogin_email" tabindex="1" />
    </div>
    <div>
      <label for="tlogin_password"><fmt:message key="jsp.components.login-form.password"/></label>
      <input class="feedback-field" type="password" name="login_password" id="tlogin_password" tabindex="2" />
    </div>
    
    <div>
      <input type="submit" class="button-main-outline" name="login_submit" value="<fmt:message key="jsp.components.login-form.login"/>" tabindex="3" />
    </div>
  		
    <a href="<%= request.getContextPath() %>/forgot"><fmt:message key="jsp.components.login-form.forgot"/></a>
      </form>
    </div>
      <script type="text/javascript">
		      document.loginform.login_email.focus();
	  </script>
	</div>