<table>
    <tr>
        <td><input type='button' value='{{lang.buttonToHomeSauce}}' id='toHome'/></td>
        <td><input type='button' value='{{lang.buttonToOverviewSauce}}' id='toOverview'/></td>
        <td><input type='button' value='{{lang.addTagSauce}}' id='addTag' /></td>
        <td><input type='button' value='{{lang.exportJson}}' id='exportJson' disabled/></td>
        <td><input type='button' value='{{lang.backSauce}}' id='backButton' {{#cannotGoBack}}disabled='true'{{/cannotGoBack}} /></td>
        <td>
            <table>
                <tr><td>{{lang.loginSauce}}
                    <b><span class='loginName'>{{user.name}}</span></b>
                </td></tr><tr><td><input type='button' value='{{lang.logoutSauce}}' class='logout' /></td></tr>
                <tr></tr>
                <tr><td><input type="button" value="{{lang.editProfile}}" disabled="true" class="editProfile"/></td></tr>
            </table></td>
    </tr>
</table>
<div id='sub_content'></div>