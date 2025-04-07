defmodule EjabberdRcp.ReadYml do
  def parse_yaml_file(hosts) do
    "ejabberd.yml"
    |> YamlElixir.read_from_file()
    |> handle_parsed_yaml(hosts)
  end

  defp handle_parsed_yaml({:ok, parsed_yml}, hosts) do
    parsed_yml
    |> update_domains_under_muc(hosts)
    |> write_new_configs()
  end

  defp handle_parsed_yaml({:error, reason}, _) do
    IO.inspect(reason, label: "Failed to parse")
  end

  defp update_domains_under_muc(data, new_hosts) do
    hosts =
      data
      |> get_in(["modules", "mod_muc", "hosts"])

    # you can have many new organisations or one
    updated =
      [new_hosts | hosts]
      |> List.flatten()

    put_in(data, ["modules", "mod_muc", "hosts"], updated)
    # data
    # |> Map.update!("modules", fn mod_config ->
    #  mod_config
    #  |> Map.update!("mod_muc", fn muc ->
    #    muc
    #    |> Map.update!("hosts", fn hosts ->
    #      ["testing " | hosts]
    #    end)
    #  end)
    # end)
  end

  defp write_new_configs(data) do
    data
    |> IO.inspect(label: "this is the dataaa i am using")
  end

  def convert(data) do
    data
    |> Enum.map(fn key, value ->
      nil
    end)
  end

  def convert(data) when is_list(data) do
    data
  end

  def map_to_yaml(map) do
    updated =
      map
      |> Enum.map(fn {key, value} ->
        map_to_yaml_line({key, value}, 0)
      end)
      |> Enum.join("\n")

    File.write!("new.yml", updated)
  end

  # Converts each map entry to YAML formatted line with proper indentation
  defp map_to_yaml_line({key, value}, indent_level) when is_map(value) do
    indent = String.duplicate("  ", indent_level)

    formatted_value =
      value
      |> Enum.map(fn {sub_key, sub_value} ->
        map_to_yaml_line({sub_key, sub_value}, indent_level + 1)
      end)
      |> Enum.join("\n")

    "#{indent}#{key}-\n#{formatted_value}"
  end

  defp map_to_yaml_line({key, value}, indent_level) when is_list(value) do
    indent = String.duplicate("  ", indent_level)

    formatted_value =
      value
      |> Enum.map(fn item ->
        case item do
          # Process inner maps
          %{} -> map_to_yaml_line({"", item}, indent_level + 1)
          # Use "-" instead of ":"
          _ -> "#{indent}: #{inspect(item)}"
        end
      end)
      |> Enum.join("\n")

    "#{indent}#{key}:\n#{formatted_value}"
  end

  defp map_to_yaml_line({key, value}, indent_level) do
    indent = String.duplicate("  ", indent_level)
    "#{indent}#{key}: #{inspect(value)}"
  end

  def covert(data) do
    indent = String.duplicate("  ", 1)

    da =
      data
      # waah, key: and the next line is the value() the value can be a map, list, string interger
      # 
      |> Enum.map(fn {key, value} ->
        "#{key}: \n#{indent}#{converter(value)}"
      end)

    File.write!("new.yml", da)
  end

  def converter(value) when is_list(value) do
    value
    |> IO.inspect(label: "the following vlaue is a list")

    value
    |> Enum.map(fn data ->
      converter(data)
    end)
  end

  def converter(value) when is_map(value) do
    IO.inspect(value, label: "waaaah")

    value
    |> Enum.map(fn {key, value} ->
      "#{key}: #{converter(value)}"
    end)
  end

  def converter(value) do
    value
  end
end
