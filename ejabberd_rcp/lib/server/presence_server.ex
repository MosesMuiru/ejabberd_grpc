defmodule EjabberdRcp.PresenceServer do
  use GRPC.Server, service: Status.PresenceService.Service

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
    %Status.SetPresenceResponse{
      user: user,
      show: show
    }
  end
end
