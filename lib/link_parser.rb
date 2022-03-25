def type( text )
    "<a href=\"/api/##{text.downcase}\">#{text}</a>"
end

def see( text )
    "<a href=\"/api/##{text.downcase.gsub(/[:]/, '-')}\">#{text}</a>"
end