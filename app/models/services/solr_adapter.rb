require 'rsolr'

module Solr
  class SolrAdapter
    def initialize(keyword)
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
      q = "*:*"

      if @keyword.present?
        keyword = @keyword.gsub(/[\s]/,"+")
        q = settings['field_search'].collect {|field,score| "#{field}:\"#{keyword}\"^#{score}"}
      end
      request(q)

    end

    def query_by_location
      q = "*:*"
      if @keyword.present?
        keyword = escape_string(@keyword)
        q = "address:\"#{keyword}\"^2 OR city_name:\"#{keyword}\"^1"
      end

      request(q)
    end

    def query_by_company
      q = "*:*"
      if @keyword.present?
        keyword = escape_string(@keyword)
        q = "company_name:\"#{keyword}\"^3 OR introductions:\"#{keyword}\"^2 OR title:\"#{keyword}\"^1"
      end
      request(q)
    end

    def request(q)
      h = {
        "q" => q
      }
      uri = @solr.build_request 'select', :params => h
      Rails.logger.info "SolrUrl: #{uri}"
      start = Time.now
      response = @solr.get 'select', :params => h
      request_time = Time.now - start

      Rails.logger.info "Request Time: #{request_time} seconds"
      response
    end

    def escape_string(str)
      str.gsub(/[\-+\/\"]+/,"")
    end
  end
end
