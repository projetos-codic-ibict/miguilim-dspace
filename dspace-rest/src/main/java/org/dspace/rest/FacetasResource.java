/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.rest;

import static org.apache.commons.collections.CollectionUtils.isNotEmpty;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang.StringUtils;
import org.dspace.core.I18nUtil;
import org.dspace.discovery.DiscoverFacetField;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.DiscoverResult.FacetResult;
import org.dspace.discovery.SearchUtils;
import org.dspace.discovery.configuration.DiscoveryConfiguration;
import org.dspace.discovery.configuration.DiscoverySearchFilterFacet;
import org.dspace.rest.common.Faceta;
import org.dspace.rest.common.RespostaFacetas;
import org.dspace.rest.common.ResultadoFaceta;


@Path("/facetas")
public class FacetasResource extends Resource
{
    @GET
    @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
    public RespostaFacetas obterFacetas (
    		@QueryParam("query-value") String queryValue, 
    		@QueryParam("query-metadados") List<String> metadados, 
    		@QueryParam("query-collection") String collectionId, 
    		@Context HttpHeaders headers, 
    		@Context HttpServletRequest request)
    {
    	org.dspace.core.Context context = null;
    	
    	RespostaFacetas retorno = new RespostaFacetas();
    	
    	List<DiscoverySearchFilterFacet> opcoesFacetas = obterFacetasParaPesquisa(metadados);
    	List<Faceta> facetas = new ArrayList<>();
    	
    	try 
    	{
			context = createContext();

			DiscoverQuery query = obterQuery(queryValue, collectionId, opcoesFacetas);
			DiscoverResult itens = SearchUtils.getSearchService().search(context, null, query);
			
			for (DiscoverySearchFilterFacet opcao : opcoesFacetas)
            {
				String field = opcao.getIndexFieldName();
				String chaveDescricaoFaceta = "rest.facet." + field;
				
				Faceta faceta = new Faceta();
				faceta.setMetadado(opcao.getMetadataFields().get(0));
				faceta.setDescricao(I18nUtil.getMessage(chaveDescricaoFaceta, context));
				
				List<ResultadoFaceta> resultadosFaceta = new ArrayList<>();

				for(FacetResult conjuntosFaceta : itens.getFacetResult(field))
				{
					if(conjuntosFaceta.getCount() > 0)
					{
						ResultadoFaceta resultado = new ResultadoFaceta();
						resultado.setNome(conjuntosFaceta.getDisplayedValue());
						resultado.setQuantidade(conjuntosFaceta.getCount());
						resultadosFaceta.add(resultado);
					}
				}
			
				faceta.setResultados(resultadosFaceta);
				
				if(isNotEmpty(resultadosFaceta))
				{
					facetas.add(faceta);
				}
            }
			
			retorno.setQuantidadeTotalItens(itens.getTotalSearchResults());
			retorno.setFacetas(facetas);
			
			context.complete();
		} 
        catch (Exception e)
        {
            processException("Message: " + e.getMessage(), context);
        }
    	
    	return retorno;
    }
    
    private List<DiscoverySearchFilterFacet> obterFacetasParaPesquisa(List<String> metadados) {
    	
       	List<DiscoverySearchFilterFacet> opcoesFacetas = new ArrayList<>();
    	
    	if(isNotEmpty(metadados))
    	{
    		for(String metadado : metadados)
    		{
                String[] blocosMetadado = metadado.split("\\.");
                             
                DiscoverySearchFilterFacet filter = new DiscoverySearchFilterFacet();
                filter.setMetadataFields(Arrays.asList(metadado));
                filter.setIndexFieldName(blocosMetadado[blocosMetadado.length - 1]);
                
                opcoesFacetas.add(filter);
    		}
    	}
    	else
    	{
    		DiscoveryConfiguration discoveryConfiguration = SearchUtils.getDiscoveryConfiguration();
        	opcoesFacetas = discoveryConfiguration.getSidebarFacets();
    	}
    	
    	Collator instance = Collator.getInstance();
    	instance.setStrength(Collator.NO_DECOMPOSITION);
    	Collections.sort(opcoesFacetas, (filter1, filter2) -> 
    		instance.compare(I18nUtil.getMessage("rest.facet." + filter1.getIndexFieldName()), I18nUtil.getMessage("rest.facet." + filter2.getIndexFieldName())));
    	  
    	return opcoesFacetas;
    }
    
    private DiscoverQuery obterQuery(String queryValue, String collectionId, List<DiscoverySearchFilterFacet> opcoesFacetas) {
    	DiscoverQuery query = new DiscoverQuery();
		query.setQuery(queryValue);
		
		if(StringUtils.isNotEmpty(collectionId))
		{
			query.addFilterQueries("location:l" + collectionId);
		}
		
		for (DiscoverySearchFilterFacet opcao : opcoesFacetas)
		{
			query.addFacetField(new DiscoverFacetField(opcao.getIndexFieldName(), opcao.getType(), -1, opcao.getSortOrderSidebar()));
		}
	
		return query;
    }
   
}
