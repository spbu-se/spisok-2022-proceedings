#!/usr/bin/env ruby

require_relative './misc.rb'

def gen_whole(sections)
  File::open(File::join("..", "sections", "_gen_whole.sh"), "w:UTF-8") do |f|
    f.puts "#!/bin/bash\n"
    sections.each do |s|
      f.puts <<~SPP
        pushd #{s.folder}
        . _section-compile.sh
        popd
        SPP
    end

    f.puts <<~TOC
      xelatex _toc.tex
      xelatex _toc.tex

      pdftk _a_begin.pdf #{sections.map {|s| s.pdfname}.join(' ')} _toc.pdf _z_end.pdf cat output spisok.pdf
      TOC
  end

  File::u_plus_x File::join("..", "sections", "_gen_whole.sh")

end
