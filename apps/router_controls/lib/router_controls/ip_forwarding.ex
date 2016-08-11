defmodule RouterControls.IpForwarding do
  import RouterControls.OsCommand

  def forward_ipv4 do
    os_cmd("sysctl", ["-w", "net.ipv4.ip_forward=1"])
  end
end
