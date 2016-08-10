defmodule RouterControls.Conntrack do
  import RouterControls.OsCommand

  def unmark_ip(ip) do
    os_cmd("conntrack", ["-D", "--orig-src", ip])
  end
end
