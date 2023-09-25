#!/usr/bin/env ruby
# Software Name: Tips'n'tools
# SPDX-FileCopyrightText: Copyright (c) 2016-2023 Pierre-Yves Lapersonne
# SPDX-License-Identifier: MIT
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 2.0.0
# Since...............: 21/03/2018
# Description.........: Receives HTTP requests and parse them so as to feed with data.
#                       Uses the core's Shell script to make the queries.
#
# Usage: ruby datafeed.rb
#
# Samples of requests:
# => http://SERVER_ADDRESS:PORT/getAll
# => http://SERVER_ADDRESS:PORT/filterAll?filter=Apple
# => http://SERVER_ADDRESS:PORT/filterTools?filter=Android
# => http://SERVER_ADDRESS:PORT/filterWebs?filter=BTC
# => http://SERVER_ADDRESS:PORT/filterDevices?filter=Huawei
# => http://SERVER_ADDRESS:PORT/filterSocs?filter=Kirin
#
# Example of CURL command for tests:  curl  -X GET "http://localhost:4343/filterAll?filter=charts"
#
# ✿✿✿✿ ʕ •ᴥ•ʔ/ ︻デ═一
#

# ############
# Some imports
# ############

# For the HTTP servlet
require 'webrick'
# For the Bash scripts
require 'shellwords'

# #############
# Configuration
# #############

# The configuration of the server
SERVER_ADDRESS = "localhost"
PORT = 4343

# The action to process
ACTION_GET_ALL = "/getAll"
ACTION_FILTER_ALL = "/filterAll"
ACTION_FILTER_TOOLS = "/filterTools"
ACTION_FILTER_WEBS = "/filterWebs"
ACTION_FILTER_DEVICES = "/filterDevices"
ACTION_FILTER_SOCS = "/filterSocs"

# The key of the parameters
KEY_FILTER = "filter"

# ################
# Useful functions
# ################

# To use BASH interpretor instead of SH
def bash(command)
  escaped_command = Shellwords.escape(command)
  system "bash -c #{escaped_command}"
end

# Execute the command and return the data
def processCommand(command)
  resultsFile = "results.json"
  bash(command + " --json > " + resultsFile)
  file = open resultsFile
  fileContent = file.read
  file.close
  File.delete(resultsFile)
  return fileContent
end

# ###########
# The servlet
# ###########

# The servlet which will receive the requests and process them to feed with data
class FeedServlet < WEBrick::HTTPServlet::AbstractServlet

  # Receive GET request
  def do_GET (request, response)

    response.status = 200
    response.content_type = "application/json"
    response.header['Access-Control-Allow-Origin'] = '*'
    response.header['Access-Control-Request-Method'] = '*'
    
    results = nil

    # Check the path, i.e. the action to process
    case request.path

      # In this case, feed with all data
      when ACTION_GET_ALL

        puts "Should feed with all data"
        results = processCommand("./tipsntools.sh --full")
        response.body = results.to_s

      # In this case, we filter all the objects
      when ACTION_FILTER_ALL

        puts "Should filter all data"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findAll " + filter + " --json")
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the tools
      when ACTION_FILTER_TOOLS

        puts "Should filter only tools"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findTool " + filter + " --json")
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the web things / references
      when ACTION_FILTER_WEBS

        puts "Should filter only web references"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findWeb " + filter + " --json")
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the devices' specifications
      when ACTION_FILTER_DEVICES

        puts "Should filter only devices specifications"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findDevices " + filter + " --json")
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the SoCs' specifications
      when ACTION_FILTER_SOCS

        puts "Should filter only SoCs specifications"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findSocs " + filter + " --json")
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # Not managed
      else
        puts "The action is not managed"
        response.body = '{"error": "The action is not managed here"}'

    end # End of case request.path

  end # End of def do_GET (request, response)

end # End of class FeedServlet < WEBrick::HTTPServlet::AbstractServlet

# ############
# Kind of main
# ############

server = WEBrick::HTTPServer.new(:BindAddress => SERVER_ADDRESS, :Port => PORT)
server.mount "/", FeedServlet

trap("INT") {
  server.shutdown
}

puts "Tips-n-tools - data feed Ruby script"
server.start
puts "Bye!"
