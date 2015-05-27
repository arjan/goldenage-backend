<div class="form-group row">
    <label class="control-label col-md-3" for="{{ #id }}{{ lang_code_for_id }}">{{ label }} {{ lang_code_with_brackets }}</label>
    <div class="col-md-9">
        <input type="text" id="{{ #id }}{{ lang_code_for_id }}" name="{{ name }}{{ lang_code_with_dollar }}" 
            value="{{ is_i18n|if : r.translation[lang_code][name|as_atom] : r[name|as_atom] }}"
            {% if not is_editable %}disabled="disabled"{% endif %}
            {% include "_language_attrs.tpl" language=lang_code class="do_autofocus field-{{ name }} form-control" %} />
    </div>
</div>
