defmodule EjabberdRcp.Server do
  use GRPC.Server, service: RegisterUsers.Register.Service
  # make a function for registering users

  def register_user(request, _) do
    case :ejabberd_auth.try_register(request.username, request.host, request.password) do
      :ok -> response("User created succefully", "#{request.username}@#{request.host}")
      {:error, :exists} -> response("user exists", "User exists")
      _ -> response("error", "error")
    end
  end

  def response(message, details) do
    %RegisterUsers.RegisterResponse{
      message: message,
      user_details: details
    }
  end

  # get presence
  #
  def get_presence(request, _) do
    {jid, show, status} = :mod_admin_extra.get_presence(request.username, request.host)

    %RegisterUsers.GetPresenceResponse{
      jid: jid,
      show: show,
      status: status
    }
  end
end
