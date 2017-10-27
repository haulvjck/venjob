require 'csv'
require 'net/ssh'
require 'net/ftp'
require 'yaml'

class ImportJob

  VIETNAM = 'VietNam'

  def settings
    YAML.load_file('./config/app_settings.yml')
  end

  def jobs
    jobs = []
    csv_text = File.read([settings['root_path_file'], 'jobs.csv'].join(""))
    CSV.parse(csv_text, :headers => true).each do |row|
      jobs << row.to_hash
    end

    jobs
  end

  def cmd
    'unzip -o jobs.zip jobs.csv'
  end

  def ssh
    Net::SSH.start(settings['ftp_server']['host_name'], settings['ftp_server']['user_name'], :password => settings['ftp_server']['password'])
  end

  def ftp
    Net::FTP.new(settings['ftp_server']['host_name'], settings['ftp_server']['user_name'], settings['ftp_server']['password'])
  end

  def get_file
    begin
      ssh.exec!(cmd)
      ssh.close

      file = [settings['root_path_file'], 'jobs.csv'].join("")
      ftp.get 'jobs.csv', file, 1024
      ftp.close

      file
    rescue Exception => exp
      Rails.logger.info exp.message
      Rails.logger.info exp.backtrace.join("\n")
    end
  end

  def import
    return if jobs.blank?

    begin
      jobs.each do |job|
        import_job(job)
      end
    rescue Exception => exp
      Rails.logger.info exp.message
      Rails.logger.info exp.backtrace.join("\n")
    end
  end

  def import_job(job)
    job_h = {}
    loc_h = {}

    loc_h[:city_id] = import_city(job).id if import_city(job)
    loc_h[:country] ||= VIETNAM
    loc_h[:district] = job['company district']
    loc_h[:address] = job['company address']
    job['location_id'] = Location.create!(loc_h).id

    job_h[:company_id] = import_company(job).id if import_company(job)
    settings['jobs'].select{|key, val| job_h[val.to_sym] = job[key] }
    job_h[:created_at] = DateTime.parse(job['created_at']).strftime('%F') if job['created_at']
    job_h[:title] ||= job_h[:name]

    job_id = Job.create!(job_h).id
    ind_ids = import_industry(job['category'])
    import_job_industries(job_id, ind_ids)
  end

  def import_job_industries(job_id, industry_ids)
    return if industry_ids.blank?

    industry_ids.each do |i_id|
      JobIndustry.create!(:job_id => job_id, :industry_id => i_id)
    end
  end

  def import_industry(inds)
    return if inds.blank?

    ind_ids = []
    inds.split(",").each do |ind_name|
      ind_name = remove_character(ind_name)
      industry = Industry.find_or_create_by(name: ind_name)
      ind_ids << industry.id
    end

    ind_ids
  end

  def import_city(job)
    city = if job['company province'] || job['work place']
      province = remove_character(job['company province'].split(",").first) || remove_character(job['work place'].split(",").first)
      City.find_or_create_by(name: province)
    end
  end

  def import_company(job)
    company = if job['company name']
      Company.create_with(
          location_id: job['location_id'],
          company_id: job['company id'],
          name: job['company name'],
          introductions: job['introductions']
      ).find_or_create_by(name: job['company name'])
    end
  end

  def remove_character(name)
    name.downcase.strip if name
  end
end