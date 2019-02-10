<tr id="tr{{count}}" class="relToTableRow">
    <td>{{lang.tbd}}</td>
    <td>
        <select id='selectTarget{{count}}'class="selectTag">
            {{#options}}
                <option value='{{lang.tbd}}' {{#disabled}}disabled="true"{{/disabled}} >{{label}}</option>
            {{/options}}
        </select>
    </td>
    <td class='tagId' >{{toText}}</td>
    <td>
        <input type="number" name="str" min="-1" max="1" step="0.05" value="0" id="str{{count}}"/>
    </td>
    <td>

        <input type="button" id="restore{{count}}" value="{{lang.restore}}" class="hiddenElement restore" />

        <input type="button" id="remove{{count}}" class="remove" value="{{lang.remove}}" />

    </td>
</tr>