defmodule RouterControls.OsCommand do
  @system Application.get_env(:router_controls, :system_client)

  def os_cmd(command, arguments) do
    system.cmd(command, arguments)
  end

  def system do
    @system || System
  end

end
