defmodule RouterControls.Fakes.System do

  def cmd("arp", ["-a", "192.168.24.42"]) do
    {"foo.example.com (192.168.24.42) at ab:cd:ef:ab:cd:ef yada.yada", 0}
  end

  def cmd("arp", ["-a", "192.168.24.19"]) do
    {"this is a problem", 1}
  end

  def cmd("arp", ["-a"]) do
    {"default.example.com (192.168.1.1) at ab:cd:ef:ab:cd:ef yada.yada", 0}
  end
end