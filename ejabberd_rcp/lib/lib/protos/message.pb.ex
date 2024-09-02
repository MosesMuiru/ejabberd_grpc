defmodule Message.SendMessageRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:from, 2, type: :string)
  field(:to, 3, type: :string)
  field(:subject, 4, type: :string)
  field(:body, 5, type: :string)
end

defmodule Message.SendMessageResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:send_confirmation, 1, type: :string, json_name: "sendConfirmation")
end

defmodule Message.Message.Service do
  @moduledoc false

  use GRPC.Service, name: "Message.Message", protoc_gen_elixir_version: "0.12.0"

  rpc(:SendMessage, Message.SendMessageRequest, Message.SendMessageResponse)
end

defmodule Message.Message.Stub do
  @moduledoc false

  use GRPC.Stub, service: Message.Message.Service
end
