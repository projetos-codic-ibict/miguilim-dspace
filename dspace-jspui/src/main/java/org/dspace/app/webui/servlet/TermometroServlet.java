/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.app.webui.util.JSPManager;
import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;
import org.dspace.termometro.factory.TermometroServiceFactory;
import org.dspace.termometro.service.TermometroService;

public class TermometroServlet extends DSpaceServlet
{
    private static final String ATRIBUTO_PONTUACAO = "pontuacao";

    private final transient HandleService handleService = HandleServiceFactory.getInstance().getHandleService();
    private final transient TermometroService termometroService = TermometroServiceFactory.getInstance().getTermometroService();

    @Override
    protected void doDSGet(Context context, HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException, IllegalStateException, SQLException 
    {
        displayTermometro(context, request, response);
    }

    protected void displayTermometro(Context context, HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException, IllegalStateException, SQLException
    {
        DSpaceObject dso = null;
        String handle = request.getParameter("handle");

        if("".equals(handle) || handle == null)
        {
            handle = (String) request.getAttribute("handle");
        }

        if(handle != null)
        {
            dso = handleService.resolveToObject(context, handle);
        }

        if(dso == null)
        {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            JSPManager.showJSP(request, response, "/error/404.jsp");
            return;
        }
       
        String pontuacaoTermometro = termometroService.calcularPontuacaoTotalDoItem(dso);
        request.setAttribute(ATRIBUTO_PONTUACAO, pontuacaoTermometro);

        JSPManager.showJSP(request, response, "/item-pages/display-termometro.jsp");
    }

}
