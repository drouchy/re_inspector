defmodule ReInspector.Correlator do
  use Behaviour

  defcallback request_name(message :: Map) :: String
  defcallback support?(message :: ReInspector.ApiRequest) :: Boolean
  defcallback additional_information(message :: ReInspector.ApiRequest) :: Map
  defcallback extract_correlation(message :: ReInspector.ApiRequest) :: List
  defcallback obfuscate(message :: ReInspector.ApiRequest) :: List

end
