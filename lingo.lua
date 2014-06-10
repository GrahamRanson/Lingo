------------------------------------------------------------------
-- Project: Lingo 												--
--																--
-- Description: A translation library for the Corona SDK. 		--
--				Doesn't actually do any translation, just       --
--				used to store and look up translated phrases.	--
--																--
-- Requirements: None.											--
--																--
-- File name: lingo.lua											--
--																--
-- Creation Date: June 10, 2014									--
--																--
-- Email: graham@grahamranson.co.uk								--
--																--
-- Twitter: @GrahamRanson										--
--																--
-- Website: www.grahamranson.co.uk								--
--																--
-- Copyright (C) 2014 Graham Ranson. All rights reserved.		--
--																--
------------------------------------------------------------------

-- Main class table
local Lingo = {}
local Lingo_mt = { __index = Lingo }

-- Overridden functions

-- Required libraries
local json = require( "json" )

-- Localised functions
local encode = json.encode
local decode = json.decode
local open = io.open
local close = io.close
local pathForFile = system.pathForFile
local attributes = lfs.attributes
local type = type
local print = print
local pairs = pairs 

-- Localised variables
local ResourceDirectory = system.ResourceDirectory

-- Class values

------------------
--	CONSTRUCTOR --
------------------

--- Initiates a new Lingo object.
-- @return The new object.
function Lingo:new()

	local self = {}

	setmetatable( self, Lingo_mt )

	self._languages = {}
	self._currentLanguage = nil

    return self
    
end

-----------------------
--	PUBLIC FUNCTIONS --
-----------------------

-- Loads a language from disk.
-- @param name The name of the language.
-- @param path The path to the directory that the language file is in. Optional, defaults to the root directory.
-- @param baseDir The base directory that the language file is in. Optional, defaults to system.ResourceDirectory.
function Lingo:loadLanguage( name, path, baseDir )

	local path = self:_createPath( name, path, baseDir )

	if self:_fileExists( path ) then
		self._languages[ name ] = self:_readFile( path )
		if not self:getCurrentLanguage() then
			self:_info( "Current language set to " .. name .. "." )
			self:setCurrentLanguage( name )
		end
	else
		self:_warning( "Language file located at " .. path .. " not found."  )
	end

end

-- Gets the name of the current language.
-- @return The name of the language.
function Lingo:getCurrentLanguage()
	return self._currentLanguage
end

-- Sets the name of the current language.
-- @param name The name of the language.
function Lingo:setCurrentLanguage( name )
	self._currentLanguage = name
end

-- Gets a phrase from a language.
-- @param name The name of the phrase.
-- @param language The name of the language. Optional, defaults to the current one.
-- @return The translated phrase. If none found then it will return the passed in name.
function Lingo:getPhrase( name, language )

	local phrase = name
	language = language or self:getCurrentLanguage()

	if language then
		if self._languages[ language ] then
			phrase = self._languages[ language ][ name ]
		end
	else
		if self:getCurrentLanguage() then
			self:_warning( "Language called " .. language .. " not found."  )
		else
			self:_warning( "Current language has not been set."  )
		end
	end

	return phrase

end

-- Gets a list of all loaded languages.
-- @return A table containing the names of all the loaded languages.
function Lingo:getLanguages()
	
	local languages = {}
	
	for name, _ in pairs( self._languages ) do
		languages[ #languages + 1 ] = name
	
	end
	
	return languages

end

-----------------------
--	PRIVATE FUNCTIONS --
-----------------------

-- Creates a path to a language file.
-- @param name The name of the file.
-- @param path The path to the directory the file is in. Optional, defaults to the root directory.
-- @param baseDir The base directory of the path. Optional, defaults to system.ResourceDirectory.
-- @return The created path.
function Lingo:_createPath( name, path, baseDir )

	if path and type( path ) ~= "string" then
		baseDir = path
		path = ""
	end

	return pathForFile( ( path or "" ) .. name .. "." .. "json", baseDir or ResourceDirectory )

end


-- Displays an error to the command line.
-- @param message The message to display.
function Lingo:_error( message )
	print( "Lingo Error: " .. message )
end

-- Displays a warning to the command line.
-- @param message The message to display.
function Lingo:_warning( message )
	print( "Lingo Warning: " .. message )
end

-- Displays some info to the command line.
-- @param message The message to display.
function Lingo:_info( message )
	print( "Lingo Info: " .. message )
end

-- Read in the contents of a file.
-- @return The read in data.
function Lingo:_readFile( path )

	-- Open the file for reading.
	local file = open( path, "r" )

	-- If the file exists then we need to load it up and decrypt it
	if file then
		
		-- Read in the data and close the file.
		local data = file:read( "*a" )

		close( file )
		file = nil

		if data then
			
			-- Remove the base 64 encoding.
			data = decode( data )

			-- Return the data
			return data

		end

	end	

end

--- Checks if a file exists.
-- @return True if it exists, false otherwise.
function Lingo:_fileExists( path )
	return attributes( path, "mode" ) == "file"
end

---------------------
--	EVENT HANDLERS --
---------------------

-- Return the class table.
return Lingo