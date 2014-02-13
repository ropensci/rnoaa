
#=====================================================================================================================================================================
# Function to download and locally save the info files
#=====================================================================================================================================================================
# Example parameters
x0 <- "C:/Data/Climate/NOAA_GHCN/"

ghcnd_get_info <- function(x){ # x=Main folder path

#=====================================================================================================================================================================
# Function to format the weather station info text files
#=====================================================================================================================================================================
ghcnd_format_info <- function(x){ # x=Main folder path

#=====================================================================================================================================================================
# Function to filter by FIPS country code or state postal code
#=====================================================================================================================================================================
# Example parameters
x0 <- x0
y0 <- c("country","CA")

ghcnd_filter_info <- function(x,y){ # x=Main folder path
                                    # y[1]=Concatenation of filter type (e.g., "country" or "state") and...
                                    # y[2]=Two letter filter code (e.g., "CA" for Canada or "AB" for Alberta); I HIGHLY advise against using state codes

#=====================================================================================================================================================================
# Optional function to intersect and map the ghcnd info, based on a user-provided polygon shapefile, required to be placed in the "Spatial" subdirectory
#=====================================================================================================================================================================
# Example parameters
w1  <- "C:/Data/Climate/NOAA_GHCN/"
x1  <- "nsr2005_p7_final"
y1  <- "prov0_Proj"
z1  <- ghcndCountry

# Function to map the GHCND data; the first column in the attribute table of your shapefile should contain class information, used by complete.cases to filter data
# Requires rgdal, sp, and maptools
ghcnd_map_info <- function(w,x,y,z){ # w=Folder containing shapefiles
                                     # x=Main class shapefile
                                     # y=Background shapefile for cartography
                                     # z=ghcnd data frame to use (e.g., regional subsetting)

#=====================================================================================================================================================================
# Function to filter and dowload DLY weather station data
#=====================================================================================================================================================================
# Example parameters
v2  <- ghcndClass              # Data frame to use for subsetting
w2  <- "C:/Data/Climate/NOAA_GHCN/"
x2a <- "NSRNAME"               # Can use anything on the DLY files
y2  <- "All"                   # All classes
z2a <- c("TMAX","TMIN","PRCP") # "All" can also be specified

ghcnd_get_data <- function(v,w,x,y,z){ # v=Data frame to use 
                                       # w=Destination folder used with formatInfo (e.g., x0)
                                       # x=Column name (in quotes) or number (integer) for the class variable (e.g., you can specify "Country", "State", "Name", etc.)
                                       # y=List of classes to filter the DLY stations, based on the first column of the main shapefile; users may specify "all" classes.
                                       # z=List of desired weather station elements or metrics; users may specify "all" elements

#=====================================================================================================================================================================
# Function to format the downloaded DLY weather station data, which may take some time
#=====================================================================================================================================================================
# Example parameters
x3 <- "C:/Data/Climate/NOAA_GHCN/"
y3 <- c("TMAX","TMIN","PRCP")

ghcnd_format_data <- function(x,y){ # x=Main folder path; subdirectories are automatically searched, but use the directory from previous
                                    # y=Element list used to filter the individual station data; user can specify "all" as before

#=====================================================================================================================================================================
# Function to read CSV files into the workspace and create daily summaries based on region, element, year range, and function(s) to apply
#=====================================================================================================================================================================
# Example parameters
v <- 0
w <- c("mean")
x <- "C:/Data/Climate/NOAA_GHCN/"
y <- c("TMAX","TMIN","PRCP")
z <- c(2003:2012)

ghcnd_get_stats <- function(v,w,x,y,z){ # v=Integer multiple of year range (+-) for extended temporal averaging; Set to 0 to disable; 1=(Range*3), 2=(Range*5), 3=(Range*7)
                                        # IMPORTANT: The extended range must be a multiple of the desired range
                                        # w=Statistical function(s) to apply to each daily element value across stations; MEDIAN IS AUTOMATICALLY COMPUTED FOR EXTENDED RANGE
                                        # x=Main folder path; subdirectories are automatically searched
                                        # y=Element(s) by which to subset data for processing
                                        # z=Year range of interest

