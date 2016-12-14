module WhipRest

using HttpServer

include("beans.jl")

  export hello,
         ServerConfig


  type ServerConfig
    path::String
  end

  function hello(message::String)
    print(message)
  end

end #end module WhipRest
