ExUnit.start

ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
Logger.remove_backend :console
ReInspector.Backend.Router.start
