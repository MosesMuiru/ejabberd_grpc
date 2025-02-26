defmodule EjabberdRcp.AwsClient do
  # this returns client
  def aws_client() do
    AWS.Client.create(
      "key",
      "secret",
      "region"
    )
  end
end
