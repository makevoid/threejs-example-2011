PATH = File.expand_path "../", __FILE__

require 'bundler/setup'
Bundler.require :default

require "json" # load json gem?

require 'sinatra'

path = File.expand_path "../", __FILE__

get "/" do
  File.read "#{path}/index.html"
end
