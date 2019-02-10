<h1>{{header}}</h1>

<label for="add_tag_name">{{name}}</label>: <input id="add_tag_name" type="text" /><br>
<label for="add_tag_type">{{name}}</label>: <select id="add_tag_type">
    {{#options}}
        <option value="{{value}}">{{label}}</option>
    {{/options}}
</select><br>
<button class="submit_add_tag">{{add}}</button>
