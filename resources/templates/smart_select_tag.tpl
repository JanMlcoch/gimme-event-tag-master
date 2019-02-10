<input type="text" id="{{inputId}}" value="{{inputValue}}" class="smartInput" {{#disabled}}disabled="true"{{/disabled}}/>
<input type="text" class="hiddenClass targetTagId" value="{{chosenTagId}}" />
<div id="{{listId}}" class="smartList">
    {{#options}}
        <div id="{{id}}" class="smartOpt">{{label}}</div>
    {{/options}}
</div>