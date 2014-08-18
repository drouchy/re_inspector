defmodule AWS do
  require Record
  Record.defrecord :aws_config, Record.extract(:aws_config, from_lib: "erlcloud/include/erlcloud_aws.hrl")

end