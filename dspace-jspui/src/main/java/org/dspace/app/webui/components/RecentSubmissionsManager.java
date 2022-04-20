/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 * <p>
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.components;

import java.util.List;

import org.apache.log4j.Logger;
import org.dspace.browse.BrowseEngine;
import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseIndex;
import org.dspace.browse.BrowseInfo;
import org.dspace.browse.BrowserScope;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.sort.SortException;
import org.dspace.sort.SortOption;

/**
 * Class that obtains recent submissions to DSpace containers.
 * @author rdjones
 *
 */
public class RecentSubmissionsManager {
    /** logger */
    private static Logger log = Logger.getLogger(RecentSubmissionsManager.class);

    /** DSpace context */
    private Context context;

    protected ItemService itemService = ContentServiceFactory.getInstance().getItemService();


    /**
     * Construct a new RecentSubmissionsManager with the given DSpace context
     *
     * @param context
     */
    public RecentSubmissionsManager(Context context) {
        this.context = context;
    }


    public RecentSubmissions getRecentSubmissions(DSpaceObject dso)
            throws RecentSubmissionsException {
        return new RecentSubmissions(itemService.findRandom(context));
    }

}
