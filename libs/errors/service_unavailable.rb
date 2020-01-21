module EsiErrors
  class ServiceUnavailable < Base

    def pause
      sleep 120
    end

    def retry?
      true
    end

  end
end