require "json"

module FairMetadataJson
  class MetadataPage < Jekyll::PageWithoutAFile
    def initialize(site, dir, doc, schema_type)
      @site = site
      @base = site.source
      @dir = dir
      @name = "metadata.json"
      process(@name)
      self.data = { "layout" => nil, "sitemap" => false }
      self.content = JSON.pretty_generate(metadata_for(site, doc, schema_type))
    end

    private

    def metadata_for(site, doc, schema_type)
      site_url = site.config["url"].to_s.sub(%r{/$}, "")
      title = doc.data["title"] || site.config["title"] || site.config["name"]
      description = doc.data["description"] || doc.data["excerpt"] || doc.output.to_s.gsub(/<[^>]+>/, " ").squeeze(" ").strip[0, 300]
      url = absolute_url(site_url, doc.url)
      author = doc.data["author"] || site.config.dig("author", "name") || site.config["author"] || site.config["name"] || site.config["title"]
      language = (site.config["locale"] || site.config["language"] || "en").to_s[0, 2]
      image = doc.data["image"] || doc.data.dig("header", "image") || doc.data.dig("header", "teaser") || site.config["teaser"] || site.config["logo"]
      data = {
        "@context" => "https://schema.org",
        "@type" => schema_type,
        "@id" => "#{url}#metadata",
        "name" => title,
        "headline" => title,
        "description" => description,
        "url" => url,
        "identifier" => url,
        "inLanguage" => language,
        "author" => { "@type" => "Person", "name" => author.to_s },
        "publisher" => { "@type" => "Organization", "name" => (site.config["title"] || site.config["name"]).to_s, "url" => site_url },
        "isPartOf" => { "@type" => "WebSite", "@id" => "#{site_url}/#website", "name" => (site.config["title"] || site.config["name"]).to_s, "url" => site_url }
      }
      data["datePublished"] = doc.date.strftime("%Y-%m-%d") if doc.respond_to?(:date) && doc.date
      data["dateModified"] = doc.data["last_modified_at"].to_s if doc.data["last_modified_at"]
      data["image"] = absolute_url(site_url, image) if image
      data["citation"] = doc.data["citations"] if doc.data["citations"]
      data
    end

    def absolute_url(site_url, value)
      return nil unless value
      value = value.to_s
      return value if value.start_with?("http://", "https://")
      "#{site_url}#{value.start_with?("/") ? value : "/#{value}"}"
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.posts.docs.each do |doc|
        dir = doc.url.end_with?("/") ? doc.url : "#{doc.url}/"
        site.pages << MetadataPage.new(site, dir, doc, "BlogPosting")
      end
    end
  end
end
