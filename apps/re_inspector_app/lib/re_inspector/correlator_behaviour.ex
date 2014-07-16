defmodule ReInspector.Correlator do
  use Behaviour

  defcallback request_name(message :: Map) :: String
  defcallback support?(message :: ReInspector.App.ApiRequest) :: Boolean
  defcallback additional_information(message :: ReInspector.App.ApiRequest) :: Map
  defcallback extract_correlation(message :: ReInspector.App.ApiRequest) :: List
  defcallback obfuscate(message :: ReInspector.App.ApiRequest) :: List

end
