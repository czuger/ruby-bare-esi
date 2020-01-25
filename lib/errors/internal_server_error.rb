module EsiErrors
  class InternalServerError < Base
    RETRY=true
  end
end