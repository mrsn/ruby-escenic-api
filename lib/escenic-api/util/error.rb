module Escenic
  module API

    class Error < Exception

      class Params            < Exception; end
      class Config            < Exception; end
      class NotFound          < Exception; end
      class Redirect          < Exception; end
      class Forbidden         < Exception; end
      class ServerError       < Exception; end
      class Unauthorized      < Exception; end
      class ConnectionFailed  < Exception; end

    end

  end
end