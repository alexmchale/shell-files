require "fileutils"

desc "Install all files"
task :install => [ :update, :install_dotfiles ] do
end

desc "Update this project"
task :update do
  system("git pull origin master")
  system("git submodule init")
  system("git submodule update")
  system("git submodule foreach git pull origin master")
end

desc "Install dotfiles"
task :install_dotfiles do
  Dir.glob("home-dotfiles/*").each do |src|
    dst = src.scan(/home-dotfiles\/(.*)/).first.first
    dst = "#{ENV["HOME"]}/.#{dst}"

    puts "#{src} => #{dst}"
    FileUtils.rm_rf dst
    FileUtils.cp_r src, dst
  end
end
