defmodule RouterControls.OsCommand do
  import System

  def os_cmd(command, arguments) do
    cmd(command, arguments)
  end
end
