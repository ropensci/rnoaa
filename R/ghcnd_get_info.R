#=====================================================================================================================================================================
# NOAA GHCND
# Function to download and save the info files to a local directory
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndGetInfo <- function(x){
  # x=Main folder path
  
  dir.create(file.path(x,"Info"), showWarnings = FALSE) # Create the directory if it does not exist
  files   <- c("ghcnd-countries.txt","ghcnd-inventory.txt","ghcnd-states.txt","ghcnd-stations.txt","ghcnd-version.txt")
  locInfo <- "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/"
  lapply(files, function(y) download.file(paste(locInfo,y,sep=""), paste(x,"Info/",y,sep=""))) # Nested function to download and save the info files
  print("NOAA GHCN-Daily informational text files downloaded to the Info subdirectory.")
}
