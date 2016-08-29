defmodule UserInterface.NetworkConnectionHelper do
  import RouterControls.IpTables
  import RouterControls.AddressResolution
  import RouterControls.Conntrack

  def user_ip_address(conn) do
    Enum.join(Tuple.to_list(conn.remote_ip),".")
  end

  def user_mac_address(conn) do
    user_ip_address(conn) |> fetch_arp |> parse_arp_response
  end

  def unmark(conn) do
    user_ip_address(conn) |> unmark(conn)
  end

  def unmark("127.0.0.1", _) do; end

  def unmark(ip, conn) do
    {ip_result, ip_status} = unmark_ip(ip)
    {mac_result, mac_status} = user_mac_address(conn) |> unmark_mac
    [{ip_result, ip_status}, {mac_result, mac_status}]
  end

  def mark(mac) do
    mark_mac(mac)
  end

  def admin_mac?(mac) do
    admin_connection?(mac)
  end
end
