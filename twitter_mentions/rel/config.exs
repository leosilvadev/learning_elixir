~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"Bj7k2={/o%;4&.who{8r|^8xM1*OG=J|,~NB8GH(=|5;>m:syw;q4A=CxmC8SnK*"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"LS>@8KAfe^&U.ycb%d:(xJgJyl3;$qpUgx0xlTX@IXbH]8e16_khTA6b]x(7XR`."
  set vm_args: "rel/vm.args"
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
end

release :mentions do
  set version: current_version(:mentions)
  set applications: [
    :runtime_tools,
    :logger,
    :extwitter
  ]
  set overlays: [
    {:copy, "config/config.exs", "etc/config.exs"},
  ]
end
