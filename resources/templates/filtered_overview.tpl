{{lang.subStringSauce}} <input type="text" id="substring" value="{{form.substring}}"/><br />
{{lang.typ1}}<input type="checkbox" id="isType1" {{#form.type1}}checked{{/form.type1}}/><br />
{{lang.typ2}}<input type="checkbox" id="isType2" {{#form.type2}}checked{{/form.type2}}/><br />
{{lang.typ3}}<input type="checkbox" id="isType3" {{#form.type3}}checked{{/form.type3}}/><br />
{{lang.typ4}}<input type="checkbox" id="isType4" {{#form.type4}}checked{{/form.type4}}/><br />
{{lang.typ5}}<input type="checkbox" id="isType5" {{#form.type5}}checked{{/form.type5}}/><br />
<input type="button" value="{{lang.submit}}" id="submit"/>
<table>
    <tr>
        <td>
            {{lang.id}}
        </td>
        <td></td>
        <td>
            <div>{{lang.name}}</div>
        </td>
        <td>
            {{lang.type}}
        </td>
    </tr>
    {{#tags}}
    <tr>
        <td>
            {{id}}
        </td>
        <td><input type='button' value='{{lang.viewTagSauce}}' id='viewtag{{id}}' class='buttonToEditTag'/></td>
        <td>
            <div>{{name}}</div>
        </td>
        <td>
            {{typeText}}
        </td>
    </tr>{{/tags}}</table>
