require 'rainbow'
require 'nokogiri'
require 'uri'
require 'set'
require 'net/http'

class CrawlErrors
  attr_accessor :report_errors_only
  attr_accessor :log

  def initialize(origin_uri)
    @origin_uri = origin_uri
    @visited = Set.new
    @queue = []
  end

  def run
    @queue << @origin_uri
    until @queue.empty?
      uri = @queue.shift
      crawl uri
    end
  end

  def crawl uri
    return unless @visited.add? uri

    session = Net::HTTP.new uri.host, uri.port
    session.start do |http|
      options = {}
      options['Accept'] = '*/*'
      result = http.request_get uri.request_uri, options
      case result
      when Net::HTTPSuccess
        report_success uri
        body = result.read_body
        find_and_crawl_links body, uri
      when Net::HTTPRedirection
        new_uri = uri.merge(URI.parse(result['location']))
        report_redirect uri, new_uri
        @queue << uri unless should_crawl?(new_uri)
      else
        report_error uri, result
      end
    end
  end

  def find_and_crawl_links body, origin
    page = Nokogiri::HTML(body)
    page.css('a').each do |a|
      url = origin.merge(URI.parse(a['href'])) rescue nil
      @queue << url if url && should_crawl?(url)
    end
  end

  def should_crawl? uri
    uri.host == @origin_uri.host && uri.port == @origin_uri.port && !@visited.include?(uri)
  end

  def report_error uri, kind
    line = "error".ljust(10).color(:red).bright + uri.to_s + " (#{kind.class.name})".color(:red)
    log line
    $stdout.puts(line)
  end

  def report_success uri
    $stdout.puts("ok".ljust(10).color(:green).bright + uri.to_s) unless @report_errors_only
  end

  def report_redirect uri, new_uri
    $stdout.puts("redirect".ljust(10).color(:yellow) + "#{uri} => #{new_uri}") unless @report_errors_only
  end

  def log line
    system "[#{Time.now.to_s}] echo \"#{line}\" >> #{@log}" if @log
  end
end
