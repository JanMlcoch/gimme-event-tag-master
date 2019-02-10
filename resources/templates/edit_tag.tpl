{{message}}
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
        <td id='tagType'>{{type}}
            <input type='button' value='{{lang.ChangeTagTypeSauce}} {{lang.to}} {{lang.typ1}}' id='changeType1' {{#isType1}}disabled="true"{{/isType1}} />
            <input type='button' value='{{lang.ChangeTagTypeSauce}} {{lang.to}} {{lang.typ2}}' id='changeType2' {{#isType2}}disabled="true"{{/isType2}} />
            <input type='button' value='{{lang.ChangeTagTypeSauce}} {{lang.to}} {{lang.typ3}}' id='changeType3' {{#isType3}}disabled="true"{{/isType3}} />
            <input type='button' value='{{lang.ChangeTagTypeSauce}} {{lang.to}} {{lang.typ4}}' id='changeType4' {{#isType4}}disabled="true"{{/isType4}} />
            <input type='button' value='{{lang.ChangeTagTypeSauce}} {{lang.to}} {{lang.typ5}}' id='changeType5' {{#isType5}}disabled="true"{{/isType5}} />
        </td>
    </tr>
</table>
<h4>
    {{lang.relationsFromSauce}}
</h4>
<table id="relTableFrom" class='centeraling'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>
    {{#relas}}{{#from}}
            <tr id="tr{{count}}" class="relFromTableRow"></tr>
    {{/from}}{{/relas}}
</table>
<input type='button' value='{{lang.addRelationSauce}}' id='addRelationFrom' {{#isType2}}disabled="true"{{/isType2}}/>
<h4>{{lang.relationsToSauce}}</h4>
<table id="relTableTo" class='centeraling'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>
    {{#relas}}{{#to}}
            <tr id="tr{{count}}" class="relToTableRow">
            </tr>
    {{/to}}{{/relas}}
</table>
<input type='button' value='{{lang.addRelationSauce}}' id='addRelationTo' />

<input type='button' value='{{lang.submitChangesToTagSauce}}' class='submitTag' {{#invalidState}}disabled = "true"{{/invalidState}} />
