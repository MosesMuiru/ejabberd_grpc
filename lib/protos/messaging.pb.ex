defmodule Da.Proto.SendMessageRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :type, 1, type: :string
  field :from, 2, type: :string
  field :to, 3, type: :string
  field :subject, 4, type: :string
  field :body, 5, type: :string
end

defmodule Da.Proto.SendMessageResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :send_confirmation, 1, type: :string, json_name: "sendConfirmation"
end

defmodule Da.Proto.InitiateSessionRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :jid, 10, type: :string
  field :server, 2, type: :string
  field :password, 3, type: :string
  field :username, 1, type: :string
end

defmodule Da.Proto.ReceivedMessage do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field :message, 1, type: :string
  field :presence, 2, type: :string
  field :from, 3, type: :string
  field :status, 4, type: :string
end

defmodule Da.Proto.MessageService.Service do
  @moduledoc false

  use GRPC.Service, name: "da.proto.MessageService", protoc_gen_elixir_version: "0.12.0"

  rpc :SendMessage, Da.Proto.SendMessageRequest, Da.Proto.SendMessageResponse

  rpc :InitiateSession, Da.Proto.InitiateSessionRequest, stream(Da.Proto.ReceivedMessage)
end

defmodule Da.Proto.MessageService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Da.Proto.MessageService.Service
end