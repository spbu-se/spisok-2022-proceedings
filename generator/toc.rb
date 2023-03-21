#!/usr/bin/env ruby

require 'erb'
require_relative './generator.rb'

def gen_toc(sections, toctitle, confname, startpage)
  draft_page_numbers_warned = false
  toc = sections.map do |s|
    if s.status == true or draft_page_numbers_warned then '' else
      draft_page_numbers_warned = true
      "\\noindent{\\color{red}~Внимание! Номера страниц ниже могут измениться.}\n\n"
    end +
    "\\contentsline{section}{#{s.name}}{\\hyperlink{abspage-#{s.start_page}.1}{#{s.start_page}}}{}\\nopagebreak[4]\n" +
    if s.status == true then '' else "{\\color{red}~#{s.status}}\n" end +
    s.articles.map do |a|
      "\\contentsline{subsection}{\\textbf{#{a.by}#{if not a.by.end_with?('.') then '.' else '' end}}~#{a.title}}{\\hyperlink{abspage-#{a.start_page}.2}{#{a.start_page}}}{}"
    end.join("\n")
  end.join("\n\n")

  section_templ = ERB::new(File::read(File::join(File::dirname(__FILE__), 'toc.erb')))
  section_tex = section_templ.result binding

  File::open(File::join("..", "sections", "_toc.tex"), "w:UTF-8") do |f|
    f.write section_tex
  end
end
