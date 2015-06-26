{% with m.rsc[id] as r %}
{% with not id or m.rsc[id].is_editable as is_editable %}
<fieldset class="form-horizontal">

    {% include "form/_field_singleline.tpl" name=`title` label="Title" %}

    {% include "form/_field_singleline.tpl" name=`language` label="Language (nl / en)" short %}

    {% include "form/_field_singleline.tpl" name=`subtitle` label="Subtitle (hashtags)" %}
    {% include "form/_field_textarea.tpl" name=`summary` label="Story summary" %}

</fieldset>

{% endwith %}
{% endwith %}
