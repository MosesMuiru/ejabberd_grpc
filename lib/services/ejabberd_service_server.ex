defmodule EjabberdRcp.EjabberdServiceServer do
  use GRPC.Server, service: Da.Proto.EjabberdService.Service

  @spec register_user(Da.Proto.RegisterRequest.t, GRPC.Server.Stream.t) :: Da.Proto.RegisterResponse.t
  def register_user(request, _stream) do
    case :ejabberd_auth.try_register(request.username, request.host, request.password) do
      :ok -> reg_response("User created succefully", "#{request.username}@#{request.host}")
      {:error, :exists} -> reg_response("user exists", "User exists")
      _ -> reg_response("ensure all details are there", "password, username, host")
    end
  end

  def reg_response(message, details) do
    %Da.Proto.RegisterResponse{
      message: message,
      user_details: details
    }
  end

  # set presence of the
  @spec set_presence(Da.Proto.SetPresenceRequest.t, GRPC.Server.Stream.t) :: Da.Proto.SetPresenceResponse.t
  def set_presence(request, _stream) do
    :ejabberd_sm.get_user_resources(request.user, request.host)
    |> case do
      [] ->
        response(request.user, "failed: user is not login or doesn't exist")

      data ->
        res = List.first(data)

        case :mod_admin_extra.set_presence(
               request.user,
               request.host,
               res,
               request.type,
               request.show,
               request.status,
               request.priority
             ) do
          :ok -> response(request.user, request.show)
          _ -> response(request.user, "failed set presence")
        end
    end
  end

  def response(user, show) do
    %Da.Proto.SetPresenceResponse{
      jid: user,
      show: show
    }
  end

  # get presence of user
   def get_presence(request, _stream) do
    {jid, show, status} = :mod_admin_extra.get_presence(request.user, request.host)
    IO.inspect(label: "jid")

    %Da.Proto.GetPresenceResponse{
      jid: jid,
      show: show,
      status: status
    }
  end

  def end_session(request, _stream) do
    case :ejabberd_sm.kick_user(request.username, request.host) do
      0 -> end_session_response("session of the user #{request.username} is not active")
      1 -> end_session_response("session of user #{request.username} terminated")
    end
  end

  @spec end_session_response(String.t()) :: any()
  defp end_session_response(response) do
    %Da.Proto.EndSessionResponse{
      response: response
    }
  end

  @spec create_room(Da.Proto.CreateRoomRequest.t(), GRPC.Server.Stream.t()) :: any()
  def create_room(request, _stream) do
    :mod_muc_admin.create_room(request.name, request.service, request.host)
    |> case do
      :ok -> %Da.Proto.CreateRoomResponse{
        name: request.name,
        host: request.host
      }
      _ -> %Da.Proto.CreateRoomResponse{
        name: "Could not create room" ,
        host: "could not create room"
      }
    end
  end

end
