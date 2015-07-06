{% with m.rsc[id] as r %}
{% with not id or m.rsc[id].is_editable as is_editable %}
<fieldset class="form-horizontal">

    {% include "form/_field_singleline.tpl" name=`title` label="Title" %}

    {% include "form/_field_singleline.tpl" name=`subtitle` label="Subtitle (job description)" %}
    {% include "form/_field_textarea.tpl" name=`summary` label="Summary (biography)" %}

</fieldset>

{% endwith %}
{% endwith %}
