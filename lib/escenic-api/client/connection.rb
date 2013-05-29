module Escenic
  module API

    class Connection

      def initialize
        raise Escenic::API::Error::Config if
          Escenic::API::Config.user.nil?    ||
          Escenic::API::Config.pass.nil?    ||
          Escenic::API::Config.base_url.nil?
      end

      def request(options = {})
        response = yield
        raise Escenic::API::Error::ConnectionFailed if !response
        status = response.code.to_i
        case status
          when 401
            raise Escenic::API::Error::Unauthorized
          when 403
            #TODO Parse response and display useful message.
            raise Escenic::API::Error::Forbidden.new(response.body)
          when 404
            raise Escenic::API::Error::NotFound
          when 400, 406
            #TODO Parse response and display useful message.
            raise Escenic::API::Error.new(response.body)
          when 300..302,304..399
            raise Escenic::API::Error::Redirect
          when 500..599
            raise Escenic::API::Error::ServerError
          else
            if response.body.nil? || response.body.empty?
              response
            else
              options[:raw] ? response.body : Hash.from_xml(response.body)
            end
        end
      end

      def get(url, options = {})
        uri = URI.parse(url)
        req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
        req.basic_auth  Escenic::API::Config.user, Escenic::API::Config.pass

        request do
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end
        end
      end

      def get_raw(url, options = {})

        uri = URI.parse(url)
        req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
        req.basic_auth  Escenic::API::Config.user, Escenic::API::Config.pass

        request(raw: true) do
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end
        end
      end

      def delete(url, options = {})
        uri = URI.parse(url)
        req = Net::HTTP::Delete.new("#{uri.path}?#{uri.query}")
        req.basic_auth Escenic::API::Config.user, Escenic::API::Config.pass

        request do
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end
        end
      end

      def post(url, options = {})
        uri = URI.parse(url)
        req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
        req.basic_auth Escenic::API::Config.user, Escenic::API::Config.pass

        body = options[:body]
        req['If-Match']     = options[:ifmatch] ? options[:ifmatch] : '*'
        req['Content-type'] = options[:type] ? options[:type] : 'application/atom+xml'

        request do
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req, body)
          end
        end
      end

      def put(url, options = {})
        uri = URI.parse(url)
        req = Net::HTTP::Put.new("#{uri.path}?#{uri.query}")
        req.basic_auth Escenic::API::Config.user, Escenic::API::Config.pass

        body = options[:body]
        req['If-Match']     = options[:ifmatch] ? options[:ifmatch] : '*'
        req['Content-type'] = options[:type] ? options[:type] : 'application/atom+xml'

        request do
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req, body)
          end
        end
      end

    end

  end
end