defmodule EjabberdRcp.Endpoint do
  use GRPC.Endpoint
  # run(EjabberdRcp.Server)
  # run(EjabberdRcp.MessageServer)
  # run(EjabberdRcp.PresenceServer)
  intercept(GRPC.Server.Interceptors.Logger)
  run(EjabberdRcp.EjabberdServiceServer)
  run(EjabberdRcp.MessagingServiceServer)
end
