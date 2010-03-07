#!/usr/bin/ruby -w

class HostFinder
  
  def initialize(octets)
    if octets !~ /\A(?:\d{1,3}\.){2}\d{1,3}\z/
      puts "Usage: hostfinder.rb 192.168.1"
      exit
    end
    @octets = octets
    @hosts = []
    @workers = []
  end

  def find
    1.upto(254) do |num|
      ip = "#{@octets}." + num.to_s
      @workers << Thread.new do
        if ping(ip)
          @hosts << ip
        end
        Thread.pass
      end
    end
    @workers.each do |worker|
      worker.join unless worker == Thread.main
    end
  end
  
  def ping(ip, count = 1)
    @result = `ping -c #{count} #{ip}`
    @result.split('\n').each do |line|
      if line =~ /(\d+) bytes from/
        return true
      end
    end
    return false
  end

  def print
    if @hosts.empty?
      puts "No hosts found."
    else
      @hosts.sort!
      puts "Found the following hosts:"
      @hosts.each do |host|
        puts host
      end
    end
  end
end

if $0 == __FILE__
  finder = HostFinder.new(ARGV[0])
  finder.find
  finder.print
end
