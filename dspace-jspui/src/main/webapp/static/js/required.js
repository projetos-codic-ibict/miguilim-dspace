// source from: https://www.telerik.com/blogs/building-html5-form-validation-bubble-replacements
function replaceValidationUI( form ) {
    // Suppress the default bubbles
    form.addEventListener( "invalid", function( event ) {
        event.preventDefault();
    }, true );

    // Support Safari, iOS Safari, and the Android browser—each of which do not prevent
    // form submissions by default
    form.addEventListener( "submit", function( event ) {
        if ( !this.checkValidity() ) {
            event.preventDefault();
        }
    });

    const submitButton = form.querySelector( "button:not([type=button]), input[type=submit]" );
    submitButton.addEventListener( "click", function( event ) {
        let invalidFields = form.querySelectorAll( ":invalid" ),
            errorMessages = form.querySelectorAll( ".error-message" ),
            parent, label;

        // Remove any existing messages
        for ( let i = 0; i < errorMessages.length; i++ ) {
            errorMessages[ i ].parentNode.removeChild( errorMessages[ i ] );
        }

        for ( let i = 0; i < invalidFields.length; i++ ) {
            parent = invalidFields[ i ].parentNode;
            label = form.querySelector( "label[for=" + invalidFields[ i ].id + "]" );
            const fieldName = label.innerHTML.replace(':', '');
            parent.insertAdjacentHTML( "beforeend", "<div class='alert alert-danger'>" +
               'CAMPO OBRIGATÓRIO' + ': ' + fieldName.trim() + ', ' + invalidFields[ i ].validationMessage +
                "</div>" );
        }

        // If there are errors, give focus to the first invalid field
        if ( invalidFields.length > 0 ) {
            invalidFields[ 0 ].focus();
        }
    });
}



// Replace the validation UI for all forms
document.addEventListener("DOMContentLoaded",  () => {
    const forms = document.querySelectorAll("form");
    for (let i = 0; i < forms.length; i++) {
        console.log('forms: ', forms[i])
        replaceValidationUI(forms[i]);
    }
})