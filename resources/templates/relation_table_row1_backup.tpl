<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>{{#original}}{{id}}{{/original}}{{#new}}{{lang.tbd}}{{/new}}</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    {{#from}}
        {{fromText}}
    {{/from}}
    {{#to}}
        <select id='selectTarget{{count}}' class="selectTag" {{#original}}disabled="true"{{/original}} {{#toRemove}}disabled="true"{{/toRemove}}>
            <optgroup label="{{lang.typ5}}">
                {{#options}}{{#typ5}}
                    <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}} class="opt">{{label}}</option>
                {{/typ5}}{{/options}}
            </optgroup>
            <optgroup label="{{lang.typ4}}">
                {{#options}}{{#typ4}}
                    <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}} class="opt" >{{label}}</option>
                {{/typ4}}{{/options}}
            </optgroup>
            <optgroup label="{{lang.typ3}}">
                {{#options}}{{#typ3}}
                    <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}} class="opt" >{{label}}</option>
                {{/typ3}}{{/options}}
            </optgroup>
            <optgroup label="{{lang.typ2}}">
                {{#options}}{{#typ2}}
                    <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}} class="opt" >{{label}}</option>
                {{/typ2}}{{/options}}
            </optgroup>
            <optgroup label="{{lang.typ1}}">
                {{#options}}{{#typ1}}
                    <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}} class="opt" >{{label}}</option>
                {{/typ1}}{{/options}}
            </optgroup>
        </select>
    {{/to}}
</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    {{#from}}
        <select id='selectTarget{{count}}' class="selectTag" {{#original}}disabled="true"{{/original}} {{#toRemove}}disabled="true"{{/toRemove}}>
                    <optgroup label="{{lang.typ5}}">
                        {{#options}}{{#typ5}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}}  class="opt">{{label}}</option>
                        {{/typ5}}{{/options}}
                    </optgroup>
                    <optgroup label="{{lang.typ4}}">
                        {{#options}}{{#typ4}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}}  class="opt">{{label}}</option>
                        {{/typ4}}{{/options}}
                    </optgroup>
                    <optgroup label="{{lang.typ3}}">
                        {{#options}}{{#typ3}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}}  class="opt">{{label}}</option>
                        {{/typ3}}{{/options}}
                    </optgroup>
                    <optgroup label="{{lang.typ2}}">
                        {{#options}}{{#typ2}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}}  class="opt">{{label}}</option>
                        {{/typ2}}{{/options}}
                    </optgroup>
                    <optgroup label="{{lang.typ1}}">
                        {{#options}}{{#typ1}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}}{{#selected}}selected="true"{{/selected}}  class="opt">{{label}}</option>
                        {{/typ1}}{{/options}}
                    </optgroup>
        </select>
    {{/from}}
    {{#to}}
        {{toText}}
    {{/to}}
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
    <input type="number" name="str" min="-1" max="1" step="0.05" value="{{strength}}" {{#toRemove}}disabled="true"{{/toRemove}} id="str{{count}}"/>
</td>
<td {{#toRemove}}class="removedRelationInTr"{{/toRemove}}>
     {{#toRemove}}<input type="button" id="restore{{count}}" value="{{lang.restore}}" class="restore" />{{/toRemove}}
    {{#notToRemove}}<input type="button" id="remove{{count}}" class="remove" value="{{lang.remove}}" />{{/notToRemove}}
</td>
<td>{{message}}</td>