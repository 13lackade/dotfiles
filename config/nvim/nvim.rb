namespace :nvim do
  config_dir = "#{XDG_CONFIG_HOME}/nvim"
  data_dir = WINDOWS ? "#{XDG_DATA_HOME}/nvim-data" : "#{XDG_DATA_HOME}/nvim"
  plugin_dir = "#{data_dir}/site/pack/plugins"

  files(Dir.glob('config/nvim/**/*.lua').map { |file| 
    [file.sub('config/nvim',"#{config_dir}"), file]
  }.to_h)

  plugins({
    "#{plugin_dir}/start/catppuccin" => 'https://github.com/catppuccin/nvim.git',
    "#{plugin_dir}/start/nvim-treesitter" => 'https://github.com/nvim-treesitter/nvim-treesitter.git',
    "#{plugin_dir}/start/telescope.nvim" => 'https://github.com/nvim-telescope/telescope.nvim.git',
    "#{plugin_dir}/start/plenary.nvim" => 'https://github.com/nvim-lua/plenary.nvim.git',
    "#{plugin_dir}/start/mason.nvim" => 'https://github.com/williamboman/mason.nvim.git',
    "#{plugin_dir}/start/nvim-lspconfig" => 'https://github.com/neovim/nvim-lspconfig.git',
    "#{plugin_dir}/start/mason-lspconfig.nvim" => 'https://github.com/williamboman/mason-lspconfig.nvim.git',
    "#{plugin_dir}/start/nvim-cmp" => 'https://github.com/hrsh7th/nvim-cmp.git',
    "#{plugin_dir}/start/cmp-nvim-lsp" => 'https://github.com/hrsh7th/cmp-nvim-lsp.git',
    "#{plugin_dir}/start/vim-vsnip" => 'https://github.com/hrsh7th/cmp-vsnip.git',
    "#{plugin_dir}/start/cmp-buffer" => 'https://github.com/hrsh7th/cmp-buffer.git',

    "#{plugin_dir}/opt/which-key.nvim" => 'https://github.com/folke/which-key.nvim.git',
  })
end
