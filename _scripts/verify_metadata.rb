# Run after bundle exec jekyll build.
require "json"
require "uri"
require "rexml/document"

Dir.chdir(ARGV.fetch(0) { File.expand_path("../_site", __dir__) }) do
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

  # Every post must advertise a matching JSON document. Catch missing or stale source stubs.
  sidecars = []
  Dir.glob("**/*.html").each do |path|
    html = File.read(path)
    graph_json = html[/<script type="application\/ld\+json">(.*?)<\/script>/m, 1]
    next unless graph_json
    graph = JSON.parse(graph_json)
    post = graph.fetch("@graph").find { |entity| entity["@type"] == "BlogPosting" }
    next unless post

    route = URI.parse(post.fetch("url")).path.sub(%r{/+$}, "") + "/metadata.json"
    href = html[/<link rel="describedby" type="application\/ld\+json" href="([^"]+)"/, 1]
    abort "Missing metadata link in #{path}" unless href&.end_with?(route)
    sidecar = route.delete_prefix("/")
    abort "Metadata differs for #{path}" unless File.file?(sidecar) && JSON.parse(File.read(sidecar)) == graph
    sidecars << sidecar
  end
  abort "Orphaned or missing post metadata" unless sidecars.any? && sidecars.sort == Dir.glob("*/**/metadata.json").sort
end
