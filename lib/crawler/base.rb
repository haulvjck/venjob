require 'open-uri'
require 'mechanize'
require 'net/http'
require 'uri'

class Base

  JOB_CRAWLED_FILE = 'jobs_crawled_urls.log'

  def settings
    YAML.load_file('./config/app_settings.yml')
  end

  def crawled_urls
    CrawledUrl.all.map(&:url)
  end

  def get_page(url)
    tries = 0
    Nokogiri::HTML(open(URI.escape(url)), nil, Encoding::UTF_8.to_s)

  rescue Exception => e
    Rails.logger.info url
    Rails.logger.info e.message

    tries += 1
    if tries < 3
      sleep(1);retry
    end

    return
  end

  def parse_url(content, partern=nil)
    return [] if content.blank?

    content.css('a').map {|element| element["href"] if element["href"].match(partern)}.compact
  end
end

