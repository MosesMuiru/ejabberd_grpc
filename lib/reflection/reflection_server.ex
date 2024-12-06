defmodule EjabberdRcp.Reflection.Server do
  use GrpcReflection.Server,
    version: :v1,
    services: [
      EjabberdRcp.EjabberdServiceServer,
      EjabberdRcp.MessagingServiceServer
    ]
end
