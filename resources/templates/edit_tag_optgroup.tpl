<table>
    <tr>
        <td>{{lang.tagIdSauce}}</td>
        <td>{{id}}</td>
    </tr>
    <tr>
        <td>{{lang.tagNameSauce}}</td>
        <td><input type='text' id='inputTagName' value='{{name}}'/></td>
    </tr>
    <tr>
        <td>{{lang.tagTypeSauce}}</td>
        <td id='tagType'>{{typeText}}
            <input type='button' value='{{lang.ChangeTagTypeSauce}}' id='changeType' disabled='true'/></td>
    </tr>
</table>
<h4>
    {{lang.relationsFromSauce}}
</h4>
<table id="relTable" class='centeraling'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>
    {{#relasFrom}}
        {{#id}}
            <tr>
                <td>{{id}}</td>
                <td>{{name}}</td>
                <td>
                    <select id='selectTarget{{count}}'>

                        <optgroup label='{{typ5}}'>
                            {{#taggs}}{{#Typ5}}
                                <option value='{{id}}' id='o{{count}}_{{id}}'
                                        {{#custom}}disabled='true'{{/custom}}>{{name}}</option>
                            {{/Typ5}}{{/taggs}}
                        </optgroup>
                        <optgroup label='{{typ4}}'>
                            {{#taggs}}{{#Typ4}}
                                <option value='{{id}}' id='o{{count}}_{{id}}'
                                        {{#core}}disabled='true'{{/core}}>{{name}}</option>
                            {{/Typ4}}{{/taggs}}
                        </optgroup>
                        <optgroup label='{{typ3}}'>
                            {{#taggs}}{{#Typ3}}
                                <option value='{{id}}' id='o{{count}}_{{id}}'
                                        {{#core}}disabled='true'{{/core}}>{{name}}</option>
                            {{/Typ3}}{{/taggs}}1
                        </optgroup>
                        <optgroup label='{{typ2}}'>
                            {{#taggs}}{{#Typ2}}
                                <option value='{{id}}' id='o{{count}}_{{id}}'
                                        {{#notSyn}}disabled='true'{{/notSyn}}>{{name}}</option>
                            {{/Typ2}}{{/taggs}}
                        </optgroup>
                        <optgroup label='{{typ1}}'>
                            {{#taggs}}{{#Typ1}}
                                <option value='{{id}}' id='o{{count}}_{{id}}'
                                        {{#notSyn}}disabled='true'{{/notSyn}}>{{name}}</option>
                            {{/Typ1}}{{/taggs}}
                        </optgroup>

                    </select>
                </td>
                <td>
                    <input type="number" name="str" min="-1" max="1" step="0.05" value="{{str}}" id="str{{count}}"/>
                </td>
            </tr>

        {{/id}}

    {{/relasFrom}}
</table>
<input type='button' value='{{lang.addRelationSauce}}' id='addRelation'/>
<h4>{{lang.relationsToSauce}}</h4>
{{lang.notReadySauce}}<br/>
<input type='button' value='{{lang.submitChangesToTagSauce}}' id='submitTag'/>