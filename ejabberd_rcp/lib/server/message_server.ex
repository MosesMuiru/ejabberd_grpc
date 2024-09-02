defmodule EjabberdRcp.MessageServer do
  use GRPC.Server, service: Message.Message.Service

  def send_message(request, _stream) do
    case :mod_admin_extra.send_message(
           request.type,
           request.from,
           request.to,
           request.subject,
           request.body
         ) do
      :ok ->
        send_confirmation("message sent to #{request.to}")

      _ ->
        send_confirmation("message not sent")
    end
  end

  @spec send_confirmation(String.t()) :: map()
  def send_confirmation(message) do
    %Message.SendMessageResponse{
      send_confirmation: message
    }
  end
end
