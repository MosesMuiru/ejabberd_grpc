defmodule EjabberdRcp.EjabberdServiceServer do
  use GRPC.Server,
    service: Da.Proto.EjabberdService.Service,
    http_transcode: true

  alias EjabberdRcp.MessagesDb
  alias EjabberdRcp.InvitesRepo
  alias EjabberdRcp.RoomsRepo
  alias EjabberRcp.ReactionsRepo
  alias EjabberdRcp.SavesRepo
  alias EjabberdRcp.ReminderRepo
  alias EjabberdRcp.ThreadsRepo
  alias EjabberdRcp.ThreadsDb
  alias EjabberdRcp.MentionsRepo
  alias EjabberdRcp.MentionsDb

  # @spec register_user(Da.Proto.RegisterRequest.t(), GRPC.Server.Stream.t()) ::
  #         Da.Proto.RegisterResponse.t()
  # def register_user(request, _stream) do
  #   case :ejabberd_auth.try_register(request.username, request.host, request.password) do
  #     :ok -> reg_response(request.password, "#{request.username}@#{request.host}")
  #     {:error, :exists} -> reg_response("user exists", "User exists")
  #     _ -> reg_response("Use Correct Credentials", "password, username, host")
  #   end
  # end

  # def reg_response(message, details) do
  #   %Da.Proto.RegisterResponse{
  #     password: message,
  #     user_details: details
  #   }
  # end

  def register_user_ejabberd(request, _stream) do
    :ejabberd_auth.try_register(request.username, request.host, request.password)
    |> case do
      :ok -> %Da.Proto.RegisterUserToEjabberdResponse{
        response: "#{request.username}@#{request.host}",
      }
    end
  end

  # def register_user(request, _stream) do
  #   :ejabberd_auth.try_register(request.username, request.host, request.password)
  #   |> case do

  #     :ok ->  %Da.Proto.RegisterResponse{
  #       user_details: "#{request.username}@#{request.host}"
  #     }
  #     _  -> %Da.Proto.RegisterResponse{
  #       user_details: "errori, make sure you enter the correct details"
  #     }
  #   end
  # end

  # this will contain serivecs of the message
  # sending, recieving and initiating a session
  @spec send_messages(Da.Proto.SendMessagesRequest.t(), GRPC.Server.Stream.t()) ::
          Da.Proto.SendMessagesResponse.t()
  def send_messages(request, _stream) do
    IO.inspect(request.filecontent == nil, label: "thi si request")
    mention_from =
      request.from
      |> String.split("@")
      |> List.first()

    if request.type == "groupchat" do
      scan_for_mentions(mention_from, request.body)
    end

    if request.filecontent != nil do
      {s3_url, stanza} = send_stanza(request)

      :mod_admin_extra.send_stanza(request.from, request.to, stanza)
      |> case do
        :ok ->
          %Da.Proto.SendMessagesResponse{
            response: s3_url
          }
      end

    else

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

  end

  def send_stanza(request) do
    # upload the content to aws
    s3_url = EjabberdRcp.S3Client.uploader(request.filecontent, request.filename)

    stanza =
    "
    <message
    from='#{request.from}'
    id='#{Ecto.UUID.generate()}'
    to='#{request.to}'
    type='#{request.type}'>
    <body>#{request.body}</body>
    <attachment xmlns='urn:xmpp:http:upload:0'>
      <url>#{s3_url}</url>
    </attachment>
    </message>
    "
    {s3_url, stanza}
  end

  def scan_for_mentions(mention_from, message) do
    regex = ~r/@([\w\d_]+)/u

    Regex.scan(regex, message)
    |> case do
      [] ->
        message

      mentions ->
        mentions
        |> Enum.map(fn [_, mention_to] ->
          user_ids =
            MentionsRepo.get_ids_from_username(mention_from, mention_to)
            |> IO.inspect(label: "this si the retuns")

          # insert the ids to the databases
          %MentionsDb{
            user_id: user_ids.mention_to,
            mention_from: user_ids.mention_from,
            message: message
          }
          |> MentionsRepo.insert_mention()
        end)
    end
  end

  # forward stanza
  def forward_message(request, _stream) do
    IO.inspect(request.forward_details.body, label: "this is working")

    req =
      "<message to='#{request.forward_to}' from='#{request.forward_from}' id='#{:p1_rand.get_string()}' type='#{request.forward_type}'>
  <body>#{request.forward_body}</body>
  <forwarded xmlns='urn:xmpp:forward:0'>
    <delay xmlns='urn:xmpp:delay' stamp='2010-07-10T23:08:25Z'/>
    <message from='#{request.forward_details.from}'
             to='#{request.forward_details.to}'
             type='#{request.forward_details.type}'
             xmlns='jabber:client'>
      <body>#{request.forward_details.body}</body>
      <mood xmlns='http://jabber.org/protocol/mood'>
        <amorous/>
      </mood>
    </message>
  </forwarded>
