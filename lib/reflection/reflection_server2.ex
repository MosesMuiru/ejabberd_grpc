defmodule EjabberdRcp.Reflection.Server2 do
  use GrpcReflection.Server,
    version: :v1alpha,
    services: [Da.Proto.EjabberdService.Service]
end
