# Tag_master

Aplikace pro správu tagů. 
Umí měnit typy tagů a jejich vztahy k ostatním tagům

## API
Pro většinu API operací je potřeba dočasný hashkey. Všechny změny jsou ukládány do uživatelských pracovních verzí, které se pak budou lišit od společné defaultní. Tato defaultní verze se změní, pokud se více uživatelů shodne v navržených změnách (aspoň 3).
* **GET /api/types** - vrátí seznam typů tagů
* **GET /api/tags** - vrátí seznam všech tagů 
 * **type=names** - vrátí pouze jména a ID tagů
 * **(default)** - vrátí jména, ID a typy tagů
 * **type=full** - vrátí kompletní tagy i se vztahy
 * **type=overview** - vrátí seznam tagů s ID a typy, kdo měnil a blízkost schválení
 * **user=XXXX** - vrací tagy se stavem, který mu daný uživatel nastavil
 * **user=def** - vrací tagy se stavem počátečním (nebo odsouhlaseným)
* **GET /api/tag** - vrátí plné informace o tagu
 * **tag=id** - POVINNÉ - id dotčeného tagu
 * **(default)** - vrací tag se stavem, který mu přihlášený uživatel nastavil
 * **user=XXXX** - vrací tag se stavem, který mu daný uživatel nastavil
 * **user=def** - vrací tagy se stavem počátečním (nebo odsouhlaseným)
 * **user=all** - vrací tagy se stavem počátečním a všemi stavy uživatelů
* **POST /api/tags** - aplikuje změny ve více tazích (pouze změny)
* **POST /api/tag** - aplikuje změny v jednom tagu (pouze změny)
 * **tag=name** - POVINNÉ - jméno dotčeného tagu
* **POST /api/tag** - vytvoří tag (vytvoří se jako uživatelův i jako defaultní)
* **POST /api/user** - přijme login a heslo a vrátí dočasný hashkey pro všechny další operace
 * **user=XXXX** - uživatelské jméno
 * **pass=XXXX** - heslo

### Doporučené využití API:
1. Přihlásit se - POST /api/user
2. Stáhnout seznam tagů jako overview - GET /api/tags?type=overview
3. Stáhnout jeden tag pro editaci - GET /api/tag/:name
4. Pro schvalovací editaci i s infomacemi o změnách ostatních - GET /api/tag/:name?user=all
5. Uložit změny - POST /api/tag/:name


