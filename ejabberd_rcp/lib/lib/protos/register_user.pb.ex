defmodule RegisterUsers.RegisterRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:username, 1, type: :string)
  field(:host, 2, type: :string)
  field(:password, 3, type: :string)
end

defmodule RegisterUsers.RegisterResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:message, 1, type: :string)
  field(:user_details, 2, type: :string, json_name: "userDetails")
end

defmodule RegisterUsers.GetPresenceRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:username, 1, type: :string)
  field(:host, 2, type: :string)
end

defmodule RegisterUsers.GetPresenceResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:jid, 1, type: :string)
  field(:show, 2, type: :string)
  field(:status, 3, type: :string)
end

defmodule RegisterUsers.Register.Service do
  @moduledoc false

  use GRPC.Service, name: "RegisterUsers.Register", protoc_gen_elixir_version: "0.12.0"

  rpc(:RegisterUser, RegisterUsers.RegisterRequest, RegisterUsers.RegisterResponse)

  rpc(:GetPresence, RegisterUsers.GetPresenceRequest, RegisterUsers.GetPresenceResponse)
end

defmodule RegisterUsers.Register.Stub do
  @moduledoc false

  use GRPC.Stub, service: RegisterUsers.Register.Service
end
