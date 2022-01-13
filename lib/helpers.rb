# Helper Functions

# Iterates over collections to see if there's any substantive data in them.
# Checks nested arrays/hashes to see if there's any in there.
def is_empty( data_to_test )
  return true if data_to_test.nil?
  return false if data_to_test.instance_of? TrueClass
  return true if data_to_test.instance_of? FalseClass
  return true if data_to_test.empty?

  if data_to_test.is_a? Array
    
    _values = data_to_test.select { |v| not is_empty( v ) }
    return _values.empty?

  elsif data_to_test.is_a? Hash

    _values = data_to_test.select { |k,v| not is_empty( v ) }
    return _values.empty?

  end

  return false if data_to_test.present?
  return true
end

def load_json_data( abs_path )
  require 'json'

  _data = JSON.parse( File.read( abs_path ) )
  _data
end

def preprocess_json_data( json_data, variable_hash )

  if json_data.is_a? Array
    json_data.collect!{ |var| preprocess_json_data( var, variable_hash ) }
  elsif json_data.is_a? Hash
    json_data.each { |key, value| json_data[key] = preprocess_json_data( value, variable_hash ) }
  elsif json_data.is_a? TrueClass or json_data.is_a? FalseClass

  elsif json_data.present?
    json_data = ERB.new( json_data ).result_with_hash( variable_hash )
  end

  json_data
end

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