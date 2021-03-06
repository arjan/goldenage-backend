<div class="form-group row">
    <label class="control-label col-md-3" for="{{ #id }}{{ lang_code_for_id }}">{{ label }} {{ lang_code_with_brackets }}</label>
    <div class="col-md-{% if small %}3{% else %}9{% endif %}">
        <input type="text" id="{{ #id }}{{ lang_code_for_id }}" name="{{ name }}{{ lang_code_with_dollar }}" 
            value="{{ r[name|as_atom]|default:defaultvalue }}"
            {% if not is_editable %}disabled="disabled"{% endif %}
            {% include "_language_attrs.tpl" language=lang_code class="do_autofocus form-control field-"|append:name %} />
    </div>
</div>
