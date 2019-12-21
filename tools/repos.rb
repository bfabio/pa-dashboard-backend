#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'httparty'

class Repo
    include HTTParty

    base_uri 'https://api.github.com'

    def all
        self.class.get '/orgs/italia/repos'
    end
end

FIELDS = %w(name description homepage)

repo = Repo.new
projects = repo.all.reject{|r| r['archived'] || r['disabled']}.map{|r| r.slice(*FIELDS)}

File.write 'projects.json', JSON.pretty_generate(projects)
