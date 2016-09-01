defmodule RouterControls.IpTables do
  import RouterControls.OsCommand

  def unmark_mac(mac) do
    # os_cmd("iptables", ["-t", "mangle", "-I", "internet", "1", "-m", "mac", "--mac-source", mac, "-j", "RETURN"])
    # for demo, instead of removing the mark, change it (ethernet is hard to get at conference location)
    os_cmd("iptables", ["-t", "mangle", "-I", "internet", "1", "-m", "mac", "--mac-source", mac, "-j", "MARK", "--set-mark", "88"])
  end

  def mark_mac(mac) do
    os_cmd("iptables", ["-t", "mangle", "-I", "internet", "1", "-m", "mac", "--mac-source", mac, "-j", "MARK", "--set-mark", "99"])
  end
end
