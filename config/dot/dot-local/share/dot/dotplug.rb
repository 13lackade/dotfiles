require 'tomlrb'
require 'fileutils'

DOTPLUG_CONFIG_DIR = File.join(ENV['HOME'],'.config','dotplug')

Dir.glob(File.join(DOTPLUG_CONFIG_DIR,'*.toml')) do |file|
  Tomlrb.load_file(file).each do |_, list|
    root = list['root']
    root.sub!('~',ENV['HOME'])
    list.delete 'root'

    list.each do |name, config|
      dir = File.join(root, name)
      git = config['git']

      if File.directory?(dir) then
        puts "Updating #{name}"
        %x[cd #{dir} && git pull]
      else
        puts "Installing #{name}"
        %x[git clone #{git} #{dir}]
      end
    end
  end
end
