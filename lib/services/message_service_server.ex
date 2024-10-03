defmodule EjabberdRcp.MessagingServiceServer do
  use GRPC.Server, service: Da.Proto.MessageService.Service
  # this will contain serivecs of the message
  # sending, recieving and initiating a session
  @spec send_message(Da.Proto.SendMessageRequest.t(), GRPC.Server.Stream.t()) ::
          Da.Proto.SendMessageResponse.t()
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

  @spec send_confirmation(String.t()) :: Da.Proto.SendMessageResponse.t()
  def send_confirmation(message) do
    %Da.Proto.SendMessageResponse{
      send_confirmation: message
    }
  end

end
