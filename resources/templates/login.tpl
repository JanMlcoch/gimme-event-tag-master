<h1>{{loginTitle}}</h1>
<form>
    <table>
        <tr>
            <td>{{loginText}}
            </td>
            <td><input type='text' class='login' value="taliesin" /></td>
        </tr>
        <tr>
            <td>{{passText}}
            </td>
            <td><input type='password' class='password' value="aaa" /></td>
        </tr>
        <tr>
            <td><input type='button' class='submitCredentials' value='{{submitText}}'></td>
        </tr>
    </table>
</form>
{{#errorSS}}
    <div id="errorInLoginState"></div>
{{/errorSS}}