require './config/environment.rb'
require './lib/import/jobs.rb'
require './lib/crawler/career_job.rb'
require './app/models/services/solr_adapter.rb'

namespace :jobs do
  desc "Import jobs from data file"
  task :import do |t, args|
    ImportJob.new.import
  end
end

namespace :crawler do
  desc "Crawl job from client site"
  task :crawl do |t, args|
    CareerJob.new.crawl
  end
end

namespace :email do
  desc "Test send mail"
  task :send do |t, args|
    email_params = {
      email: 'vhaulee@gmail.com',
      apply_email: 'vhaulee@gmail.com',
      full_name: "@apply_full_name",
      job_title: "job.title",
      location: "job.address",
      company: "job.company_name",
      cv_path: "@apply_cv"
    }
    UserMailer.apply_job_email(email_params).deliver_now
  end
end

namespace :solr do
  include Solr
  desc "Crawl job from client site"
  task :test do |t, args|
    Solr::SolrAdapter.new.index_solr
  end
end