defmodule EjabberdRcp.S3Client do
  # this will upload both attachements and audio
  def uploader(filecontent, filename) do
    client = EjabberdRcp.AwsClient.aws_client()

    md5 = :crypto.hash(:md5, filecontent) |> Base.encode64()
    bucketname = "messagingbucketv1"
    keyname = filename <> Ecto.UUID.generate()

    AWS.S3.put_object(client, bucketname, keyname, %{
      "Body" => filecontent,
      "ContentType" => MIME.from_path(filename)})
    |> case do
      {:ok, _, %{status_code: status_code}} when status_code == 200 ->
        "https://#{bucketname}.s3.us-east-1.amazonaws.com/#{keyname}"

      {:error, _, %{body: body, status_code: status_code}} ->
        %{body: body, status_code: status_code}
        |> IO.inspect("failed to upload to s3")
    end
  end
end
