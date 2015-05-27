{% with m.rsc[id] as r %}
{% with not id or m.rsc[id].is_editable as is_editable %}
<fieldset class="form-horizontal">

    {% include "form/_field_singleline.tpl" name=`title` label="Title" %}

    {% include "form/_field_singleline.tpl" name=`uuid` label="Beacon UUID" %}
    {% include "form/_field_singleline.tpl" name=`major` label="Beacon major" %}
    {% include "form/_field_singleline.tpl" name=`minor` label="Beacon minor" %}

</fieldset>

{% endwith %}
{% endwith %}
