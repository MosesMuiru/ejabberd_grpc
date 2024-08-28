defmodule EjabberdRcp.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Server.Interceptors.Logger)
  run(EjabberdRcp.Server)
end
