defmodule EjabberdRcp.Endpoint do
  use GRPC.Endpoint
  # run(EjabberdRcp.Server)
  # run(EjabberdRcp.MessageServer)
  # run(EjabberdRcp.PresenceServer)
  run(EjabberdRcp.EjabberdServiceServer)
  run(EjabberdRcp.MessagingServiceServer)
  run(EjabberdRcp.Reflection.Server2)
  run(EjabberdRcp.Reflection.Server)
end
