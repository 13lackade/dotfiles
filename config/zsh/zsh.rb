namespace :zsh do
  config_dir = "#{XDG_CONFIG_HOME}/zsh"
  data_dir = "#{XDG_DATA_HOME}/zsh"
  plugin_dir ="#{data_dir}/site"

  files({
    "#{config_dir}/.zshenv" => 'config/zsh/zshenv',
    "#{config_dir}/.zshrc" => 'config/zsh/zshrc',
    "#{HOME}/.zshenv" => 'config/zsh/zshenv_home',
  })

  plugins({
    "#{plugin_dir}/zsh-autosuggestions" => 'https://github.com/zsh-users/zsh-autosuggestions.git',
    "#{plugin_dir}/zsh-syntax-highlighting" => 'https://github.com/zsh-users/zsh-syntax-highlighting.git'
  })
end if UNIX
