class LinkParser
    include Singleton

    attr_accessor :path_prefix

    def set_path_prefix( path_prefix )
        if path_prefix.nil? then return end
        @@path_prefix = path_prefix
    end

    def type( text )
        "<a class=\"class_link\" href=\"#{@@path_prefix}api/##{text.downcase}\">#{text}</a>"
    end
    
    def see( text )
        "<a class=\"class_link\" href=\"#{@@path_prefix}api/##{text.downcase.gsub(/[:]/, '-')}\">#{text}</a>"
    end
end
  
def type( name )
  LinkParser.instance.type( name )
end
def see( name )
  LinkParser.instance.see( name )
end