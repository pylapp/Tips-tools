#!/usr/bin/env ruby
#
#    MIT License
#    Copyright (c) 2016-2020 Pierre-Yves Lapersonne (Mail: dev@pylapersonne.info)
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.
#
#
# Author..............: Pierre-Yves Lapersonne
# Version.............: 1.0.0
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
          results = processCommand("./tipsntools.sh --findAll "+filter)
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the tools
      when ACTION_FILTER_TOOLS

        puts "Should filter only tools"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findTools "+filter)
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the web things / references
      when ACTION_FILTER_WEBS

        puts "Should filter only web references"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findWeb "+filter)
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the devices' specifications
      when ACTION_FILTER_DEVICES

        puts "Should filter only devices specifications"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findDevices "+filter)
          response.body = results.to_s
        else
          response.body = '{"error": "The filter to apply is missing"}'
        end

      # In this case, we filter only the SoCs' specifications
      when ACTION_FILTER_SOCS

        puts "Should filter only SoCs specifications"
        filter = request.query[KEY_FILTER]
        if filter && filter.length > 0
          results = processCommand("./tipsntools.sh --findSocs "+filter)
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
