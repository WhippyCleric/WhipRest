module WhipRest

using HttpServer

include("beans.jl")

  export hello,
         ServerConfig

  function hello(message::String)
    print(message)
  end

end #end module WhipRest
