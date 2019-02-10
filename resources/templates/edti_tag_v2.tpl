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
<table id="relTableFrom" class='centeraling'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>
    {{#relas}}
        {{#from}}
            <tr id="tr{{count}}" class="{{#original}}original{{/original}}{{#new}}new{{/new}}RelFromTableRow">
            </tr>
        {{/from}}
    {{/relas}}
</table>
<input type='button' value='{{lang.addRelationSauce}}' id='addRelationFrom' />
<h4>{{lang.relationsToSauce}}</h4>
<table id="relTableTo" class='centeraling'>
    <tr>
        <td>{{lang.relationIdSauce}}</td>
        <td>Z Tagu</td>
        <td>Do Tagu</td>
        <td>{{lang.relationStrengthSauce}}</td>
    </tr>
    {{#relas}}
        {{#to}}
            <tr id="tr{{count}}" class="{{#original}}original{{/original}}{{#new}}new{{/new}}RelToTableRow">
            </tr>
        {{/to}}
    {{/relas}}
</table>
<input type='button' value='{{lang.addRelationSauce}}' id='addRelationTo' />

<input type='button' value='{{lang.submitChangesToTagSauce}}' class='submitTag' />
