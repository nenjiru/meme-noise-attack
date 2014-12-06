# -*- coding: utf-8 -*-
RAILS_ROOT   = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)

worker_processes 1
preload_app true
timeout 60
listen "unix:#{RAILS_ROOT}/tmp/sockets/unicorn.sock"

pid "#{RAILS_ROOT}/tmp/pids/unicorn.pid"

stderr_path "#{RAILS_ROOT}/log/unicron.log"
stdout_path "#{RAILS_ROOT}/log/unicron.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH

    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
