module EsiErrors
  class BadGateway < Base

    def pause
      sleep 10
    end

    def retry?
      true
    end

  end
end