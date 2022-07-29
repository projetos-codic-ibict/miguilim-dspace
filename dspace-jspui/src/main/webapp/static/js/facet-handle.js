function getFacetFromURL(){
    if(window.location.search) {
        const queryParams = window.location.search.substring(1);
        const params = queryParams.split("&");
        const facetParam = params[params.length -1].split('=')[0];
        return facetParam;
    }
    return null;
}

function  getAccordionContentElement() {
    const facetParam = getFacetFromURL();
    const facetName = facetParam.split('_')[0];
    return document.querySelector(`#facet_${facetName}`);
}

function  openFacet() {
    const accordionItem = getAccordionContentElement();
    if(accordionItem){
        accordionItem.style.height = 'auto';
        accordionItem.classList.add('in');
    }
}

document.addEventListener('DOMContentLoaded', async () => {
    openFacet();
})
