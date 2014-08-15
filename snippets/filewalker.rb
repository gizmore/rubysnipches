###
### Offers convinient filesystem traversal functionality.
###
### Examples:
### Filewalker.proc_dirs('/tmp') do |file, dir|
###   puts "#{dir} is a dir in /tmp"
### end
###
### License: none?
### Author: gizmore@wechall.net
###
### Tested with:
### [+] Ruby 2.x
###
### Needs some stuff from string_helpers -.-
###
class Filewalker
  
  def self.proc_files(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, false, dotfiles, true, false, &block)
  end

  def self.traverse_files(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, true, dotfiles, true, false, &block)
  end
  
  def self.proc_dirs(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, false, dotfiles, false, true, &block)
  end

  def self.traverse_dirs(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, true, dotfiles, false, true, &block)
  end
  
  def self.proc_all(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, false, dotfiles, true, true, &block)
  end
 
  def self.traverse_all(dir, filepattern='*', dotfiles=true, &block)
    __traverse(dir, filepattern, true, dotfiles, true, true, &block)
  end

  private
  
  def self.__traverse(dir, filepattern='*', recursive=true, dotfiles=true, files=true, dirs=false, &block)
    
    dir = File.dirname(dir) if File.file?(dir)
    
    dir = dir.rtrim('/') + '/'
    
    # Sanity
    raise Exception.new "filewalker(dir) is not a directory: '#{dir}'." unless File.directory?(dir)
    
    # Files first
    Dir[dir+filepattern].each do |path|
      file = path.rsubstr_from('/')
      if (file != '.') && (file != '..')
        if (file[0] != '.') || dotfiles
          if File.file?(path)
            yield(path, nil) if files
          end
        end
      end
    end
    
    # Dirs
    if recursive || dirs
      Dir[dir+'*'].each do |path|
        file = path.rsubstr_from('/')
        if (file != '.') && (file != '..')
          if (file[0] != '.') || dotfiles
            if File.directory?(path)
              yield(nil, path) if dirs
              if recursive
                __traverse(path+'/', filepattern, recursive, dotfiles, files, dirs, &block)
              end
            end
          end
        end
      end
    end
    
  end
end
