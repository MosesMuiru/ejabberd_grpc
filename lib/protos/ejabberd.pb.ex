defmodule Da.Proto.RegisterRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :username, 1, type: :string
  field :host, 2, type: :string
  field :password, 3, type: :string
end

defmodule Da.Proto.RegisterResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :message, 1, type: :string
  field :user_details, 2, type: :string, json_name: "userDetails"
end

defmodule Da.Proto.SetPresenceRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :user, 1, type: :string
  field :host, 2, type: :string
  field :type, 4, type: :string
  field :show, 5, type: :string
  field :status, 6, type: :string
  field :priority, 7, type: :int32
end

defmodule Da.Proto.SetPresenceResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :jid, 1, type: :string
  field :show, 2, type: :string
end

defmodule Da.Proto.GetPresenceRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :user, 1, type: :string
  field :host, 2, type: :string
end

defmodule Da.Proto.GetPresenceResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :jid, 2, type: :string
  field :show, 3, type: :string
  field :status, 5, type: :string
end

defmodule Da.Proto.EjabberdService.Service do
  @moduledoc false

  use GRPC.Service, name: "da.proto.EjabberdService", protoc_gen_elixir_version: "0.12.0"

  rpc :SetPresence, Da.Proto.SetPresenceRequest, Da.Proto.SetPresenceResponse

  rpc :GetPresence, Da.Proto.GetPresenceRequest, Da.Proto.GetPresenceResponse

  rpc :RegisterUser, Da.Proto.RegisterRequest, Da.Proto.RegisterResponse
end

defmodule Da.Proto.EjabberdService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Da.Proto.EjabberdService.Service
end