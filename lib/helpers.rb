# Helper Functions

# Iterates over collections to see if there's any substantive data in them.
# Checks nested arrays/hashes to see if there's any in there.
def is_empty( data_to_test)
  return true if data_to_test.nil?
  return true if data_to_test.empty?

  if data_to_test.is_a? Array
    
    data_to_test.each do |inner_val|
      return false if not is_empty( inner_val )
    end
    return true
  elsif data_to_test.is_a? Hash
    data_to_test.each do |val|
        _values = val.select { |k,v| v.present? }
        return false if _values.any?
    end
    return true
  end

  return false
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