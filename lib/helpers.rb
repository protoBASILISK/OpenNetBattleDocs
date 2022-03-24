# Helper Functions

# Iterates over collections to see if there's any substantive data in them.
# Checks nested arrays/hashes to see if there's any in there.
def is_empty( data_to_test )

    # If the value itself is nil then yes it's empty.
  return true if data_to_test.nil?
    # 'true' is never empty
  return false if data_to_test.instance_of? TrueClass
    # 'false' is always empty
  return true if data_to_test.instance_of? FalseClass

    # This has to come after true/false checks, as they don't have .empty? defined
  return true if data_to_test.empty?

    # If any of the values in an array isn't empty, the array isn't.
  if data_to_test.is_a? Array
    
    _values = data_to_test.select { |v| not is_empty( v ) }
    return _values.empty?

    # If any of the values in a hash isn't empty, the hash isn't
  elsif data_to_test.is_a? Hash

    _values = data_to_test.select { |k,v| not is_empty( v ) }
    return _values.empty?

  end

    # If we've got this far, it's probably an object, text, or number, so probably not empty
  return false if data_to_test.present?
    # Just in case
  return true
end

def load_json_data( abs_path )
  require 'json'

  _data = JSON.parse( File.read( abs_path ) )
  _data
end

  # Replaces text in the loaded JSON data with matching symbols in the provided hash.
  # json_data     : the raw JSON data
  # variable_hash : keys are the text to match, value is the text to replace the matching text with
def preprocess_json_data( json_data, variable_hash )

    # For arrays, call this function on all contained objects
  if json_data.is_a? Array
    json_data.collect!{ |var| preprocess_json_data( var, variable_hash ) }
    # For hashes, call this function on all of the values in each key-value pair
    # If you treated it like an array it would try to replace the values entirely.
  elsif json_data.is_a? Hash
    json_data.each { |key, value| json_data[key] = preprocess_json_data( value, variable_hash ) }
    # Don't touch true/false.
  elsif json_data.is_a? TrueClass or json_data.is_a? FalseClass

    # If it's none of the above, it's PROBABLY text, so replace the text.
  elsif json_data.present?
    json_data = ERB.new( json_data ).result_with_hash( variable_hash )
  end

  json_data
end

  # Validate the JSON data against the provided schemas, just as a sanity check.
def validate_json( schema_name, json_data )
  require 'rubygems'
  require 'json-schema'

  _directory = Dir.pwd + "/data/schema/schema_" + schema_name + ".json"
  
  begin
    _success = JSON::Validator.validate( _directory, json_data)
  rescue JSON::Schema::ValidationError
    return $!.message
  end

  return "true"
end