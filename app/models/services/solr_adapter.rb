require 'rsolr'

module Solr
  class SolrAdapter
    def initialize(keyword=nil)
      @solr = RSolr.connect(
        :url => settings['solr_url'],
        :read_timeout => 600,
        :open_timeout => 600,
        :retry_503    => 2
      )
      @keyword = keyword
    end

    def settings
      YAML.load_file('./config/app_settings.yml')
    end

    def index_solr
      jobs = Job.jobs_index_solr.collect do |job|
        {
          id: job.id,
          title: job.title,
          description: job.full_desc,
          salary: job.salary,
          company_name: job.company_name,
          city_name: job.city_name,
          introductions: job.company.introductions,
          address: job.location.address,
          industry: job.industries.collect{|i| i.name }.join(",")
        }
      end

      @solr.add  jobs
    end

    def query_all
      q = settings['field_search'].split(',').collect{ |field| [field, @keyword].join(':')}.join(" OR ")
      h = {
        "q" => q
      }

      request(h)
    end

    def query_by_location
      h = {
        "q" => "address:#{@keyword} OR city_name:#{@keyword}"
      }

      request(h)
    end

    def query_by_company
      h = {
        "q" => "company_name:#{@keyword}"
      }

      request(h)
    end

    def request(query)
      uri = [@solr.uri.to_s, 'select?', query].join("")
      Rails.logger.info "SolrUrl: #{uri}"
      start = Time.now
      response = @solr.get 'select', :params => query
      request_time = Time.now - start

      Rails.logger.info "Request Time: #{request_time} seconds"
      response
    end
  end
end
