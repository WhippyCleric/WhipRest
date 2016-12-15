type ServerConfig
  port
  responseConfigurations
end

@enum HTTP_METHOD GET POST PUT PATCH DELETE

type ResponseConfig
  method::HTTP_METHOD
  path::String
  responseHandler
end

type WhipRestServer
  port
  getMappings::Dict{String,Any}
  postMappings::Dict{String,Any}
  putMappings::Dict{String,Any}
  patchMappings::Dict{String,Any}
  deleteMappings::Dict{String,Any}
end
