# based on https://gist.githubusercontent.com/Myuzu/7367461/raw/18876bc560dfbc95d2c6cb490b777f2f30061448/secure_random.ex
defmodule ReInspector.Random do
  @default_length 32

  def generate(length \\ @default_length) do
    random_bytes(length)
    |> :base64.encode_to_string
    |> to_string
  end

  defp random_bytes(length) do
    :crypto.strong_rand_bytes(length)
  end
end
