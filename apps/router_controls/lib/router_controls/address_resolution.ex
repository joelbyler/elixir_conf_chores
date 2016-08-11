defmodule RouterControls.AddressResolution do
  import RouterControls.OsCommand

  def fetch_arp(ip) do
    os_cmd("arp", ["-a", ip]) |> default_arp
  end

  def default_arp({arp_result, 0}) do
    {arp_result, 0}
  end

  def default_arp({_, 1}) do
    os_cmd("arp", ["-a"])
  end

  @doc ~S"""
  Returns unkown if arp gives an empty response with sucess status
  ## Examples
      iex> RouterControls.AddressResolution.parse_arp_response {"", 0}
      "unkown"

      iex> RouterControls.AddressResolution.parse_arp_response {"foo.example.com (192.168.1.1) at ab:cd:ef:ab:cd:ef yada.yada", 0}
      "ab:cd:ef:ab:cd:ef"

      iex> RouterControls.AddressResolution.parse_arp_response {"anything", 1}
      "error"
  """
  def parse_arp_response({"", 0}) do
    "unkown"
  end

  def parse_arp_response({arp_response, 0}) do
    List.first(Regex.run(~r/([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}/, arp_response || []))
  end

  def parse_arp_response({_, _}) do 
    "error"
  end
end
