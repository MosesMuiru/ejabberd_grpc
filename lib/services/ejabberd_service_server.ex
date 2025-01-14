defmodule EjabberdRcp.EjabberdServiceServer do
  use GRPC.Server, service: Da.Proto.EjabberdService.Service

  alias EjabberdRcp.MessagesDb

  @spec register_user(Da.Proto.RegisterRequest.t(), GRPC.Server.Stream.t()) ::
          Da.Proto.RegisterResponse.t()
  def register_user(request, _stream) do
    case :ejabberd_auth.try_register(request.username, request.host, request.password) do
      :ok -> reg_response("User created succefully", "#{request.username}@#{request.host}")
      {:error, :exists} -> reg_response("user exists", "User exists")
      _ -> reg_response("ensure all details are there", "password, username, host")
    end
  end

  # this will contain serivecs of the message
  # sending, recieving and initiating a session
  @spec send_messages(Da.Proto.SendMessagesRequest.t(), GRPC.Server.Stream.t()) ::
          Da.Proto.SendMessagesResponse.t()
  def send_messages(request, _stream) do
    :mod_admin_extra.send_message(
      request.type,
      request.from,
      request.to,
      request.subject,
      request.body
    )
    |> case do
      :ok ->
        %Da.Proto.SendMessagesResponse{
          response: "0"
        }
    end
  end

  def reg_response(message, details) do
    %Da.Proto.RegisterResponse{
      message: message,
      user_details: details
    }
  end

  # set presence of the
  @spec set_presence(Da.Proto.SetPresenceRequest.t(), GRPC.Server.Stream.t()) ::
          Da.Proto.SetPresenceResponse.t()
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
    option = [
      {"title", request.options.title},
      {"description", request.options.description},
      {"members_only", request.options.members_only},
      {"max_users", request.options.max_users},
      {"allow_user_invites", request.options.allow_user_invites},
      {"public", request.options.public},
      {"persistent", "true"},
      {"affiliations", "#{request.options.affliations}@localhost"},
      {"subscribers", "#{request.options.subscribers}@localhost:messages:subject"},
      {"allow_subscription", "true"}
    ]

    :mod_muc_admin.create_room_with_opts(request.name, request.service, request.host, option)
    |> case do
      :ok ->
        %Da.Proto.CreateRoomResponse{
          name: request.name,
          host: request.host
        }

      _ ->
        %Da.Proto.CreateRoomResponse{
          name: "Could not create room",
          host: "could not create room"
        }
    end
  end

  def invite_user(request, _stream) do
    nodes = [
      "urn:xmpp:mucsub:nodes:messages",
      "urn:xmpp:mucsub:nodes:affiliations"
    ]

    :mod_muc_admin.subscribe_room(request.user, request.nick, request.room, nodes)
    |> case do
      {:error, reason} ->
        %Da.Proto.InviteUserResponse{
          status: reason
        }

      _ ->
        %Da.Proto.InviteUserResponse{
          status: "invite sent"
        }
    end
  end

  def send_direct_invitation(request, _stream) do
    :mod_muc_admin.send_direct_invitation(
      request.room_name,
      request.service,
      request.password,
      request.invite_description,
      request.jids
    )
    |> case do
      {:error, reason} ->
        %Da.Proto.InviteUserResponse{
          status: reason
        }

      :ok ->
        %Da.Proto.InviteUserResponse{
          status: "Invite sent"
        }
    end
  end

  def get_user_rooms(request, _stream) do
    :mod_muc_admin.get_user_rooms(request.user, "conference.localhost")
    |> case do
      [rooms] ->
        %Da.Proto.GetUserRoomsResponse{
          rooms: [rooms]
        }

      _ ->
        %Da.Proto.GetUserRoomsResponse{
          rooms: ""
        }
    end
  end

  def get_subscribers(request, _stream) do
    :mod_muc_admin.get_subscribers(request.room_name, request.service)
    |> case do
      [subscribers] ->
        %Da.Proto.GetSubscribersResponse{
          user: [subscribers]
        }

      _ ->
        %Da.Proto.GetSubscribersResponse{
          user: ["empty or room doesn't exists"]
        }
    end
  end

  def get_room_occupants(request, _stream) do
    :mod_muc_admin.get_room_occupants(request.room_name, "conference.localhost")
    |> case do
      user_details ->
        f_user_details =
          user_details
          |> format_user_details()

        %Da.Proto.GetRoomOccupantsResponse{
          user_details: f_user_details
        }

      _ ->
        %Da.Proto.GetRoomOccupantsResponse{
          user_details: []
        }
    end
  end

  def destroy_room(request, _stream) do
    :mod_muc_admin.destroy_room(request.room_name, request.service)
    |> case do
      # {:error, _reason} ->
      #   %Da.Proto.DestroyRoomResponse{
      #     status: 0
      # }
      :ok ->
        %Da.Proto.DestroyRoomResponse{
          status: 200
        }

      _ ->
        %Da.Proto.DestroyRoomResponse{
          status: 0
        }
    end
  end

  #  getting messagse all and by username

  def get_all_messages(_request, _stream) do

    messages = MessagesDb.get_all_messages()
    %Da.Proto.GetAllMessagesResponse{
      messages: messages
    }
  end

  def get_messages_by_username(request, _) do
    messages = MessagesDb.get_messages_by_username(request.username)
    %Da.Proto.GetMessagesByUsernameResponse{
      messages: messages
    }
  end

  # create a map from the user details
  def format_user_details([{_, jid, role} | tail]) do
    IO.inspect(tail, label: "working")
    [%{jid => to_string(role)} | format_user_details(tail)]
  end

  def format_user_details([]), do: []
end
