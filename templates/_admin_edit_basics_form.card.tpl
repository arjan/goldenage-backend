{% with m.rsc[id] as r %}
{% with not id or m.rsc[id].is_editable as is_editable %}
<fieldset class="form-horizontal">

    {% include "form/_field_singleline.tpl" name=`title` label="Title" %}

    {% include "form/_field_textarea.tpl" name=`summary` label="Text" %}

    {% include "form/_field_singleline.tpl" name=`card_date` label="Date" %}
    
    {% include "form/_field_singleline.tpl" name=`time` label="Card duration" %}

    {% block card_basics_extra %}
    {% endblock %}
    
</fieldset>

{% endwith %}
{% endwith %}
