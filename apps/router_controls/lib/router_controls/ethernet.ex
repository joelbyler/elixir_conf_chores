defmodule RouterControls.Ethernet do
  import RouterControls.OsCommand

  def start do
    System.cmd("ip", ["link", "set", "eth0", "up"])
    System.cmd("ip", ["addr", "add", "192.168.1.6/24", "dev", "eth0"])
    System.cmd("ip", ["route", "add", "default", "via", "192.168.1.1"])
  end
end
