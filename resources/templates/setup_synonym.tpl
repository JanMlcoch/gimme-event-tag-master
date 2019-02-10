{{tagName}}<input type='text' id='name' /><br />
{{chooseSynonymTargetSauce}}<br />
<select id='selectTarget' >

    <optgroup label='{{typ5}}'>
        {{#tags}}{{#Typ5}}
            <option value='{{id}}'>{{name}}</option>
        {{/Typ5}}{{/tags}}
    </optgroup>
    <optgroup label='{{typ4}}'>
        {{#tags}}{{#Typ4}}
            <option value='{{id}}'>{{name}}</option>
        {{/Typ4}}{{/tags}}
    </optgroup>
    <optgroup label='{{typ3}}'>
        {{#tags}}{{#Typ3}}
            <option value='{{id}}'>{{name}}</option>
        {{/Typ3}}{{/tags}}
    </optgroup>
    <optgroup label='{{typ2}}'>
        {{#tags}}{{#Typ2}}
            <option value='{{id}}'>{{name}}</option>
        {{/Typ2}}{{/tags}}
    </optgroup>
    <optgroup label='{{typ1}}'>
        {{#tags}}{{#Typ1}}
            <option value='{{id}}'>{{name}}</option>
        {{/Typ1}}{{/tags}}
    </optgroup>

</select>
<input type='button' value='{{submitText}}' id='submit' />