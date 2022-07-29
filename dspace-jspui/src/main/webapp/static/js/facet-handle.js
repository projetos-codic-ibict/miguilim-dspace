function getFacetFromURL(){
    if(window.location.search) {
        const queryParams = window.location.search.substring(1);
        const params = queryParams.split("&");
        return params[params.length -1].split('=')[0];
    }
    return null;
}



function  getFaceName() {
    const facetParam = getFacetFromURL();
   return facetParam.split('_')[0];
}

function  openFacet(facetName) {
    let facetId = `#facet_${facetName}`;
    const accordionItem = document.querySelector(facetId);
    if(accordionItem){
        accordionItem.style.height = 'auto';
        accordionItem.classList.add('in');
        addAnchor(facetId)
    }
}

function addAnchor(facetId){
    const url = new URL(window.location);
    url.hash = `#${facetId}`;
    window.history.pushState({}, '', url);
}

document.addEventListener('DOMContentLoaded', async () => {
    try {
        const facetName = getFaceName();
        openFacet(facetName);
    }catch (e) {
        console.error(e)
    }
})
