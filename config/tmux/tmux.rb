namespace :tmux do
  config_dir = "#{XDG_CONFIG_HOME}/tmux"

  files({
    "#{config_dir}/tmux.conf" => 'config/tmux/tmux.conf'
  })
end if UNIX
