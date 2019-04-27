require "funny_guy/version"
require "faraday"
require "faraday_middleware"

module FunnyGuy
end

require "funny_guy/errors"
require "funny_guy/data_source"
require "funny_guy/data_source/http_client"
require "funny_guy/data_source/middleware/response/error_handler"
require "funny_guy/data_source/i_can_haz_dad_joke"
