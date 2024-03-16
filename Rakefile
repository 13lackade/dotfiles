def plugins(plugin, other=[])
  plugin.each do |path, config|
    if config.kind_of? String then
      url = config
    else
      url = config["url"]
    end

    task path do
      if not FileTest.directory?("#{path}/.git")
        sh %{git clone #{url} #{path} --quiet}
      else
        sh %{cd #{path} && git pull origin HEAD --quiet}
      end
    end
  end

  multitask :plugins => plugin.map { |path, config| path } + other
end

def files(file, other=[])
  file.each do |dest, source|
    file dest => source do |t|
      mkdir_p File.dirname(dest)
      cp source, dest
    end
  end

  multitask :files => file.map { |dest, source| dest } + other
end

require('rbconfig')

case RbConfig::CONFIG['host_os']
when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  WINDOWS = true
  MACOS = false
  UNIX = false
when /darwin|mac os/
  WINDOWS = false
  MACOS = true
  UNIX = true
else
  WINDOWS = false
  MACOS = false
  UNIX = true
end

if WINDOWS then
  HOME = ENV['USERPROFILE']
else
  HOME = %x[printf ~#{ENV['SUDO_USER']}]
end
XDG_CONFIG_HOME = "#{HOME}/.config"
XDG_CACHE_HOME = "#{HOME}/.cache"
XDG_DATA_HOME = "#{HOME}/.local/share"

['config', 'asset', 'bin'].each do |path|
  Dir.glob("#{path}/*/*.rb").map { |file| load file }
end

def msg(str)
  puts "\033[34m\033[1m::\033[0m #{str}"
end

task :default do
  sh %{rake -T}, verbose: false
end

desc 'Install everything'
task :install => [ 'install-config', 'install-plugin', 'install-package' ]

desc 'Install config files'
task 'install-config' do |task|
  msg 'Installing config files...'
  task.application.tasks.each do |t|
    t.invoke if t.name.include? ':files'
  end
end

desc 'Install plugins'
task 'install-plugin' do |task|
  msg 'Installing plugins...'
  task.application.tasks.each do |t|
    t.invoke if t.name.include? ':plugins'
  end
end

desc 'Install packages'
task 'install-package'
