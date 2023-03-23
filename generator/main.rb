#!/usr/bin/env ruby

require_relative './metadata.rb'
require_relative './generator.rb'
require_relative './toc.rb'
require_relative './whole.rb'

section_folder = if ARGV.length < 1 then
  File::expand_path File::join(File::dirname(File::expand_path(__FILE__)), '../sections')
else
  File::expand_path ARGV[0]
end

proceedings = Proceedings::new section_folder

cpage = proceedings.content_start_page

proceedings.sections.each do |s|
  cpage = s.maketex(cpage)
end

gen_toc(proceedings.sections, "Содержание", proceedings.title, cpage)

gen_whole(proceedings.sections)
