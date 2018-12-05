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
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
end

environment :test do
  set dev_mode: true
  set include_erts: false
  set cookie: :"c>My{36?p)u&%C`lg{MUD^h3o,r;0R[E6>tJ]Xb|ip^K/Be$9eOENXBkKN$,&m$D"
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"P=1}8:E^$St7]rGgrv@(ugK;FLr>u]Qu8C%g&%1h.Jkwf]3l2svBm|dib)~O>SFP"
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
    {:copy, "config/dev.exs", "etc/dev.exs"},
    {:copy, "config/prod.exs", "etc/prod.exs"},
    {:copy, "config/prod.exs", "etc/test.exs"},
  ]
end
