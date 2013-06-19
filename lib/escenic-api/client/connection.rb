module Escenic
  module API

    class RequestInfo < Struct.new(:http_method, :uri, :headers, :content)
    end

    class Connection

      def initialize
        raise Escenic::API::Error::Config unless Escenic::API::Config.http_ready?
      end

      # http GET
      # @param [String] url - the url to visit
      # @param [hash] headers - the headers for the request.
      # @param [Hash] options - the options of the request.
      # @return [HTTPResponse] a response object
      def get(url, headers = {}, options={})
        request_info = RequestInfo.new(
            Net::HTTP::Get,
            uri_from_url(url),
            headers,
            options[:body]
        )
        response     = do_request request_info
        response.body
      end

      def uri_from_url(url)
        URI.parse(url)
      end

      # http DELETE, deletes an entry
      # @param [String] url - the url to visit
      # @param [hash] headers - the headers for the request.
      # @param [Hash] options - the options of the request.
      # @return [Hash] a hash of the response
      def delete(url, headers = {}, options = {})
        request_info = RequestInfo.new(
            Net::HTTP::Delete,
            uri_from_url(url),
            headers,
            options[:body]
        )
        do_request(request_info).to_hash
      end

      # http POST, pushes an update to an entry
      # @param [String] url - the url to visit
      # @param [hash] headers - the headers for the request.
      # @param [Hash] options - the options of the request.
      # @return [Hash] a hash of the response
      def post(url, headers = {}, options = {})
        request_info = RequestInfo.new(
            Net::HTTP::Post,
            uri_from_url(url),
            send_headers(headers),
            options[:body]
        )
        do_request(request_info).to_hash
      end

      # http PUT, pushes a new entry to the system
      # @param [String] url - the url to visit
      # @param [hash] headers - the headers for the request.
      # @param [Hash] options - the options of the request.
      # @return [Hash] a hash of the response
      def put(url, headers = {}, options = {})
        request_info = RequestInfo.new(
            Net::HTTP::Put,
            uri_from_url(url),
            send_headers(headers),
            options[:body]
        )
        do_request(request_info).to_hash
      end

      def send_headers(headers)
        headers['if-match'] = '*' unless headers.has_key? 'if-match'
        headers['content-type'] = 'application/atom+xml' unless headers.has_key? 'content-type'
        headers
      end

      # generates the base request, including authorization, and content type info if PUT/POST.
      # @param [RequestInfo] request_info - settings for the request
      # @return [Net::Http] - a child of Net::Http matching the request method.
      def base_request(request_info)
        req = request_info.http_method.new "#{request_info.uri.path}?#{request_info.uri.query}"
        req.basic_auth Escenic::API::Config.user, Escenic::API::Config.pass
        request_info.headers.each { |key, value|
          req[key] = value
        }
        req
      end

      # do_request performs the request, filters it through get_response to get the response
      # and then generates a result with get_result
      # @param [RequestInfo] request_info - settings for the request
      # @return [Net::HTTPResponse] response - response from server
      def do_request(request_info)
        get_response do
          Net::HTTP.start(request_info.uri.host, request_info.uri.port) do |http|
            http.request(base_request(request_info), request_info.content)
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
