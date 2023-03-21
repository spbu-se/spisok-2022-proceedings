#!/usr/bin/env ruby

require_relative './metadata.rb'
require_relative './generator.rb'
require_relative './toc.rb'
require_relative './whole.rb'

proceedings = Proceedings::new(File::join(File::dirname(File::expand_path(__FILE__)), '../sections'))

cpage = proceedings.content_start_page

proceedings.sections.each do |s|
  cpage = s.maketex(cpage)
end

gen_toc(proceedings.sections, "Содержание", proceedings.title, cpage)

gen_whole(proceedings.sections)
