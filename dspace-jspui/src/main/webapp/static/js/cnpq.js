function loadFromJSON(json) {
    const div = document.querySelector('.cnpq')
    const ul1 = document.createElement('ul');
    ul1.id = 'cnpqUL'
    json.node.isComposedBy.node.forEach(element => {
        const li1 = document.createElement('li');
        li1.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${element.label}</span></span>`
        ul1.appendChild(li1)
        if (element.isComposedBy != null) {
            const ul2 = document.createElement('ul');
            ul2.className = 'nested';
            element.isComposedBy.node.forEach(subelement => {
                const li2 = document.createElement('li');
                li2.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subelement.label}</span></span>`
                ul2.appendChild(li2)
                li1.appendChild(ul2)
                if (subelement.isComposedBy != null) {
                    const ul3 = document.createElement('ul');
                    ul3.className = 'nested';
                    subelement.isComposedBy.node.forEach(subsubelement => {
                        const li3 = document.createElement('li');
                        li3.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subsubelement.label}</span></span>`
                        ul3.appendChild(li3)
                        li2.appendChild(ul3)
                        if (subsubelement.isComposedBy != null) {
                            const ul4 = document.createElement('ul');
                            ul4.className = 'nested';
                            if (subsubelement.isComposedBy.node.label != null) {
                                const li4 = document.createElement('li');
                                li4.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subsubelement.isComposedBy.node.label}</span></span>`
                                ul4.appendChild(li4)
                                li3.appendChild(ul4)
                            } else {
                                subsubelement.isComposedBy.node.forEach(subsubsubelement => {
                                    const li4 = document.createElement('li');
                                    li4.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subsubsubelement.label}</span></span>`
                                    ul4.appendChild(li4)
                                    li3.appendChild(ul4)
                                    if (subsubsubelement.isComposedBy != null) {
                                        const ul5 = document.createElement('ul');
                                        ul5.className = 'nested';
                                        if (subsubsubelement.isComposedBy.node.label != null) {
                                            const li5 = document.createElement('li');
                                            li5.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subsubsubelement.isComposedBy.node.label}</span></span>`
                                            ul5.appendChild(li5)
                                            li4.appendChild(ul5)
                                        } else {
                                            subsubsubelement.isComposedBy.node.forEach(subsubsubsubelement => {
                                                const li5 = document.createElement('li');
                                                li5.innerHTML = `<span><span class="caretCNPQ"></span><span class="option-select">${subsubsubsubelement.label}</span></span>`
                                                ul5.appendChild(li5)
                                                li4.appendChild(ul5)
                                            });
                                        }
                                    }
                                });
                            }
                        }
                    });
                }
            });
        }
    });
    div.appendChild(ul1)
    addListeners()
}

function addListeners() {

    var toggler = document.getElementsByClassName("caretCNPQ");
    var options = document.getElementsByClassName("option-select");
    var i;

    for (i = 0; i < toggler.length; i++) {
        toggler[i].addEventListener("click", function () {
            try {
                this.parentElement.parentElement.querySelector(".nested").classList.toggle("active");
            } catch (e) {

            }
            this.classList.toggle("caretCNPQ-down");
        });
    }

    for (i = 0; i < options.length; i++) {
        options[i].addEventListener("click", function (e) {
            let textTreeSelected = this.firstChild.textContent
            let parent = this.parentElement.parentElement.parentElement
            while (parent.tagName == 'UL') {
                textTreeSelected = parent.parentElement.firstChild.textContent + "::" + textTreeSelected
                parent = parent.parentElement.parentElement
            }
            textTreeSelected = 'CNPQ' + textTreeSelected.trim();
            console.log(textTreeSelected)
            const select = document.querySelector('#dc_subject_cnpq')
            const option = document.createElement("option");
            option.text = textTreeSelected
            option.value = textTreeSelected
            option.selected = true
            select.add(option)
            e.preventDefault()
        });
    }
}