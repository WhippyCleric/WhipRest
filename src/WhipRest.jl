module WhipRest

using HttpServer

include("beans.jl")

  export ServerConfig, ResponseConfig, WhipRestServer, RestMessage, GET, POST, PUT, PATCH, DELETE, createServer, startServer


  function createServer(config::ServerConfig)
    restServer = WhipRestServer(config.port, Dict{String,Any}(),  Dict{String,Any}(), Dict{String,Any}(), Dict{String,Any}(), Dict{String,Any}())
    #Iterate over all the request response mappings
    for i = 1:length(config.responseConfigurations)
        responseConfiguration = config.responseConfigurations[i]
        #get the correct mappings set based on HTTP method
        mappings = getMappings(restServer, responseConfiguration.method)
        #Put the response handler into map for the given path
        mappings[responseConfiguration.path] = responseConfiguration.responseHandler
    end
    return restServer
  end

  function startServer(whipServer::WhipRestServer)
    #Create a new HTTP handler
    http = HttpHandler() do req::Request, res::Response
      #Get the mappings of path to action based on HTTP method
      mappings = getMappings(whipServer, getHTTP_METHOD(req.method))
      try
        #Extract the path from the request resource
        path = getPath(req.resource)
        #Try to find the function for the mapping
        responseHandler = mappings[String(path)]
        #Call the handler for this path with the content after the path
        params = getParams(req.resource)
        println("DONNE")
        Response(responseHandler(RestMessage(params, req.data)))
      catch error
        if isa(error, KeyError)
           #No mapping was found for this path
           Response("404")
        end
      end

    end
    server = Server(http)
    run(server, whipServer.port)
  end

  function getPath(resource::String)
    #Get the entire resource from the first / to the ? or the end of string
    paramIndex = search(resource, '?')
    if paramIndex==0
      #Trim the / off the end if it exists
      if resource[end] == '/'
        path = resource[1:end-1]
      else
        path = resource[1:end]
      end
    else
      path = resource[1:paramIndex-1]
    end
    return path
  end

  function getParams(resource::String)
    paramIndex = search(resource, '?')
    paramsMap = Dict{String,String}()
    if paramIndex==0
      return paramsMap
    else
      params = split(resource[paramIndex+1:end], '&')
      for i = 1:length(params)
        pair = split(params[i], '=')
        paramsMap[pair[1]] = String(pair[2])
      end

      return paramsMap
    end
  end

  function getHTTP_METHOD(method::String)
    if method == "GET"
      return GET
    elseif method== "POST"
      return POST
    elseif method == "PUT"
      return PUT
    elseif method == "PATCH"
      return PATCH
    elseif method == "DELETE"
      return DELETE
    end
  end

  function getMappings(whipServer::WhipRestServer, method::HTTP_METHOD)
    if GET == method
      return whipServer.getMappings
    elseif POST == method
      return whipServer.postMappings
    elseif PUT == method
      return whipServer.putMappings
    elseif PACTH == method
      return whipServer.patchMappings
    elseif DELETE == method
      return whipServer.deleteMappings
    end
  end

end #end module WhipRest
