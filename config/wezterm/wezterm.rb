namespace :wezterm do
  config_dir = "#{HOME}/.config/wezterm"

  directory config_dir

  files({
    "#{config_dir}/wezterm.lua" => 'config/wezterm/wezterm.lua',
  })
end
