<input type="button" value="{{lang.addFilter}}" id="addFilters" />
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
