defmodule EjabberdRcp.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Server.Interceptors.Logger)
  # run(EjabberdRcp.Server)
  # run(EjabberdRcp.MessageServer)
  # run(EjabberdRcp.PresenceServer)
  run(EjabberdRcp.EjabberdServiceServer)
  run(EjabberdRcp.MessagingServiceServer)
end
