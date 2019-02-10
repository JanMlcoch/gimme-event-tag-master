<table>
    <tr>
        <td>{{lang.tagIdSauce}}</td>
        <td>{{id}}</td>
    </tr>
    <tr>
        <td>{{lang.tagNameSauce}}</td>
        <td>{{name}}</td>
    </tr>
    <tr>
        <td>{{lang.tagTypeSauce}}</td>
        <td id='tagType'>{{type}}</td>
    </tr>
</table>
<h4>
    {{lang.relationsFromSauce}}
</h4>
<table id='relTable' class='centerAlign'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>

    {{#relas}}
        {{#from}}
        <tr>
            <td>{{id}}</td>
            <td class='tagId'>{{fromText}}</td>
            <td class='tagId'>{{toText}}</td>
            <td>{{strength}}</td>
        </tr>
        {{/from}}
    {{/relas}}
</table>
<h4>{{lang.relationsToSauce}}</h4>
<table id='relTable' class='centerAlign'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>

    {{#relas}}
        {{#to}}
        <tr>
            <td>{{id}}</td>
            <td class='tagId'>{{fromText}}</td>
            <td class='tagId'>{{toText}}</td>
            <td>{{strength}}</td>
        </tr>
        {{/to}}
    {{/relas}}
</table>
<input type='button' value='{{lang.editTagSauce}}' id='edittag'/>