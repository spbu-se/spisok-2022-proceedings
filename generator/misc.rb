#!/usr/bin/env ruby

def File::u_plus_x file_name
  File::chmod(File::stat(file_name).mode | 0700, file_name)
end

# Inspired by https://github.com/rdp/os/blob/9ee80f9ec0f59ecc731ecdc7c2a8f88180e385f5/lib/os.rb#LL18C3-L28C6

def is_os_windows?
  if RUBY_PLATFORM =~ /cygwin/ # i386-cygwin
    false
  elsif ENV['OS'] == 'Windows_NT'
    true
  else
    false
  end
end

def get_page_count file_name
  output = `pdftk #{file_name} dump_data`
  /NumberOfPages:\s+(?<npages>\d+)/ =~ output
  if npages
    npages.to_i
  else
    raise "No number of pages in #{file_name}"
    nil
  end
end
