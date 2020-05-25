local typedefs = require "kong.db.schema.typedefs"
local Schema = require "kong.db.schema"

local PROTECTED_TAGS = {
  "error",
  "http.method",
  "http.path",
  "http.status_code",
  "kong.balancer.state",
  "kong.balancer.try",
  "kong.consumer",
  "kong.credential",
  "kong.node.id",
  "kong.route",
  "kong.service",
  "lc",
  "peer.hostname",
}

local static_tag = Schema.define {
  type = "record",
  fields = {
    { name = { type = "string", required = true, not_one_of = PROTECTED_TAGS } },
    { value = { type = "string", required = true } },
  },
}

return {
  name = "zipkin",
  fields = {
    { config = {
        type = "record",
        fields = {
          { http_endpoint = typedefs.url{ required = true } },
          { sample_ratio = { type = "number",
                             default = 0.001,
                             between = { 0, 1 } } },
                                        { default_service_name = { type = "string", default = nil } },
          { include_credential = { type = "boolean", required = true, default = true } },
          { traceid_byte_count = { type = "integer", required = true, default = 16, one_of = { 8, 16 } } },
          { header_type = { type = "string", required = true, default = "preserve",
                            one_of = { "preserve", "b3", "b3-single", "w3c" } } },
          { static_tags = { type = "array", elements = static_tag } }
        },
    }, },
  },
}
