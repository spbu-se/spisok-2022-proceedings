#!/usr/bin/env ruby

require_relative './misc.rb'

def gen_whole(sections)
  win = is_os_windows?
  suffix, scall = win ? ['bat', 'call'] : ['sh', '.']

  File::open(File::join("..", "sections",  "_gen_whole.#{suffix}"), "w:UTF-8") do |f|
    if not win then
      f.puts "#!/bin/bash\n"
    end
    sections.each do |s|
      f.puts <<~SPP
        pushd #{s.foldername}
        #{scall} _section-compile.#{suffix}
        popd
        SPP
    end

    f.puts <<~TOC
      xelatex _toc.tex
      xelatex _toc.tex

      #{scall} __concat_proceedings.#{suffix}
      TOC
  end

  File::open(File::join("..", "sections",  "__concat_proceedings.#{suffix}"), "w:UTF-8") do |f|
    if not win then
      f.puts "#!/bin/bash\n"
    end

    f.puts <<~TOC
      pdftk _a_begin.pdf #{sections.map {|s| s.pdfname}.join(' ')} _toc.pdf _z_end.pdf cat output spisok.pdf
      TOC
  end

  if not win then
    File::u_plus_x File::join("..", "sections", "_gen_whole.sh")
    File::u_plus_x File::join("..", "sections", "__concat_proceedings.sh")
  end
end
