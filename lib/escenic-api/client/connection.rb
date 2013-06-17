module Escenic
  module API

    class Connection

      def initialize
        raise Escenic::API::Error::Config unless Escenic::API::Config.http_ready?
      end

      # http GET
      # @param [String] url - the url to visit
      # @param [Hash] options - the options for the request.
      # @return [HTTPResponse] a response object
      def get(url, options = {})
        options = {http_class: Net::HTTP::Get}.merge options
        options = request_core url, options
        response = do_request options
        response.body
      end

      # http request core, sets uri, and base request object
      # @param [String] url - the url to visit
      # @param [Hash] options - the options for the request.
      # @return [Hash] a hash of the response
      def request_core(url, options)
        options       = {uri: URI.parse(url)}.merge options
        options[:req] = base_request options
        options
      end

      # http DELETE, deletes an entry
      # @param [String] url - the url to visit
      # @param [Hash] options - the options for the request.
      # @return [Hash] a hash of the response
      def delete(url, options = {})
        options = {http_class: Net::HTTP::Delete}.merge options
        options = request_core url, options
        do_request(options).to_hash
      end

      # http POST, pushes an update to an entry
      # @param [String] url - the url to visit
      # @param [Hash] options - the options for the request.
      # @return [Hash] a hash of the response
      def post(url, options = {})
        options = {http_class: Net::HTTP::Post, send: true}.merge options
        options = request_core url, options
        do_request(options).to_hash
      end

      # http PUT, pushes a new entry to the system
      # @param [String] url - the url to visit
      # @param [Hash] options - the options for the request.
      # @return [Hash] a hash of the response
      def put(url, options = {})
        options = {http_class: Net::HTTP::Put, send: true}.merge options
        options = request_core url, options
        do_request(options).to_hash
      end

      # generates the base request, including authorization, and content type info if PUT/POST.
      # @param [Map] options - settings for the request
      # @return [Net::Http] - a child of Net::Http matching the request method.
      def base_request(options)
        req = options[:http_class].new "#{options[:uri].path}?#{options[:uri].query}"
        req.basic_auth Escenic::API::Config.user, Escenic::API::Config.pass
        if options[:send]
          req['If-Match']     = options[:ifmatch] ? options[:ifmatch] : '*'
          req['Content-type'] = options[:type] ? options[:type] : 'application/atom+xml'
        end
        req
      end

      # do_request performs the request, filters it through get_response to get the response
      # and then generates a result with get_result
      # @param [Map] options - settings for the request
      # @return [Net::HTTPResponse] response - response from server
      def do_request(options)
        options  = {raw: false}.merge options
        get_response do
          Net::HTTP.start(options[:uri].host, options[:uri].port) do |http|
            http.request(options[:req], options[:body])
          end
        end
      end

      # get_response gets the response from the server (via block) and checks for errors.
      # @return [Net::HTTPResponse] response from http
      def get_response
        response = yield
        handle_error response
        response
      end

      # handle_error handles http errors resulting from the request.
      # @param [Net::HTTPResponse] response - the response from the server to process.
      def handle_error(response)
        raise Escenic::API::Error::ConnectionFailed if !response
        error = error_lookup response
        raise error.new(response.body) if error
      end

      # error_lookup returns errors to throw, or nil if no error occurred.
      # @param [Net::HTTPResponse] response - the response from the server to process.
      # @return [Escenic::API::Error] error matching the state, or nil
      def error_lookup(response)
        case response.code.to_i
          when 401
            Escenic::API::Error::Unauthorized
          when 403
            #TODO Parse response and display useful message.
            Escenic::API::Error::Forbidden
          when 404
            Escenic::API::Error::NotFound
          when 400, 406
            #TODO Parse response and display useful message.
            Escenic::API::Error
          when 300..302, 304..399
            Escenic::API::Error::Redirect
          when 500..599
            Escenic::API::Error::ServerError
          else
            nil
        end
      end
    end
  end
end

# update HTTPResponse with a to_hash method.
class Net::HTTPResponse
  # turns the xml of a body into a hash
  # @return a hash of the XML or nil.
  def to_hash
    if @body.nil? || @body.empty?
      self
    else
      Hash.from_xml(@body)
    end
  end
end
