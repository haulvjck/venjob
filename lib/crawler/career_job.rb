require './lib/crawler/base.rb'

class CareerJob < Base

  SALARY = 'salary'
  NEXT_PAGE = '[rel="next"]'
  JOB_URL_PARTERN = /^[\w|\W]+tim-viec-lam[\w|\W]+.html$/
  PAGE_URL_PATERN = /^([\w|\W]+tat-ca-viec-lam-trang-)([\d]+)(-vi.html)$/
  FIRST_PAGE = 'https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html'
  DESCRIPTION = 'description'
  JOB_DETAILS = 'job_details'

  def crawl
    success_urls = []
    urls = get_urls

    puts urls.length

    urls.each do |url|
      content = get_page(url)
      next if content.blank?

      parse_job_info(content)
      success_urls << url
    end

    success_urls.each do |url|
      CrawledUrl.create(:url => url)
    end

    fails_urls = (urls - success_urls)
    Logger.new(settings['crawl_log_file']).fatal(fails_urls)
  end

  def get_urls
    urls = []
    page_num = 1
    page_url = FIRST_PAGE

    loop do
      page_url.gsub!(page_url.match(PAGE_URL_PATERN)[2], page_num.to_s)
      content = get_page(page_url)

      urls += parse_url(content, JOB_URL_PARTERN).uniq - crawled_urls
      break if (urls.length > settings['URL_BATCH_SIZE'] || content.search(NEXT_PAGE).blank?)
      page_num += 1
    end

    urls.uniq
  rescue Exception => exp
    puts exp.message
    return []
  end

  def parse_job_info(html_content)
    setting = settings['css_tree']
    job = {}

    parent_content = html_content.search(setting['parent'])

    return if parent_content.empty?

    setting['tags'].each do |set_key, set_val|

      css_val = parent_content.search(set_val).children.text
      case set_key
      when DESCRIPTION
        css_val = parent_content.css(set_val).inner_html
        job[set_key] = escape_string(css_val) if css_val
      when JOB_DETAILS
        job.merge!(get_job_detail(css_val)) if css_val
      else
        job[set_key] = escape_string(css_val) if css_val
      end
    end

    if job.present?
      ImportJob.new.import_job(job)
    end
  rescue Exception => exp
    Rails.logger.info exp.message
    Rails.logger.info exp.backtrace.join("\n")
  end

  # string to array and escape specical character
  def escape_string(str)
    str.strip.gsub(/\s+/, ' ')
  end

  def get_job_detail(vals)
    return {} if vals.blank?

    job_details = {}

    keys = ["Nơi làm việc", "Cấp bậc", "Kinh nghiệm", "Lương", "Ngành nghề", "Hết hạn nộp"]
    settings['job_patern'].each do |field, field_patern|
      reg_val = vals.match(Regexp.new(field_patern))
      val = (reg_val[3] || "").split(":").first if reg_val
      pattern = /\b(?:#{ Regexp.union(keys).source })\b/
      job_details[field] = val.gsub(pattern, '').squeeze(' ').strip
    end

    job_details
  end
end

