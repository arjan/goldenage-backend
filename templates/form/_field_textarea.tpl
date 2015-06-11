
<div class="form-group row">
    <label class="control-label col-md-3" for="{{ #id }}{{ lang_code_for_id }}">{{ label }} {{ lang_code_with_brackets }}</label>
    <div class="col-md-9">
        <textarea rows="{{ rows|default:4 }}" cols="10" id="{{ #id }}{{ lang_code_for_id }}" name="{{ name }}{{ lang_code_with_dollar }}" {% if not is_editable %}disabled="disabled"{% endif %} {% include "_language_attrs.tpl" language=lang_code class="intro form-control" %}>{{ is_i18n|if : r.translation[lang_code][name|as_atom] : r[name|as_atom] | brlinebreaks }}</textarea>
	</div>
</div>
