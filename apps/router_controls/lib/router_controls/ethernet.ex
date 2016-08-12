defmodule RouterControls.Ethernet do
  import RouterControls.OsCommand

  def start do
    os_cmd("ip", ["link", "set", "eth0", "up"])
    os_cmd("ip", ["addr", "add", "192.168.1.6/24", "dev", "eth0"])
    os_cmd("ip", ["route", "add", "default", "via", "192.168.1.1"])
  end
end
