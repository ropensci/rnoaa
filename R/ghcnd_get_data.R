#=====================================================================================================================================================================
# NOAA GHCND
# Function to filter and dowload DLY weather station data
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndGetData <- function(v,w,x,y,z){
  # v=Data frame to use 
  # w=Destination folder used with formatInfo (e.g., x0)
  # x=Column name (in quotes) or number (integer) for the class variable (e.g., you can specify "Country", "State", "Name", etc.)
  # y=List of classes to filter the DLY stations, based on the first column of the main shapefile; users may specify "all" classes.
  # z=List of desired weather station elements or metrics; users may specify "all" elements
  
  locDLY   <- "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/all/"
  dstDLY   <- paste(w,"Data/",sep="")
  dir.create(file.path(paste(w,"Data/",sep="")), showWarnings = FALSE) # Create the directory if it does not exist
  
  classCol <- v[,x]
  elemtCol <- v[,5]
  
  # Setup list for the "all" condition
  if(y[1]=="all" | y[1]=="All" | y[1]=="ALL" | y[1]=="a" | y[1]=="A"){
    y <- c(as.character(unique(classCol)))
  }
  
  # Setup list for the "all" condition
  if(z[1]=="all" | z[1]=="All" | z[1]=="ALL" | z[1]=="a" | z[1]=="ALL"){
    z <- c(as.character(unique(elemtCol)))
  }
  
  # Create a list of available elements for later reference
  assign("elementList",c(as.character(unique(elemtCol))),envir=.GlobalEnv)
  
  # Create a new data frame containing the specified two-column values
  stnListDF <- v[classCol %in% y & elemtCol %in% z,]               # Code to produce a data frame meeting the y and z criteria; we use only a vector of ID
  assign("stationDF", stnListDF, envir=.GlobalEnv)
  row.names(stationDF)    <- NULL
  write.csv(stnListDF, paste(w,"stationsFull.csv",sep=""), row.names=TRUE)
  
  stnListCt <- data.frame(stnListDF[,1],stnListDF[,x])             # Cut down to only the ID and class columns
  stnListUn <- unique(stnListCt)                                   # Pull the unique ID values for each class to download each file only once
  colnames(stnListUn)     <- c("ID","Class")
  assign("stationClass", stnListUn, envir=.GlobalEnv)
  row.names(stationClass) <- NULL
  write.csv(stnListUn, paste(w,"stationsClass.csv",sep=""), row.names=TRUE)
  
  # Create the destination path based on class and remove any spaces in the class names
  y2     <- gsub(" ","_",y)
  dstPth <- paste(dstDLY,y2,"/",sep="")
  sapply(dstPth, function(u) dir.create(path=u))
  
  # Download the DLY weather station files into subdirectories named using the class variable, one row at a time using apply
  stnListUn[,3] <- NA
  stnListUn[,3] <- apply(stnListUn, 1, function(a) gsub(" ","_",a[2])) # Apply a function to remove spaces in class names
  apply(stnListUn, 1, function(q) download.file(paste(locDLY,q[1],".dly",sep=""), paste(dstDLY,q[3],"/",q[1],".dly",sep="")))
  print("NOAA GHCN-Daily DLY weather station files downloaded to the specified directory")
}
