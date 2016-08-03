defmodule UserInterface.NetworkConnectionHelper do
  import System
  alias Porcelain.Result

  def user_ip_address(conn) do
    IO.puts "ip: #{Enum.join(Tuple.to_list(conn.remote_ip),".")}"
    Enum.join(Tuple.to_list(conn.remote_ip),".")
  end

  def user_mac_address(conn) do
    user_ip_address(conn) |> fetch_arp |> default_arp |> parse_arp_response
  end

  def fetch_arp(ip) do
    {arp_result, arp_status} = os_cmd("arp", ["-a", ip])
    IO.puts "arp -a #{ip} => (#{arp_status}): #{arp_result}"
    {arp_result, arp_status}
  end

  def default_arp({arp_result, 0}) do
    {arp_result, 0}
  end

  def default_arp({_, 1}) do
    {arp_result, arp_status} = os_cmd("arp", ["-a"])
    IO.puts "arp -a => (#{arp_status}): #{arp_result}"
    {arp_result, arp_status}
  end

  def parse_arp_response({"", 0}) do
    IO.puts "bad arp:"
    "unkown"
  end

  def parse_arp_response({arp_response, 0}) do
    IO.puts("arp: #{arp_response}")
    List.first(Regex.run(~r/([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}/, arp_response || []))
  end

  def parse_arp_response({arp_response, _}) do
    IO.puts "bad arp: #{arp_response}"
    "error"
  end

  def unmark(conn) do
    user_ip_address(conn) |> unmark(conn)
  end

  def unmark("127.0.0.1", _) do; end

  def unmark(ip, conn) do
    {ip_result, ip_status} = unmark_ip(ip)
    IO.puts "unmark_ip: #{ip_result}; #{ip_status}"
    {mac_result, mac_status} = user_mac_address(conn) |> unmark_mac
    IO.puts "unmark_mac: #{mac_result}; #{mac_status}"
    [{ip_result, ip_status}, {mac_result, mac_status}]
  end

  def unmark_ip(ip) do
    os_cmd("conntrack", ["-D", "--orig-src", ip])
  end

  def unmark_mac(mac) do
    os_cmd("iptables", ["-t", "mangle", "-I", "internet", "1", "-m", "mac", "--mac-source", mac, "-j", "RETURN"])
  end

  defp os_cmd(command, arguments) do
    cmd(command, arguments)
  end
end
