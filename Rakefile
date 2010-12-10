require "fileutils"

include FileUtils

desc "Install all files"
task :install => [ :update, :dotfiles, :rvm ] do
end

desc "Update this project"
task :update do
  sh "git pull origin master"
  sh "git submodule update --init"
end

desc "Install dotfiles"
task :dotfiles do
  Dir.glob("home-dotfiles/*").each do |src|
    dst = src.scan(/home-dotfiles\/(.*)/).first.first
    dst = "#{ENV["HOME"]}/.#{dst}"

    puts "#{src} => #{dst}"
    rm_rf dst
    cp_r src, dst, :preserve => true
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
