require "fileutils"

include FileUtils

desc "Install all files"
task :install => [ :update, :dotfiles, :rvm, :gems ] do
end

desc "Update this project"
task :update do
  system "git pull origin master"
  system "git submodule init"
  system "git submodule update"
  system "git submodule foreach git pull origin master"
  system "git submodule foreach git merge origin/master"
  system "git submodule foreach git checkout master"
end

desc "Install dotfiles"
task :dotfiles do
  Dir.glob("home-dotfiles/*").each do |src|
    dst = src.scan(/home-dotfiles\/(.*)/).first.first
    dst = "#{ENV["HOME"]}/.#{dst}"

    puts "#{src} => #{dst}"
    rm_rf dst
    cp_r src, dst
  end
end

desc "Install RVM"
task :rvm do
  if File.exists? File.expand_path "~/.rvm"
    system "bash -l -c 'rvm update --head'"
  else
    system "bash -c 'bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )'"
  end
end

desc "Install RubyGems"
task :gems do
  gems = "wirble andand awesome_print"
  system "bash -l -c 'rvm gem install #{gems}'"
end
