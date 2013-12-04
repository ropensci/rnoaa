#=====================================================================================================================================================================
# NOAA GHCND
# Function to filter by FIPS country code or state postal code
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndFilterInfo <- function(x,y){
  # x=Main folder path
  # y[1]=Concatenation of filter type (e.g., "country" or "state") and...
  # y[2]=Two letter filter code (e.g., "CA" for Canada or "AB" for Alberta); I HIGHLY advise against using state codes
  
  x <- paste(x,"Info/",sep="")
  if(y[1]=="country" | y[1]=="Country" | y[1]=="COUNTRY" | y[1]=="c" | y[1]=="C"){
    w <- ghcndMaster[ghcndMaster$Country==y[2],]
    row.names(w) <- NULL
    assign("ghcndCountry", w, envir=.GlobalEnv)
    write.csv(w, paste(x,"ghcndCountry.csv",sep=""), row.names=TRUE)
    print(paste("ghcndMaster data frame filtered by country ",y[2]," to produce ghcndCountry data frame",sep=""))
  }
  else if(y[1]=="state" | y[1]=="State" | y[1]=="STATE" | y[1]=="s" | y[1]=="S"){
    w <- ghcndMaster[ghcndMaster$State==y[2],]
    row.names(w) <- NULL
    assign("ghcndState", w, envir=.GlobalEnv)
    write.csv(w, paste(x,"ghcndState.csv",sep=""), row.names=TRUE)
    print(paste("ghcndMaster data frame filtered by state ",y[2],", to produce ghcndState data frame",sep=""))
  }
  else{
    print("Operation failed")
  }
}
