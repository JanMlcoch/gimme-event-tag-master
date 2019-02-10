            <tr id="tr{{count}}"  class="relFromTableRow">
                <td>{{lang.tbd}}</td>
                <td class='tagId' >{{fromText}}</td>
                <td>
                    <select id='selectTarget{{count}}'class="selectTag">
                        {{#options}}
                            <option value='{{id}}' {{#disabled}}disabled="true"{{/disabled}} >{{label}}</option>
                        {{/options}}
                    </select>
                </td>
                <td>
                    <input type="number" name="str" min="-1" max="1" step="0.05" value="0.5" id="str{{count}}"/>
                </td>
                <td>

                    <input type="button" id="restore{{count}}" value="{{lang.restore}}" class="hiddenElement restore" />

                    <input type="button" id="remove{{count}}" class="remove" value="{{lang.remove}}" />

                </td>
            </tr>