<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>{{#original}}{{id}}{{/original}}{{#new}}{{lang.tbd}}{{/new}}</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    {{#from}}
        {{fromText}}
    {{/from}}
    {{#to}}
        <div id="smartContainer{{count}}" class="smartContainer" ></div>
    {{/to}}
</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    {{#from}}
        <div id="smartContainer{{count}}" class="smartContainer" ></div>
    {{/from}}
    {{#to}}
        {{toText}}
    {{/to}}
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    <input type="number" name="str" min="-1" max="1" step="0.05" value="{{strength}}" class="strInput"{{#toRemove}}disabled="true"{{/toRemove}} id="str{{count}}"/>
</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
     {{#toRemove}}<input type="button" id="restore{{count}}" value="{{lang.restore}}" class="restore" />{{/toRemove}}
    {{#notToRemove}}<input type="button" id="remove{{count}}" class="remove" value="{{lang.remove}}" />{{/notToRemove}}
</td>
<td>{{message}}</td>