</message>"

    IO.inspect(req, label: "request")

    :mod_admin_extra.send_stanza(request.forward_from, request.forward_to, req)
    |> IO.inspect(label: "the forwarding is sent")

    request
    |> IO.inspect(label: "this is the stanza that will be forwaded")

    %Da.Proto.ForwardMessageResponse{
      response: "sent"
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

    [_, name] = String.split(request.options.affliations, ":")

    :mod_muc_admin.create_room_with_opts(request.name, request.service, request.host, option)
    |> case do
      :ok ->
        %EjabberdRcp.Rooms{
          user_jid: "#{name}@#{request.host}",
          room_jid: "#{request.name}@#{request.service}"
        }
        |> EjabberdRcp.RoomsRepo.insert_room()

        %Da.Proto.CreateRoomResponse{
          name: request.name,
          host: request.host
        }

      #
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
    Enum.map(request.jids, fn jid ->
      %EjabberdRcp.Invites{
        to: jid,
        description: request.invite_description,
        password: request.password,
        accepted: false,
        rooms_id: request.room_id
      }
      |> EjabberdRcp.InvitesRepo.insert_invite()
    end)

    %Da.Proto.InviteUserResponse{
      status: "Invite sent"
    }
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

        # _ ->
        # %Da.Proto.GetRoomOccupantsResponse{
        # user_details: []
        # }
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

  def accept_invitation(request, _stream) do
    %{rooms_id: rooms_id} = invite = InvitesRepo.get_invite_by_uuid(request.uuid)

    room = RoomsRepo.get_room_by_id(rooms_id)

    new_invite = Ecto.Changeset.change(invite, accepted: true)

    %EjabberdRcp.Rooms{
      user_jid: invite.to,
      room_jid: room.room_jid
    }
    |> RoomsRepo.insert_room()

    case EjabberdRcp.Repo.update(new_invite) do
      {:ok, invite} ->
        %Da.Proto.AcceptInvitationResponse{
          id: invite.id,
          uuid: invite.uuid,
          to: invite.to,
          description: invite.description,
          rooms_id: room.id,
          accepted: invite.accepted
        }
    end
  end

  # reactions
  def get_all_reactions(request, _stream) do
    all_reactions = ReactionsRepo.get_all_reactions()

    %Da.Proto.GetAllReactionsResponse{
      reactions: all_reactions
    }
  end

  def react_to_message(request, _stream) do
    # create a process based on the message id
    #

    reaction_res =
      %EjabberdRcp.UserReaction{
        archive_origin_id: request.message_id,
        username: request.username,
        reactions_id: String.to_integer(request.reaction_id)
      }
      |> EjabberdRcp.ReactionsRepo.insert_user_reactions()

    # reaction_process_name = String.to_atom(request.message_id)
    # if the process exists re_register it with the same name
    # to make sure that the process exist always
    # :global.register_name(reaction_process_name, pid)
    # |> case do
    # :no ->
    # :global.re_register_name(reaction_process_name, pid)

    # :yes ->
    # end

    %Da.Proto.ReactToMessageResponse{
      message_id: reaction_res.archive_origin_id,
      reaction_id: reaction_res.reactions_id,
      username: reaction_res.username
    }
  end

  # message actions
  def pin_message(request, _stream) do
    MessagesDb.pin_message(request.message_id, request.username, request.pin)
    |> case do
      {1, nil} ->
        %Da.Proto.PinMessageResponse{
          pinned: request.pin
        }
    end
  end

  def delete_message(request, _stream) do
    EjabberdRcp.MessagesDb.delete_message_by_id(request.message_id)

    %Da.Proto.DeleteMessageResponse{
      response: 0
    }
  end

  def save_message(request, _stream) do
    {:ok, saves} = SavesRepo.save_a_message(request.message_id, request.user_id)

    %Da.Proto.SaveMessageRequest{
      message_id: saves.archive_id
    }
  end

  def get_saved_messages_by_user_id(request, _stream) do
    saves = SavesRepo.get_saved_message_by_user_id(request.user_id)

    %Da.Proto.GetSavedMessagesByUserIdResponse{
      messages: saves
    }
  end

  def unsave_message(request, _stream) do
    {count, _} = SavesRepo.unsave_message(request.user_id)

    %Da.Proto.UnsaveMessageResponse{
      response: count
    }
  end

  def add_reminder(request, _stream) do
    {:ok, datetime, 0} = DateTime.from_iso8601(request.execution_time)

    %EjabberdRcp.ReminderDb{
      archive_id: request.message_id,
      user_id: request.user_id,
      schedule_date: datetime,
      completed: false
    }
    |> EjabberdRcp.ReminderRepo.create_reminder()
    |> case do
      {:ok, job} ->
        %Da.Proto.AddReminderResponse{
          job_id: job.id
        }
    end
  end

  def get_reminders(request, _stream) do
    reminder = ReminderRepo.fetch_reminder_by_user_id(request.user_id)

    %Da.Proto.GetRemindersResponse{
      reminder: reminder
    }
  end

  # threads
  def create_thread(request, _stream) do
    %ThreadsDb{
      user_id: request.user_id
    }
    |> ThreadsRepo.create_thread()
    |> case do
      {:ok, thread} ->
        %Da.Proto.CreateMessagingThreadResponse{
          thread_uuid: thread.uuid
        }
    end
  end

  def send_thread_message(request, _stream) do
    stanza = "
   <message
   to='#{request.to}'
   from='#{request.from}'
   id='#{:p1_rand.get_string()}'
   type='#{request.type}'
   xml:lang='en'>
   <body>#{request.body}</body>
   <thread parent='#{request.parent_id}'>
   #{request.thread_uuid}
   </thread>
   </message>"

    :mod_admin_extra.send_stanza(request.from, request.to, stanza)

    %Da.Proto.SendThreadMessageResponse{
      response: "sent"
    }
  end

  # def fetch_from_messages(request, _stream) do

  #   messages = MessagesDb.search_in_messages(request.user_id, request.sender_id, request.searching_for)

  #   %Da.Proto.FetchFromMessagesResponse{
  #     messages: messages
  #   }

  # end

  # a process that seeds data to db
  @spec create_a_process_based_on_message_id(map()) :: pid()
  def create_a_process_based_on_message_id(reaction) do
    spawn(EjabberdRcp.ReactionsRepo, :insert_user_reactions, [reaction])
  end

  # create a map from the user details
  def format_user_details([{_, jid, role} | tail]) do
    [%{jid => to_string(role)} | format_user_details(tail)]
  end

  def format_user_details([]), do: []
end
