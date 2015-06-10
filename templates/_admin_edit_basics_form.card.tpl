{% with m.rsc[id] as r %}
{% with not id or m.rsc[id].is_editable as is_editable %}
<fieldset class="form-horizontal">

    {% include "form/_field_singleline.tpl" name=`title` label="Title" %}


    <div class="form-group row">
        <label class="control-label col-md-3" for="{{ #summary }}{{ lang_code_for_id }}">{_ Summary _} {{ lang_code_with_brackets }}</label>
        <div class="col-md-9">
            <textarea rows="4" cols="10" id="{{ #summary }}{{ lang_code_for_id }}" name="summary{{ lang_code_with_dollar }}" {% if not is_editable %}disabled="disabled"{% endif %} {% include "_language_attrs.tpl" language=lang_code class="intro form-control" %}>{{ is_i18n|if : r.translation[lang_code].summary : r.summary | brlinebreaks }}</textarea>
	    </div>
    </div>

    {% include "form/_field_singleline.tpl" name=`card_date` label="Date" %}
    
    {% include "form/_field_singleline.tpl" name=`time` label="Card time" %}

</fieldset>

{% endwith %}
{% endwith %}
