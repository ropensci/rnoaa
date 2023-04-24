.onAttach = function(libname,pkgname) {

  packageStartupMessage("The rnoaa package will soon be retired and archived because the underlying APIs have changed dramatically. The package currently works but does not pull the most recent data in all cases. A noaaWeather package is planned as a replacement but the functions will not be interchangeable.")

  options(geonamesUsername = "schamber789")
  options(geonamesHost = "api.geonames.org")
}
