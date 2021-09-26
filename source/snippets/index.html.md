---
title: OpenNetBattle Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - lua

toc_footers:
  - <a href='https://github.com/TheMaverickProgrammer/OpenNetBattle'>OpenNetBattle @ GitHub</a>
  - <a href='https://github.com/protoBASILISK/OpenNetBattleDocs'>OpenNetBattle Docs @ GitHub</a>
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

includes:

search: true

code_clipboard: true

meta:
  - name: OpenNetBattle
    content: Documentation for the OpenNetBattle Engine
---

*More code snippets will be provided here in the future.*

# Creating an Entity

```lua
local scriptedArtifact = Battle.Artifact.new( Team.Red )
local scriptedCharacter = Battle.Character.new( )
local scriptedSpell = Battle.Spell.new( Team.Red )
local scriptedObstacle = Battle.Obstacle.new( Team.Red )
```
> The above snippets create a `ScriptedArtifact`, a `ScriptedCharacter`, a `ScriptedSpell`, and a `ScriptedObstacle`.

For the most part, only **"scripted"** versions of **Entity** objects can be created within a Lua script.<br>
`ScriptedPlayer` objects cannot be manually created *at all*, and are created *by the engine* when entering a battle scene with a custom character selected.

# Debugging
Sometimes things just go wrong for no visible reason. And you swear that it's not something you did.<br>
The functions 

```lua
function dump_global_table()
	print( "" )
	print( "Dumping Environment State:" )
	print( "" )
	
	for n,v in pairs ( _G ) do
		print ( n, "::", v )
	end
	
	print( "" )
	print( "Finished Dumping Environment State:" )
	print( "" )
end

dump_global_table()
```
> The code snippet above will print all of the functions and variables available <i>in the global namespace</i>.

```lua
local exampleEntity	-- Example entity, works on any variable type

function dump_metatable( value )
	print( "" )
	print( "Dumping Metatable:", value )
	print( "" )
	
	for k,v in pairs( getmetatable( value ) ) do
		print( k, "::", v )
	end
	
	print( "" )
	print( "Finished dumping metatable." )
	print( "" )
end

dump_metatable( exampleEntity )
```
> The code snippet above will print all of the functions and variables available <i>to a specific variable</i>.<br>
> If the game is complaining about <b><code>'nil'</code></b> values, you may have misspelled something, or tried to access something that doesn't exist.

### 
#### Function Call
#### Return Value
#### Parameters
```
