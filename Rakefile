require 'rake'
require 'fileutils'

task :default => :install

desc "install the dot files into a user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE].include? file
    next if FileTest.symlink?(File.join(ENV['HOME'], ".#{file}"))
    # handle .local versions; only copy if DNE
    if file.match('\.local$')
      if !File.exist?(File.join(ENV['HOME'], ".#{file}"))
          FileUtils.copy(file, File.join(ENV['HOME'], ".#{file}"))
      end
      next
    end
    
    # handle normal dotfiles
    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
