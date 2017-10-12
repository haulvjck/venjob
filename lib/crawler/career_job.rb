require './lib/crawler/base.rb'

class CareerJob < Base

  SALARY = 'salary'
  NEXT_PAGE = '[rel="next"]'
  JOB_URL_PARTERN = /^[\w|\W]+tim-viec-lam[\w|\W]+.html$/
  PAGE_URL_PATERN = /^([\w|\W]+tat-ca-viec-lam-trang-)([\d]+)(-vi.html)$/
  FIRST_PAGE = 'https://careerbuilder.vn/viec-lam/tat-ca-viec-lam-trang-1-vi.html'

  def crawl
    success_urls = []
    urls = get_urls

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
      attr_vals = []

      set_val.split(',').each do |val|
        css_val = parent_content.search(val).children.text
        attr_vals += escape_array(css_val) if css_val
      end

      next if attr_vals.blank?
      job[set_key] = (set_key == SALARY) ? get_salary(attr_vals) : attr_vals.join("\n")
    end

    if job.present?
      ImportJob.new.import_job(job)
    end

  rescue Exception => exp
    Rails.logger.info exp.message
    Rails.logger.info exp.backtrace.join("\n")
  end

  # string to array and escape specical character
  def escape_array(str)
    return [] if str.blank?

    str.split("\n").collect! { |e| e.strip.gsub(/\s+/, ' ') }.compact.reject(&:empty?)
  end

  def get_salary(vals)
    vals.collect!.with_index { |e,i| vals[i+1] if  %w(lương salary).any? { |s| e.downcase.include? s } }.compact

    vals.join("")
  end
end

