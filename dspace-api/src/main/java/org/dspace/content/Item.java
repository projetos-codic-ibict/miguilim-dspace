/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content;

import org.apache.log4j.Logger;
import org.dspace.content.comparator.NameAscendingComparator;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.content.service.MetadataFieldService;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.SearchService;
import org.dspace.discovery.SearchServiceException;
import org.dspace.discovery.SearchUtils;
import org.dspace.eperson.EPerson;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;
import org.dspace.termometro.util.CalculadoraTermometro;
import org.hibernate.annotations.Sort;
import org.hibernate.annotations.SortType;
import org.hibernate.proxy.HibernateProxyHelper;

import javax.persistence.*;
import javax.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Class representing an item in DSpace.
 * <P>
 * This class holds in memory the item Dublin Core metadata, the bundles in the
 * item, and the bitstreams in those bundles. When modifying the item, if you
 * modify the Dublin Core or the "in archive" flag, you must call
 * <code>update</code> for the changes to be written to the database.
 * Creating, adding or removing bundles or bitstreams has immediate effect in
 * the database.
 *
 * @author Robert Tansley
 * @author Martin Hald
 * @version $Revision$
 */
@Entity
@Table(name="item")
public class Item extends DSpaceObject implements DSpaceObjectLegacySupport
{
    private static final String REVISTAS = "miguilim/2";

    /**
     * Wild card for Dublin Core metadata qualifiers/languages
     */
    public static final String ANY = "*";

    @Column(name="item_id", insertable = false, updatable = false)
    private Integer legacyId;

    @Column(name= "in_archive")
    private boolean inArchive = false;

    @Column(name= "discoverable")
    private boolean discoverable = false;

    @Column(name= "withdrawn")
    private boolean withdrawn = false;

    @Column(name= "last_modified", columnDefinition="timestamp with time zone")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModified = new Date();

    @ManyToOne(fetch = FetchType.LAZY, cascade={CascadeType.PERSIST})
    @JoinColumn(name = "owning_collection")
    private Collection owningCollection;

    @OneToOne(fetch = FetchType.LAZY, mappedBy = "template")
    private Collection templateItemOf;

