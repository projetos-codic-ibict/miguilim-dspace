
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;
import org.dspace.termometro.factory.TermometroServiceFactory;
import org.dspace.termometro.service.TermometroService;

/*
 * Servlet para executar ações pontuais e de uso temporário.
 */
public class TmpServlet extends DSpaceServlet
{
	private static final long serialVersionUID = 2389517967204248629L;

	protected transient TermometroService termometroService
             = TermometroServiceFactory.getInstance().getTermometroService();
    
    protected transient HandleService handleService
    		= HandleServiceFactory.getInstance().getHandleService();

    @Override
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {

    	termometroService.atualizarMetadadosTermometro(context, 
    			(Collection) handleService.resolveToObject(context, "miguilim/2"));
    	
        JSPManager.showJSP(request, response, "/tmp/tmp.jsp");
    }

    @Override
    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
       
    }
   
}
