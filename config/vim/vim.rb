namespace :vim do
  config_dir = "#{XDG_CONFIG_HOME}/vim"

  directory config_dir

  files({
    "#{config_dir}/vimrc" => 'config/vim/vimrc',
  })
end
