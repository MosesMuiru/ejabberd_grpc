defmodule EjabberdRcp.MessagingServiceServer do
  use GRPC.Server, service: Da.Proto.MessageService.Service
 
  @spec send_confirmation(String.t()) :: Da.Proto.SendMessageResponse.t()
  def send_confirmation(message) do
    %Da.Proto.SendMessageResponse{
      send_confirmation: message
    }
  end
end