    /** The e-person who submitted this item */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "submitter_id")
    private EPerson submitter = null;


    /** The bundles in this item - kept in sync with DB */
    @ManyToMany(fetch = FetchType.LAZY, cascade={CascadeType.PERSIST})
    @JoinTable(
            name = "collection2item",
            joinColumns = {@JoinColumn(name = "item_id") },
            inverseJoinColumns = {@JoinColumn(name = "collection_id") }
    )
    private final Set<Collection> collections = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY, mappedBy = "items")
    private final List<Bundle> bundles = new ArrayList<>();

    @Transient
    private transient ItemService itemService = ContentServiceFactory.getInstance().getItemService();

    @Transient
    private transient HandleService handleService = HandleServiceFactory.getInstance().getHandleService();

    @Transient
    private transient MetadataFieldService metadataFieldService = ContentServiceFactory.getInstance().getMetadataFieldService();

    /**
     * Protected constructor, create object using:
     * {@link org.dspace.content.service.ItemService#create(Context, WorkspaceItem)}
     *
     */
    protected Item()
    {

    }

    /**
     * Find out if the item is part of the main archive
     *
     * @return true if the item is in the main archive
     */
    public boolean isArchived()
    {
        return inArchive;
    }

    /**
     * Find out if the item has been withdrawn
     *
     * @return true if the item has been withdrawn
     */
    public boolean isWithdrawn()
    {
        return withdrawn;
    }


    /**
     * Set an item to be withdrawn, do NOT make this method public, use itemService().withdraw() to withdraw an item
     * @param withdrawn
     */
    void setWithdrawn(boolean withdrawn) {
        this.withdrawn = withdrawn;
    }

    /**
     * Find out if the item is discoverable
     *
     * @return true if the item is discoverable
     */
    public boolean isDiscoverable()
    {
        return discoverable;
    }

    /**
     * Get the date the item was last modified, or the current date if
     * last_modified is null
     *
     * @return the date the item was last modified, or the current date if the
     *         column is null.
     */
    public Date getLastModified()
    {
        return lastModified;
    }

    public void setLastModified(Date lastModified) {
        this.lastModified = lastModified;
    }

    /**
     * Set the "is_archived" flag. This is public and only
     * <code>WorkflowItem.archive()</code> should set this.
     *
     * @param isArchived
     *            new value for the flag
     */
    public void setArchived(boolean isArchived)
    {
        this.inArchive = isArchived;
        setModified();
    }

    /**
     * Set the "discoverable" flag. This is public and only
     *
     * @param discoverable
     *            new value for the flag
     */
    public void setDiscoverable(boolean discoverable)
    {
        this.discoverable = discoverable;
        setModified();
    }

    /**
     * Set the owning Collection for the item
     *
     * @param c
     *            Collection
     */
    public void setOwningCollection(Collection c)
    {
        this.owningCollection = c;
        setModified();
    }

    /**
     * Get the owning Collection for the item
     *
     * @return Collection that is the owner of the item
     */
    public Collection getOwningCollection()
    {
        return owningCollection;
    }

    /**
     * Get the e-person that originally submitted this item
     *
     * @return the submitter
     */
    public EPerson getSubmitter()
    {
        return submitter;
    }

    /**
     * Set the e-person that originally submitted this item. This is a public
     * method since it is handled by the WorkspaceItem class in the ingest
     * package. <code>update</code> must be called to write the change to the
     * database.
     *
     * @param sub
     *            the submitter
     */
    public void setSubmitter(EPerson sub)
    {
        this.submitter = sub;
        setModified();
    }

    /**
     * Get the collections this item is in. The order is sorted ascending by collection name.
     *
     * @return the collections this item is in, if any.
     */
    public List<Collection> getCollections()
    {
        // We return a copy because we do not want people to add elements to this collection directly.
        // We return a list to maintain backwards compatibility
        Collection[] output = collections.toArray(new Collection[]{});
        Arrays.sort(output, new NameAscendingComparator());
        return Arrays.asList(output);
    }

    void addCollection(Collection collection)
    {
        collections.add(collection);
    }

    void removeCollection(Collection collection)
    {
        collections.remove(collection);
    }

    public void clearCollections(){
        collections.clear();
    }

    public Collection getTemplateItemOf() {
        return templateItemOf;
    }


    void setTemplateItemOf(Collection templateItemOf) {
        this.templateItemOf = templateItemOf;
    }

    /**
     * Get the bundles in this item.
     *
     * @return the bundles in an unordered array
     */
    public List<Bundle> getBundles()
    {
        return bundles;
    }

    /**
     * Get the bundles matching a bundle name (name corresponds roughly to type)
     *
     * @param name
     *            name of bundle (ORIGINAL/TEXT/THUMBNAIL)
     *
     * @return the bundles in an unordered array
     */
    public List<Bundle> getBundles(String name)
    {
        List<Bundle> matchingBundles = new ArrayList<Bundle>();

        // now only keep bundles with matching names
        List<Bundle> bunds = getBundles();
        for (Bundle bundle : bunds)
        {
            if (name.equals(bundle.getName()))
            {
                matchingBundles.add(bundle);
            }
        }

        return matchingBundles;
    }

    /**
     * Add a bundle to the item, should not be made public since we don't want to skip business logic
     * @param bundle the bundle to be added
     */
    void addBundle(Bundle bundle)
    {
        bundles.add(bundle);
    }

    /**
     * Remove a bundle from item, should not be made public since we don't want to skip business logic
     * @param bundle the bundle to be removed
     */
    void removeBundle(Bundle bundle)
    {
        bundles.remove(bundle);
    }

    /**
     * Return <code>true</code> if <code>other</code> is the same Item as
     * this object, <code>false</code> otherwise
     *
     * @param obj
     *            object to compare to
     * @return <code>true</code> if object passed in represents the same item
     *         as this object
     */
    @Override
    public boolean equals(Object obj)
    {
        if (obj == null)
        {
            return false;
        }
        Class<?> objClass = HibernateProxyHelper.getClassWithoutInitializingProxy(obj);
        if (this.getClass() != objClass)
        {
            return false;
        }
        final Item otherItem = (Item) obj;
        if (!this.getID().equals(otherItem.getID()))
        {
            return false;
        }

        return true;
    }

    @Override
    public int hashCode()
    {
        int hash = 5;
        hash += 71 * hash + getType();
        hash += 71 * hash + getID().hashCode();
        return hash;
    }

    /**
     * return type found in Constants
     *
     * @return int Constants.ITEM
     */
    @Override
    public int getType()
    {
        return Constants.ITEM;
    }

    @Override
    public String getName()
    {
        return getItemService().getMetadataFirstValue(this, MetadataSchema.DC_SCHEMA, "title", null, Item.ANY);
    }

    public boolean isItemDaColecao(Collection colecao) {
        return isItemDaColecao(colecao.getHandle());
    }

    public boolean isItemDaColecao(String handle) {
        return getCollections()
                .stream()
                .anyMatch(c -> c.getHandle() != null && c.getHandle().equals(handle));
    }

    public void updateMetadadosComputados(Context context) throws SQLException {
        if (isItemDaColecao(REVISTAS)) {
            updateReferenciaBibliografica(context, "pt_BR");
            updateTermometro(context, "pt_BR");
        }

        updateRelacionamentos(context);
    }

    private boolean possuiCampo(String campo) {
        // return this.getMetadata().stream().anyMatch(mv -> mv.getMetadataField().toString('.').equals(campo));
        List<MetadataValue> mv = itemService.getMetadataByMetadataString(this, campo);
        return mv != null && mv.size() > 0;
    }

    private void updateRelacionamentos(Context context) throws SQLException {
        final Logger log = Logger.getLogger(getClass());
        List<Item> itensRelacionados = new ArrayList<Item>();
        String campoIspartof = "dc.relation.ispartof";
        String campoHaspart = "dc.relation.haspart";
        String campoJournaluri = "dc.identifier.journaluri";
        String campoJournalsportaluri = "dc.identifier.journalsportaluri";
        boolean possuiIspartof = possuiCampo(campoIspartof);
        boolean possuiHaspart = possuiCampo(campoHaspart);
        String campoEsquerdo;
        String campoDireito;

        if (!possuiIspartof && !possuiHaspart) {
            return;
        }

        campoEsquerdo = possuiIspartof ? campoIspartof : campoHaspart;
        campoDireito = campoEsquerdo == campoIspartof ? campoHaspart : campoIspartof;

        List<MetadataValue> valoresEsquerdo = itemService.getMetadataByMetadataString(this, campoEsquerdo);

        for (MetadataValue mv : valoresEsquerdo) {
            String handle = handleService.resolveUrlToHandle(context, mv.getValue());

            if (handle == null) {
                continue;
            }

            DSpaceObject dso = handleService.resolveToObject(context, handle);

            if (dso == null || dso.getType() != Constants.ITEM) {
                continue;
            }

            itensRelacionados.add((Item) dso);
        }

        // Sempre o item relacionado deve possuir o outro campo, mas so por garantia...
        // itensRelacionados = itensRelacionados.stream().filter(item -> item.possuiCampo(campoDireito)).collect(Collectors.toList());

        for (Item itemRelacionado : itensRelacionados) {

            MetadataField mfCampoDireito = getCampo(context, campoDireito);
            String cdSchema = mfCampoDireito.getMetadataSchema().getName();
            String cdElement = mfCampoDireito.getElement();
            String cdQualifier = mfCampoDireito.getQualifier();

            String handleCanonico = getHandle().split("\\.")[0];
            String uri = handleService.resolveToURL(context, handleCanonico);

            boolean contemUri = itemService.getMetadataByMetadataString(itemRelacionado, campoDireito).stream().anyMatch(mv -> mv.getValue().equals(uri));

            if (contemUri) {
                continue;
            }

            MetadataField mfCampoEsquerdo = getCampo(context, campoEsquerdo);
            String ceSchema = mfCampoEsquerdo.getMetadataSchema().getName();
            String ceElement = mfCampoEsquerdo.getElement();
            String ceQualifier = mfCampoEsquerdo.getQualifier();

            itemService.addMetadata(context, itemRelacionado, cdSchema, cdElement, cdQualifier, "pt_BR", uri);
            itemService.clearMetadata(context, itemRelacionado, ceSchema, ceElement, ceQualifier, "pt_BR");

            log.info("--------------------------------------------------------------------------------");
            log.info(">>> (fcisco) Atualizando metadado " + campoDireito + " do item relacionado " + itemRelacionado.getHandle());
            log.info(">>> (fcisco) Atualização causada por salvar o item " + getHandle() + " que contem o metadado " + campoEsquerdo);
            log.info("--------------------------------------------------------------------------------");
        }
    }

    private MetadataField getCampo(Context context, String campo) throws SQLException {
        String[] partes = campo.split("\\.");
        String schema = partes.length >= 1 ? partes[0] : null;
        String element = partes.length >= 2 ? partes[1] : null;
        String qualifier = partes.length >= 3 ? partes[2] : null;
        MetadataField mf = metadataFieldService.findByElement(context, schema, element, qualifier);

        return mf;
    }

    private String getUrlFromTitulo(String titulo, Context context, HttpServletRequest request) throws SQLException {
        String url = null;

        try {
            DiscoverQuery queryArgs = new DiscoverQuery();
            SearchService searchService = SearchUtils.getSearchService();
            String fq = searchService.toFilterQuery(context, "title", "contains", titulo).getFilterQuery();
            queryArgs.addFilterQueries(fq);
            DiscoverResult qResults = searchService.search(context, null, queryArgs);

            List<DSpaceObject> dsoResults = qResults.getDspaceObjects();

            for (DSpaceObject dso : dsoResults) {
                if (dso.getType() != Constants.ITEM) {
                    continue;
                }

                String handle = dso.getHandle();

                if (handle != null) {
                    url = request.getContextPath() + "/handle/" + handle;
                }

                break;
            }
        } catch (SearchServiceException e) {
            final Logger log = Logger.getLogger(getClass());
            log.error(e);
        }

        return url;
    }

    private void updateReferenciaBibliografica(Context context, String idioma) throws SQLException {
        ItemService itemService = getItemService();
        itemService.clearMetadata(context, this, "dc", "description", "bibliographicreference", idioma);
        String referencia = computaReferenciaBibliografica(idioma);
        itemService.addMetadata(context, this, "dc", "description", "bibliographicreference", idioma, referencia);
    }

    private String computaReferenciaBibliografica(String idioma) {
        ItemService itemService = getItemService();

        String title = itemService.getMetadataFirstValue(this, "dc", "title", null, idioma);
        String city = itemService.getMetadataFirstValue(this, "dc", "description", "city", idioma);
        String publisherName = itemService.getMetadataFirstValue(this, "dc", "publisher", "name", idioma);
        String startyear = itemService.getMetadataFirstValue(this, "dc", "date", "startyear", idioma);
        String endyear = itemService.getMetadataFirstValue(this, "dc", "date", "endyear", idioma);
        String issn = itemService.getMetadataFirstValue(this, "dc", "identifier", "issn", idioma);

        String titleSufixo = ". ";
        String citySufixo = ": ";
        String publisherSufixo = ", ";
        String yearSufixo = ". ";
        String issnSufixo = ".";
        String referenciaBibliografica = "";

        if (title != null)
        {
            referenciaBibliografica = title.toUpperCase() + titleSufixo;
        }

        if (city != null)
        {
            referenciaBibliografica += city + citySufixo;
        }

        if (publisherName != null)
        {
            referenciaBibliografica += publisherName + publisherSufixo;
        }

        if (startyear != null)
        {
            referenciaBibliografica += startyear;

            if (endyear != null)
            {
                referenciaBibliografica += " - " + endyear;
            }

            referenciaBibliografica += yearSufixo;
        }

        if (issn != null)
        {
            referenciaBibliografica += "ISSN " + issn + issnSufixo;
        }

        String[] sufixos = { titleSufixo, citySufixo, publisherSufixo, yearSufixo, issnSufixo };

        for (String sufixo : sufixos) {
            if (referenciaBibliografica.endsWith(sufixo)) {
                referenciaBibliografica = referenciaBibliografica.substring(0, referenciaBibliografica.length() - sufixo.length()) + ".";
                break;
            }
        }

        return referenciaBibliografica == "" ? null : referenciaBibliografica;
    }

    private void updateTermometro(Context context, String idioma) throws SQLException {
        try {
            String porcentagemPontuacao = CalculadoraTermometro.calcularPorcentagemPontuacao(this);
            itemService.clearMetadata(context, this, "dc", "identifier", "thermometer", idioma);
            itemService.addMetadata(context, this, "dc", "identifier", "thermometer", idioma, porcentagemPontuacao);
        } catch (IOException e) {
            throw new RuntimeException("Can't create an Identifier!", e);
        }
    }

    @Override
    public Integer getLegacyId() {
        return legacyId;
    }

    public ItemService getItemService()
    {
        if(itemService == null)
        {
            itemService = ContentServiceFactory.getInstance().getItemService();
        }
        return itemService;
    }
}
