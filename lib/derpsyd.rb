require 'rubygems'
require 'daemons'
require File.expand_path('../../config', __FILE__)

config = Derpsy.config

daemon_options = { :log_dir => config[:working_directory],
            :dir_mode => :normal,
            :dir => config[:working_directory],
            :backtrace => true,
            :monitor => true
          }

Daemons.run( File.join(File.dirname(__FILE__), 'derpsy-runner.rb'), daemon_options )
