defmodule RouterControls.AddressResolution do
  import RouterControls.OsCommand

  def fetch_arp(ip) do
    os_cmd("arp", ["-a", ip])
  end

  def default_arp({arp_result, 0}) do
    {arp_result, 0}
  end

  def default_arp({_, 1}) do
    os_cmd("arp", ["-a"])
  end

  def parse_arp_response({"", 0}) do
    "unkown"
  end

  def parse_arp_response({arp_response, 0}) do
    List.first(Regex.run(~r/([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}/, arp_response || []))
  end

  def parse_arp_response({arp_response, _}) do
    "error"
  end

end
