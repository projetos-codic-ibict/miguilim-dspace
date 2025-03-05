/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.preenchimento.factory;

import org.dspace.services.factory.DSpaceServicesFactory;
import org.dspace.preenchimento.service.PreenchimentoService;

public abstract class PreenchimentoServiceFactory {

    public abstract PreenchimentoService getPreenchimentoService();

    public static PreenchimentoServiceFactory getInstance()
    {
        return DSpaceServicesFactory.getInstance()
            .getServiceManager().getServiceByName("preenchimentoServiceFactory", PreenchimentoServiceFactory.class);
    }
}
