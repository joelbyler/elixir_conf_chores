defmodule RouterControls.HostApd do
  import RouterControls.OsCommand

  def start do
    os_cmd("hostapd", ["-B", "-d", "/etc/hostapd/hostapd.conf"])
  end
end
