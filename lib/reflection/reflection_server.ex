defmodule EjabberdRcp.Reflection.Server do
  use GrpcReflection.Server,
    version: :v1,
    services: [
      Da.Proto.EjabberdService.Service
    ]
end
