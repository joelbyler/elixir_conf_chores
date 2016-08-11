defmodule RouterControls.Wifi do
  import RouterControls.OsCommand

  def start do
    os_cmd("ip", ["link", "set", "wlan0", "up"])
    os_cmd("ip", ["addr", "add", "192.168.24.1/24", "dev", "wlan0"])
  end
end
