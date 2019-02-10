<table>{{#tags}}{{#tag}}
    <tr>
        <td><input type='button' value='{{viewTagSauce}}' id='viewtag{{id}}' class='buttonToEditTag'/></td>
        <td>
            <div id='toColor{{i}}' style='background-color: {{color}};'>{{name}}</div>
        </td>
    </tr>{{/tag}}{{/tags}}</table>
