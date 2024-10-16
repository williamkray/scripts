#!/usr/bin/env ruby

######################
######################
##
##  This is a dead-simple http server.
##  Due to its simplicity, it may run into issues
##  when the client calling it expects certain headers,
##  as in the case with load balancer health checks.
##  Modify as needed to fit your use case.
##
######################
######################

require 'socket' # Provides TCPServer and TCPSocket classes

server = TCPServer.new('localhost', 8080) # set the host to an empty string to listen on ALL available addresses

loop do

  # Wait until a client connects, then return a TCPSocket
  socket = server.accept

  # Read the first line of the request (the Request-Line) and include the requesting IP address
  request = "[#{socket.peeraddr.last}] #{socket.gets}"

  # Log the request to the console for debugging
  STDERR.puts request

  @code = "200 OK"
  @response = "WOW! A super simple ruby web server! AMAZING."

  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 #{@code}\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{@response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body
  socket.print @response

  # Close the socket, terminating the connection
  socket.close
end
