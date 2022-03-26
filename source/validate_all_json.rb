#!/usr/bin/env ruby

require 'rubygems'
require 'json-schema'

# Invoke in the 'source' directory, then move to the 'data' directory.
# Doesn't like ruby files being anywhere but in the 'source' directory.
Dir.chdir("../data/")

# Provide the '--a' option to the command line when invoking, to have it print out all the validated files.
# Even if they do pass validation.
ARG_PRINT_ALL = (false || ARGV.include?("--a"))

COLOURS = {}
COLOURS[:green]     = "\u001b[32m"
COLOURS[:magenta]   = "\u001b[35m"
COLOURS[:red]       = "\u001b[31m"
COLOURS[:yellow]    = "\u001b[33m"
COLOURS[:reset]     = "\u001b[0m"

FileEntry = Struct.new( :dir, :child_dirs, :files )

def populate( path )
    entry = FileEntry.new( path, [], Hash.new() )

    Dir.each_child(path) do |p|
        if File.directory?( "#{path}/#{p}" ) then
            entry.child_dirs << populate( "#{path}/#{p}" ) unless p.include? "schema"
        else
            entry.files[p] = { file_name: p, message: "" }
        end
    end

    entry
end

def validate( file_entry )
    file_entry.child_dirs.each do |child|
        validate( child )
    end

    file_entry.files.each do |file_name, child|
        child[:message] = validate_json( file_entry.dir, child[:file_name] )
    end
end

def print_results( file_entry )
    file_entry.child_dirs.each do |child|
        print_results( child )
    end

    file_entry.files.each do |file_name, child|            
        if child[:message] then
            puts "❌ #{COLOURS[:red]}#{file_entry.dir}/#{file_name}\t - #{child[:message]}#{COLOURS[:reset]}"
        elsif ARG_PRINT_ALL
            puts "👌 #{COLOURS[:green]}#{file_entry.dir}/#{file_name}#{COLOURS[:reset]}"
        end
    end
end

# Validate the JSON data against the provided schemas, just as a sanity check.
def validate_json( path, file_name )
    _schema_type    = get_schema_type( path, file_name )
    _json_data      = load_json_data( "#{path}/#{file_name}")

    if file_name.include? "skeleton" then
        validate_json_skeleton( _schema_type, _json_data )
    else
        validate_json_file( _schema_type, _json_data )
    end
end

def load_json_data( abs_path )
    require 'json'
  
    _data = JSON.parse( File.read( abs_path ) )
    _data
end

def get_schema_type( path, entry )
        # "Skeletons" for quick copy-pasting all have it at the start of the filename.
    if entry.include? "skeleton" then
        return entry.split( "_" )[0]
    end

        # Otherwise deduce what it is from directory structure.
    parent_dir = path.split( '/' ).last

    if parent_dir.include? "class"
        return "class"
    elsif parent_dir.include? "properties"
        return "property"
    elsif parent_dir.include? "callback"
        return "callback"
    elsif parent_dir.include? "enum"
        return "enum"
    elsif parent_dir.include? "function"
        return "function"
    else
        return "subclass"
    end
end

def validate_json_file( schema_name, json_data )
    _schema = Dir.pwd + "/schema/schema_#{schema_name}.json"

    begin
        JSON::Validator.validate!( _schema, json_data, :strict => true )
    rescue JSON::Schema::ValidationError => e
        e.message
    end

    false
end

def validate_json_skeleton( schema_name, json_data )
    _schema = Dir.pwd + "/schema/schema_#{schema_name}.json"

    begin
        JSON::Validator.validate!( _schema, json_data, :strict => true )
    rescue JSON::Schema::ValidationError => e
        e.message
    end

    false
end


filesys = populate( Dir.pwd )
validate( filesys )
print_results( filesys )