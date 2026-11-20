# Run after bundle exec jekyll build.
require "json"
require "rexml/document"

Dir.chdir(File.expand_path("../_site", __dir__)) do
  site = JSON.parse(File.read("metadata.json")).fetch("@graph")
  website = site.find { |entity| entity["@type"] == "WebSite" }
  by_id = site.to_h { |entity| [entity.fetch("@id"), entity] }
  abort "Missing research project" unless by_id.fetch(website.fetch("about").fetch("@id"))["@type"] == "ResearchProject"
  abort "Incorrect creator" unless by_id.fetch(website.fetch("creator").fetch("@id"))["name"] == "Robert Spiegelman"
  abort "Incorrect sponsor" unless by_id.fetch(website.fetch("sponsor").fetch("@id"))["name"] == "Indigenous Values Initiative"

  %w[credits.txt robots.txt humans.txt].each { |file| abort "Empty #{file}" unless File.size?(file) }
  atom = REXML::Document.new(File.read("feed.xml"))
  atom_urls = REXML::XPath.match(atom, "/a:feed/a:entry/a:link[@rel='alternate']", { "a" => "http://www.w3.org/2005/Atom" }).map { |link| link.attributes["href"] }
  rss_urls = REXML::XPath.match(REXML::Document.new(File.read("feed.rss")), "/rss/channel/item/link").map(&:text)
  json_urls = JSON.parse(File.read("feed.json")).fetch("items").map { |item| item.fetch("url") }
  twtxt_urls = File.readlines("twtxt.txt").grep(/^\d{4}-.*\t/).map { |line| line.split.last }
  abort "Feed entries differ" unless !atom_urls.empty? && [rss_urls, json_urls, twtxt_urls].all? { |urls| urls == atom_urls }
end
