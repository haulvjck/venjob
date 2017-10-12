require './config/environment.rb'
require './lib/import/jobs.rb'
require './lib/crawler/career_job.rb'

namespace :jobs do
  desc "Import jobs from data file"
  task :import do |t, args|
    ImportJob.new.import
  end
end

namespace :crawler do
  desc "Download file from ftp"
  task :crawl do |t, args|
    CareerJob.new.crawl
  end
end
