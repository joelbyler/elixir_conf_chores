defmodule RouterControls.AddressResolution do
  import RouterControls.OsCommand

  @doc ~S"""
  Returns arp result or a default one if previous was unsuccesfull
  ## Examples
      iex> RouterControls.AddressResolution.fetch_arp "192.168.24.42"
      {"foo.example.com (192.168.24.42) at ab:cd:ef:ab:cd:ef yada.yada", 0}

      iex> RouterControls.AddressResolution.fetch_arp "192.168.24.19"
      {"default.example.com (192.168.1.1) at ab:cd:ef:ab:cd:ef yada.yada",0}
  """
  def fetch_arp(ip) do
    os_cmd("arp", ["-a", ip]) |> fallback_arp
  end

  @doc ~S"""
  Returns arp result or a default one if previous was unsuccesfull
  ## Examples
      iex> RouterControls.AddressResolution.fallback_arp {"yay", 0}
      {"yay", 0}

      iex> RouterControls.AddressResolution.fallback_arp {"yay", 1}
      {"default.example.com (192.168.1.1) at ab:cd:ef:ab:cd:ef yada.yada",0}
  """
  def fallback_arp({arp_result, 0}) do
    {arp_result, 0}
  end

  def fallback_arp({_, 1}) do
    os_cmd("arp", ["-a"])
  end

  @doc ~S"""
  Returns unkown if arp gives an empty response with sucess status
  ## Examples
      iex> RouterControls.AddressResolution.parse_arp_response {"foo.example.com (192.168.1.1) at ab:cd:ef:ab:cd:ef yada.yada", 0}
      "ab:cd:ef:ab:cd:ef"

      iex> RouterControls.AddressResolution.parse_arp_response {"", 0}
      "unkown"

      iex> RouterControls.AddressResolution.parse_arp_response {"something bogus", 0}
      "unkown"

      iex> RouterControls.AddressResolution.parse_arp_response {"anything", 1}
      "unkown"
  """
  def parse_arp_response({arp_response, 0})  do
    List.first(Regex.run(~r/([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}/, arp_response) || ["unkown"])
  end

  def parse_arp_response({_, _}) do
    "unkown"
  end
end
