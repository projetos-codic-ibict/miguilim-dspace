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
    return document.querySelector(`#${getFacetFromURL()}`);
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
