/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.rest;

import static org.apache.commons.collections.CollectionUtils.isNotEmpty;

import java.sql.SQLException;
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
    		@QueryParam("query-field") List<String> queryField,
            @QueryParam("query-operation") List<String> queryOperation,
            @QueryParam("query-filter") List<String> queryFilter,
    		@QueryParam("query-collection") String collectionId, 
    		@Context HttpHeaders headers, 
    		@Context HttpServletRequest request)
    {
    	org.dspace.core.Context context = null;
    	
    	RespostaFacetas retorno = new RespostaFacetas();
    	
    	List<DiscoverySearchFilterFacet> opcoesFacetas = obterFacetasDefault();
    	List<Faceta> facetas = new ArrayList<>();
        
    	try 
    	{
			context = createContext();

			DiscoverQuery query = obterQuery(queryValue, collectionId, opcoesFacetas);
			preencherFiltrosDaQuery(context, query, queryField, queryOperation, queryFilter);
			
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
    
    private List<DiscoverySearchFilterFacet> obterFacetasDefault()
    {
    	List<DiscoverySearchFilterFacet> facetasDefault = new ArrayList<>();
    	
    	DiscoveryConfiguration discoveryConfiguration = SearchUtils.getDiscoveryConfiguration();
    	facetasDefault = new ArrayList<>(discoveryConfiguration.getSidebarFacets());
    	
    	DiscoverySearchFilterFacet filterState = new DiscoverySearchFilterFacet();
    	filterState.setMetadataFields(Arrays.asList("dc.state"));
    	filterState.setIndexFieldName("state");
    	
    	facetasDefault.add(filterState);
    	
    	Collator instance = Collator.getInstance();
    	instance.setStrength(Collator.NO_DECOMPOSITION);
    	Collections.sort(facetasDefault, (filter1, filter2) -> 
    		instance.compare(I18nUtil.getMessage("rest.facet." + filter1.getIndexFieldName()), I18nUtil.getMessage("rest.facet." + filter2.getIndexFieldName())));
    	
    	return facetasDefault;
    }
    
    private void preencherFiltrosDaQuery(org.dspace.core.Context context, DiscoverQuery query, 
    		List<String> queryField, 
    		List<String> queryOperation, 
    		List<String> queryFilter) throws SQLException {
		
    	int index = Math.min(queryField.size(), Math.min(queryOperation.size(), queryFilter.size()));
		for (int i = 0; i < index; i++)
		{
			String filterQuery = SearchUtils
					.getSearchService()
		            .toFilterQuery(context, queryField.get(i), queryOperation.get(i), queryFilter.get(i))
		            .getFilterQuery();
		        
			if (filterQuery != null)
		    {
				query.addFilterQueries(filterQuery);
		    }
		}
	}
   
}
