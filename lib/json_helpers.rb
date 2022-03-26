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