defmodule Status.SetPresenceRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:user, 1, type: :string)
  field(:host, 2, type: :string)
  field(:type, 4, type: :string)
  field(:show, 5, type: :string)
  field(:status, 6, type: :string)
  field(:priority, 7, type: :int32)
end

defmodule Status.SetPresenceResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.12.0", syntax: :proto3

  field(:user, 1, type: :string)
  field(:show, 2, type: :string)
end

defmodule Status.PresenceService.Service do
  @moduledoc false

  use GRPC.Service, name: "Status.PresenceService", protoc_gen_elixir_version: "0.12.0"

  rpc(:SetPresence, Status.SetPresenceRequest, Status.SetPresenceResponse)
end

defmodule Status.PresenceService.Stub do
  @moduledoc false

  use GRPC.Stub, service: Status.PresenceService.Service
end
