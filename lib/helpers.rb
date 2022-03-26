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