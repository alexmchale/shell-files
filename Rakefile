require "fileutils"

desc "Install all files"
task :install => [ :install_dotfiles ] do
end

desc "Install dotfiles"
task :install_dotfiles do
  Dir.glob("home-dotfiles/*").each do |src|
    dst = src.scan(/home-dotfiles\/(.*)/).first.first
    dst = "#{ENV["HOME"]}/.#{dst}"

    puts "#{src} => #{dst}"
    FileUtils.cp_r src, dst
  end
end
