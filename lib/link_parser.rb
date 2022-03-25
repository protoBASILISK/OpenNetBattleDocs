def type( text )
    "<a class=\"class_link\" href=\"/api/##{text.downcase}\">#{text}</a>"
end

def see( text )
    "<a class=\"class_link\" href=\"/api/##{text.downcase.gsub(/[:]/, '-')}\">#{text}</a>"
end