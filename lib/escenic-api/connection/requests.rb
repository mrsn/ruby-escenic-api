module Escenic
  module API
    class Connection

      module Requests

        def request
          response = yield
          raise Escenic::API::Error::ConnectionFailed if !response
          status = response.code.to_i
          case status
            when 401
              raise Escenic::API::Error::Unauthorized
            when 403
              raise Escenic::API::Error::Forbidden.new(response.body)
            when 404
              raise Escenic::API::Error::NotFound
            when 400, 406
              raise Escenic::API::Error.new(response.body)
            when 300..399
              raise Escenic::API::Error::Redirect
            when 500..599
              raise Escenic::API::Error
            else
              response.body
          end
        end

        def get(url, options = {})

          uri = URI.parse(url)
          req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
          req.basic_auth @user, @pass

          response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end

          response
        end

        def delete(url, options = {})
          uri = URI.parse(url)
          req = Net::HTTP::Delete.new("#{uri.path}?#{uri.query}")
          req.basic_auth @user, @pass

          response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req)
          end

          response
        end

        def post(url, options = {})
          uri = URI.parse(url)
          req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
          req.basic_auth @user, @pass

          body = options[:body]
          req['Content-type'] = options[:type] ?
            options[:type] : req['Content-type'] = 'application/atom+xml'
          response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req, body)
          end

          response
        end

        def put(url, options = {})
          uri = URI.parse(url)
          req = Net::HTTP::Put.new("#{uri.path}?#{uri.query}")
          req.basic_auth @user, @pass
          body = options[:body]
          req['Content-type'] = options[:type] ?
              options[:type] : req['Content-type'] = 'application/atom+xml'
          response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.request(req, body)
          end

          response
        end


      end

    end
  end
end