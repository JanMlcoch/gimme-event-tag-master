<tr><td>
    <select id='selectTarget{{count}}' >111

        <optgroup label='{{typ5}}'>
            {{#tags}}{{#Typ5}}
                <option value='{{id}}'>{{name}}</option>
            {{/Typ5}}{{/tags}}
        </optgroup>
        <optgroup label='{{typ4}}'>
            {{#tags}}{{#Typ4}}
                <option value='{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
            {{/Typ4}}{{/tags}}
        </optgroup>
        <optgroup label='{{typ3}}' >
            {{#tags}}{{#Typ3}}
                <option value='{{id}}' {{#core}}disabled='true'{{/core}}>{{name}}</option>
            {{/Typ3}}{{/tags}}1
        </optgroup>
        <optgroup label='{{typ2}}' disabled='true'>
            {{#tags}}{{#Typ2}}
                <option value='{{id}}' disabled='true'>{{name}}</option>
            {{/Typ2}}{{/tags}}
        </optgroup>
        <optgroup label='{{typ1}}' disabled='true'>
            {{#tags}}{{#Typ1}}
                <option value='{{id}}' disabled='true'>{{name}}</option>
            {{/Typ1}}{{/tags}}
        </optgroup>

    </select>
</td><td>
    <input type="number" name="str" min="-1" max="1" step="0.05" value="0" id="str{{count}}" />
</td></tr>