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
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
end

environment :test do
  set dev_mode: true
  set include_erts: false
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]
end

environment :prod do
  set include_erts: true
  set include_src: false
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
