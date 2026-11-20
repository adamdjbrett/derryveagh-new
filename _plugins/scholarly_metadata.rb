# frozen_string_literal: true

require "cgi"
require "date"

module ScholarlyMetadata
  BIO = "https://sullivanclinton.com/bio/"
  SPONSOR = "https://indigenousvalues.org/"
  CREATOR = { "@type" => "Person", "@id" => "#{BIO}#person", "name" => "Robert Spiegelman", "url" => BIO }.freeze

  module_function

  def author(page, site)
    return if page["author_uncredited"]

    key = page["author"] || Array(page["authors"]).first
    return CREATOR unless key

    record = key.is_a?(Hash) ? key : (site.data.fetch("authors", {})[key] || { "name" => key })
    return CREATOR if record["name"] == CREATOR["name"]

    { "@type" => record.fetch("type", "Person"), "name" => record["name"],
      "url" => record["url"] || record["uri"] }.compact
  end

  def url(page, site)
    path = (page["canonical_url"] || page["url"]).to_s.sub(%r{/index\.html?$}, "/")
    base = site.config["url"].to_s.chomp("/") + site.config["baseurl"].to_s.chomp("/") + "/"
    Addressable::URI.join(base, path.sub(%r{\A/(?!/)}, "")).normalize.to_s
  end

  def text(value)
    CGI.unescapeHTML(value.to_s.gsub(/<[^>]+>/, " ")).split.join(" ")
  end

  def graph(page, site)
    home = url({ "url" => "/" }, site)
    name = site.config["title"]
    language = site.config["locale"] || site.config["lang"] || "en"
    creator = CREATOR.slice("@id")
    sponsor = { "@id" => "#{SPONSOR}#organization" }
    project = { "@id" => "#{home}#project" }
    website = { "@id" => "#{home}#website" }
    nodes = [
      website.merge("@type" => "WebSite", "name" => name, "url" => home, "inLanguage" => language,
                    "description" => text(site.config["description"]), "creator" => creator,
                    "sponsor" => sponsor, "about" => project, "genre" => "Digital humanities"),
      project.merge("@type" => "ResearchProject", "name" => name, "url" => home, "founder" => creator,
                    "sponsor" => sponsor, "subjectOf" => website),
      sponsor.merge("@type" => "Organization", "name" => "Indigenous Values Initiative", "url" => SPONSOR),
      CREATOR
    ]
    if page
      post = page["collection"] == "posts"
      canonical = url(page, site)
      node = { "@id" => "#{canonical}#metadata", "@type" => post ? "BlogPosting" : "WebPage",
               "name" => text(page["title"] || name), "url" => canonical, "identifier" => canonical,
               "inLanguage" => page["lang"] || language, "isPartOf" => website, "author" => author(page, site) }.compact
      node["headline"] = node["name"] if post
      description = page["description"] || page["excerpt"]
      node["description"] = text(description) if description
      node["datePublished"] = Date.parse(page["date"].to_s).iso8601 if page["date"]
      modified = page["last_modified_at"] || page["last_modified"]
      node["dateModified"] = Date.parse(modified.to_s).iso8601 if modified
      header = page["header"] || {}
      image = page["image"] || header["image"] || header["teaser"] || page["preview"] ||
              site.config["teaser"] || site.config["logo"]
      image = image["path"] if image.is_a?(Hash)
      node["image"] = url({ "url" => image }, site) if image
      node["citation"] = page["citations"] if page["citations"]
      if page["doi"]
        node["identifier"] = [canonical, { "@type" => "PropertyValue", "propertyID" => "DOI", "value" => page["doi"] }]
      end
      nodes << node
    end
    { "@context" => "https://schema.org", "@graph" => nodes }
  end

  module Filters
    def scholarly_author(page, _site = nil)
      ScholarlyMetadata.author(page, @context.registers[:site])
    end

    def scholarly_url(page, _site = nil)
      ScholarlyMetadata.url(page, @context.registers[:site])
    end

    def scholarly_graph(page, _site = nil)
      ScholarlyMetadata.graph(page, @context.registers[:site])
    end
  end
end

Liquid::Template.register_filter(ScholarlyMetadata::Filters)
