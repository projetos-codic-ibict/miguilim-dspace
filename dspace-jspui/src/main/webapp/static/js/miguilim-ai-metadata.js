(function () {
    'use strict';

    const NOT_APPLICABLE = 'Não aplicável';
    const POLICY_PUBLISHED = 'Possui política publicada';

    const FIELD_NAMES = {
        policy: 'dc_description_aipolicy',
        policyUrl: 'dc_identifier_urlaipolicy',
        policyCoverage: 'dc_description_aipolicycoverage',
        authorUse: 'dc_description_aiauthoruse',
        reviewerUse: 'dc_description_airevieweruse',
        editorUse: 'dc_description_aieditoruse',
        declarationRequirements: 'dc_description_aideclarationrequirements',
        allowedUses: 'dc_description_aipolicyalloweduses',
        confidentiality: 'dc_description_aiconfidentiality'
    };

    const COVERAGE_VALUES = {
        author: 'A política de IA contempla a utilização por autores',
        reviewer: 'A política de IA contempla a utilização por pareceristas',
        editor: 'A política de IA contempla a utilização por editores'
    };

    function findOption(select, value) {
        return Array
            .from(select.options)
            .find((option) => option.value === value) ?? null;
    }

    function getFieldContainer(element, form) {
        let current = element.parentElement;

        while (current && current !== form) {
            if (
                current.tagName === 'DIV' &&
                Array.from(current.children).some(
                    (child) => child.tagName === 'LABEL'
                )
            ) {
                return current;
            }

            current = current.parentElement;
        }

        return null;
    }

    function getField(form, name) {
        // Ao exibir erros de validação, o Miguilim insere uma tag <a> vazia
        // com o mesmo `name` do campo (aparentemente essa inserção é um bug).
        // Então excluímos elementos <a> para selecionar o controle real.
        const control = form.querySelector(`[name="${name}"]:not(a)`);

        if (!control) {
            return null;
        }

        const container = getFieldContainer(control, form);

        if (!container) {
            return null;
        }

        const previous = container.previousElementSibling;
        const next = container.nextElementSibling;

        return {
            control,
            container,
            error: form
                .querySelector(`.alert.alert-warning a[name="${name}"]`)
                ?.closest('.alert.alert-warning') ?? null,
            hint: previous && previous.classList.contains('help-block')
                ? previous
                : null,
            lineBreak: next && next.tagName === 'BR' ? next : null
        };
    }

    function setNotApplicable(control) {
        if (control.tagName !== 'SELECT') {
            control.value = NOT_APPLICABLE;
            return;
        }

        const option = findOption(control, NOT_APPLICABLE);

        if (!option) {
            return;
        }

        option.hidden = false;
        option.disabled = false;

        // O valor técnico deve ser a única seleção do campo.
        Array.from(control.options).forEach((thisOption) => {
            thisOption.selected = thisOption === option;
        });
    }

    function removeNotApplicable(control) {
        if (control.tagName !== 'SELECT') {
            if (control.value === NOT_APPLICABLE) {
                control.value = '';
            }

            return;
        }

        const option = findOption(control, NOT_APPLICABLE);

        if (!option) {
            return;
        }

        // Se o valor técnico estava selecionado, deixa o campo sem
        // uma resposta real selecionada quando ele voltar a ser aplicável.
        if (option.selected) {
            if (control.multiple) {
                option.selected = false;
            } else {
                const emptyOption = findOption(control, '');

                if (emptyOption) {
                    Array.from(control.options).forEach(
                        (option) => option.selected = false
                    );
                    emptyOption.selected = true;
                } else {
                    control.selectedIndex = -1;
                }
            }
        }

        // A opção continua no DOM para poder ser restaurada quando
        // o campo voltar a não ser aplicável.
        option.selected = false;
        option.disabled = true;
        option.hidden = true;
    }

    function setApplicable(field, applicable) {
        if (!field) {
            return;
        }

        field.container.style.display = applicable ? '' : 'none';

        if (field.hint) {
            field.hint.style.display = applicable ? '' : 'none';
        }

        if (field.lineBreak) {
            field.lineBreak.style.display = applicable ? '' : 'none';
        }

        if (field.error) {
            field.error.style.display = applicable ? '' : 'none';
        }

        if (applicable) {
            removeNotApplicable(field.control);
        } else {
            setNotApplicable(field.control);
        }
    }

    function getSelectedValues(field) {
        if (!field || field.control.tagName !== 'SELECT') {
            return [];
        }

        return Array.from(field.control.options)
            .filter((option) => {
                return option.selected && option.value !== NOT_APPLICABLE;
            })
            .map((option) => option.value);
    }

    function initialize() {
        const form = document.getElementById('edit_metadata');

        if (!form) {
            return;
        }

        const fields = Object.fromEntries(
            Object.entries(FIELD_NAMES).map(([name, value]) => [name, getField(form, value)])
        );

        // Se os campos previstos não estiverem presentes na página,
        // não tentamos aplicar regras sobre um formulário incompleto.
        if (Object.values(fields).some((value) => value === null)) {
            return;
        }

        function updateConditionalFields() {
            const policyPublished =
                fields.policy.control.value === POLICY_PUBLISHED;

            setApplicable(fields.policyUrl, policyPublished);
            setApplicable(fields.policyCoverage, policyPublished);
            setApplicable(fields.declarationRequirements, policyPublished);
            setApplicable(fields.allowedUses, policyPublished);
            setApplicable(fields.confidentiality, policyPublished);

            const coverage = policyPublished
                ? getSelectedValues(fields.policyCoverage)
                : [];

            setApplicable(
                fields.authorUse,
                policyPublished && coverage.includes(COVERAGE_VALUES.author)
            );

            setApplicable(
                fields.reviewerUse,
                policyPublished && coverage.includes(COVERAGE_VALUES.reviewer)
            );

            setApplicable(
                fields.editorUse,
                policyPublished && coverage.includes(COVERAGE_VALUES.editor)
            );
        }

        fields.policy.control.addEventListener(
            'change',
            updateConditionalFields
        );

        fields.policyCoverage.control.addEventListener(
            'change',
            updateConditionalFields
        );

        // Aplica as regras também ao abrir um registro já existente.
        updateConditionalFields();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }
})();
