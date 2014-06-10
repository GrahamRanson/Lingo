Lingo
=====

A translation library for the Corona SDK. Doesn't actually do any translation, just used to store and look up translated phrases.

Basic Usage
-------------------------

##### Require and initiate the code
```lua
local lingo = require( "lingo" ):new()
```

##### Load a language from 'english.json' in the root of the resource directory.
```lua
lingo:loadLanguage( "english" )
```

##### Load a language from 'french.json' in the 'languages' directory located in the resource directory.
```lua
lingo:loadLanguage( "french", "languages/" )
```

##### Load a language from 'german.json' in the root of the documents directory.
```lua
lingo:loadLanguage( "english", system.DocumentsDirectory )
```

##### Load a language from 'australian.json' in the 'languages' directory located in the documents directory.
```lua
lingo:loadLanguage( "australian", "languages/", system.DocumentsDirectory )
```

##### Set the current language to english.
```lua
lingo:setCurrentLanguage( "english" )
```

##### Get a string from the current language named 'hello' and print it out.
```lua
print( lingo:getPhrase( "hello" ) )
```

##### Get a string from 'french' named 'hello' and print it out.
```lua
print( lingo:getPhrase( "hello", "french" ) )
```

##### Get the name of the current language and print it out.
```lua
print( lingo:getCurrentLanguage() )
```

##### Get a list of all loaded languages and print out the names.
```lua
local languages = lingo:getLanguages()

for i = 1, #languages, 1 do
	print( languages[ i ] )
end
```

##### Get a language and print out all the phrases.
```lua
local language = lingo:getLanguage( "english" )

for name, phrase in pairs( language ) do
	print( name, phrase )
end
```

##### Edit ( or add ) a phrase in the current language.
```lua
lingo:setPhrase( "hello", "Good afternoon!" )
```

##### Edit ( or add ) a phrase in a specific language.
```lua
lingo:setPhrase( "hello", "Guten Tag!", "german" )
```
Example Language Files
-------------------------

##### Filename: 'english.json'
```json
{
	"hello":"Hi",
	"goodbye":"Bye"
}
```

##### Filename: 'french.json'
```json
{
	"hello":"Bonjour",
	"goodbye":"Au Revoir"
}
```

##### Filename: 'german.json'
```json
{
	"hello":"Hallo",
	"goodbye":"Auf Wiedersehen"
}
```