module WhipRest

using HttpServer

include("beans.jl")

  export ServerConfig, hello


  type ServerConfig
    x
  end

  function hello(message::String)
    print(message)
  end

end #end module WhipRest
