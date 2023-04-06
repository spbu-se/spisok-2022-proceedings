#!/usr/bin/env ruby

require 'yaml'

class Chairman
  attr_reader :name, :photo, :title

  def initialize(chdic, sec)
    @section = sec
    @name = chdic['name']
    @photo = chdic['photo']
    @title = chdic['title']
  end
end

class Article
  attr_reader :section, :title, :by, :file, :fullfile, :articles, :pagescount
  attr_accessor :start_page

  def getpagescount
    get_page_count @fullfile
  end

  def by()
    # Joins to string
    @author_list.map { | a | a.gsub /\s+/, '\\,' }.join ', '
  end

  def initialize(ardic, sec)
    @section = sec
    @title = ardic['title']
    @author_list = ardic['by']
    @file = ardic['file']
    @fullfile = File::join(sec.fullfolder, @file)
    @pagescount = self.getpagescount
    @start_page = nil
  end
end

class Section
  attr_reader :fullfolder, :foldername, :pdfname, :name, :status, :heads, :articles, :confname
  attr_accessor :start_page

  def initialize(fullfolder, confname)
    secdic = YAML::load_file(File::join(fullfolder, 'section.yml'))
    @fullfolder = fullfolder
    @foldername = File::basename fullfolder
    @pdfname = "_section--#{@foldername}.pdf"
    @name = secdic['name']
    @status = secdic['status']
    @confname = confname
    @heads = secdic['heads'].map { |h| Chairman::new(h, self) }
    @articles =
      if secdic.has_key?('articles') and secdic['articles'] then
        secdic['articles'].map { |a| Article::new(a, self) }
      else
        []
      end
  end
end

class Proceedings
  attr_reader :title, :sections, :content_start_page

  def initialize(sectionsfolder)
    procmeta = YAML::load_file(File::join(sectionsfolder, 'proceedings.yml'))
    @sectionsfolder = sectionsfolder
    @title = procmeta['title']
    start_page_count = get_page_count(File::join(sectionsfolder, '_a_begin.pdf'))
    @content_start_page = start_page_count + ( start_page_count.odd? ? 2 : 1 )
    @sections = procmeta['sections'].map do |f|
      Section::new(File::expand_path(File::join(sectionsfolder, f)), @title)
    end
  end
end
