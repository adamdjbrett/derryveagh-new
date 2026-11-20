require "json"

module FairMetadataJson
  class MetadataPage < Jekyll::PageWithoutAFile
    def initialize(site, dir, doc)
      @site = site
      @base = site.source
      @dir = dir
      @name = "metadata.json"
      process(@name)
      self.data = { "layout" => nil, "sitemap" => false }
      self.content = JSON.pretty_generate(ScholarlyMetadata.graph(doc.to_liquid, site))
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.posts.docs.each do |doc|
        dir = doc.url.end_with?("/") ? doc.url : "#{doc.url}/"
        site.pages << MetadataPage.new(site, dir, doc)
      end
    end
  end
end
