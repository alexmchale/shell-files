require "fileutils"

include FileUtils

desc "Install all files"
task :install => [ :update, :dotfiles, :rvm ] do
end

desc "Update this project"
task :update do
  system("git pull origin master")
  system("git submodule init")
  system("git submodule update")
  system("git submodule foreach git pull origin master")
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
  system "bash -c 'bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )'"
end
