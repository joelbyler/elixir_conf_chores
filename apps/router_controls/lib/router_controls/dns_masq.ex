defmodule RouterControls.DnsMasq do
  import RouterControls.OsCommand

  def start do
    os_cmd("dnsmasq", ["--dhcp-lease", "/root/dnsmasq.lease"])
  end
end
