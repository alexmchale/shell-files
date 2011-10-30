require "fileutils"

include FileUtils

def install_or_clone(git, path)
  path = File.expand_path(path)
  if File.exists? path
    system "cd #{path} ; git pull origin master"
  else
    system "git clone #{git} #{path}"
  end
end

desc "Install all files"
task :install => [ :dotfiles, :rbenv, :rubybuild ] do
  cd File.expand_path "~/.vimbundles/command-t/ruby/command-t"
  sh "/usr/bin/ruby extconf.rb"
  sh "make clean && make"
end

desc "Update this project"
task :update do
  sh "git pull origin master"
  sh "git submodule update --init"
  sh "git submodule foreach git reset --hard"
  sh "git submodule foreach git co ."
  sh "git submodule foreach git pull origin master"
end

desc "Install dotfiles"
task :dotfiles do
  Dir.glob("home-dotfiles/*").each do |src|
    dst = src.scan(/home-dotfiles\/(.*)/).first.first
    dst = "#{ENV["HOME"]}/.#{dst}"

    puts "#{src} => #{dst}"
    rm_rf dst
    sh "cp -rp #{src} #{dst}"
  end
end

desc "Install/Update rbenv"
task :rbenv do
  install_or_clone "https://github.com/sstephenson/rbenv.git", "~/.rbenv"
end

desc "Install/Update ruby-build"
task :rubybuild do
  install_or_clone "https://github.com/sstephenson/ruby-build.git", "~/.ruby-build"
end

desc "Install RVM"
task :rvm do
  if File.exists? File.expand_path "~/.rvm"
    system "bash -l -c 'rvm get head'"
    system "bash -l -c 'rvm reload'"
  else
    system "bash -c 'bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )'"
  end

  cp "resources/rvm-global.gems", File.expand_path("~/.rvm/gemsets/global.gems")
end
