
function removeElement(id, event){
    const element = document.querySelector('#'+id);
    element.parentNode.removeChild(element);
    const btnElement = event.target;
    btnElement.parentNode.removeChild(btnElement);
}

function addElement(id){
    const element = document.querySelector('#'+id);
    let lastElement = element.cloneNode(true);
    let count = 0;
    while(true){
      count++;
      const nextElement = document.querySelector('#'+id+count);
      if(nextElement != null){
          lastElement =  nextElement.cloneNode(true);
      }else{
          break
      }
    }
    lastElement.id = id+count;
    lastElement.name = 'value_'+id+'_'+getSequence(count);
    lastElement.value = '';
    lastElement.defaultValue = '';
    const div = document.createElement('div');
    console.log(lastElement)
    div.appendChild(lastElement);
    const html = `<button type="button" onclick="removeElement('${id+count}', event)" class="btn btn-danger pull-right">
        <span class="glyphicon glyphicon-trash"></span>&nbsp;&nbsp;Excluir
    </button>`
    div.innerHTML = div.innerHTML + html;
    element.parentElement.parentElement.appendChild(div);
}

function getSequence(num){
    if(num > 9){
        return num
    }else{
        return '0'+num;
    }

}

