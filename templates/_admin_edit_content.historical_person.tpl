{% extends "admin_edit_widget_std.tpl" %}

{% block widget_title %}{{ _"Historical person details"|escapejs }}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}content-historical-person{% endblock %}

{% block widget_content %}
    <fieldset ng-app="ga-historical-person" ng-controller="main">
        <input style="display: none" type="text" name="keyvalue" ng-model="keyvalue" value='{{ r.keyvalue|default:[]|to_json }}' />

        <div class="row">
            <div class="col-lg-4 col-md-4">
                <label class="control-label">{_ Key _}</label>
            </div>
            <div class="col-md-8">
                <label class="control-label">{_ Value _}</label>
            </div>
        </div>
        
        <div class="row" ng-repeat="row in rows track by $index">
            <div class="form-group col-lg-4 col-md-4">
                <div>
                    <input class="form-control" ng-model="row.key" ng-change="updateJson()" /> 
                </div>
            </div>
            <div class="form-group col-md-7">
                <div>
                    <input class="form-control" ng-model="row.value" ng-change="updateJson()"  />
                </div>
            </div>
            <div class="form-group col-md-1">
                <button class="btn btn-default" ng-click="remove($event, $index)" type="button"><i class="glyphicon glyphicon-remove"></i></button>
            </div>
        </div>

        <button class="btn btn-primary btn-small" ng-click="add($event)">Add row</button>
        
    </fieldset>

{% endblock %}

{% block widget_after %}
    {% lib
        "js/vnd/angular.min.js"
        "js/goldenage-admin.js" %}
{% endblock %}
