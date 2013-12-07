#=====================================================================================================================================================================
# NOAA GHCND
# Function to format the weather station info text files
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndFormatInfo <- function(x){
  # x=Main folder path
  
  xi <- paste(x,"Info/",sep="")
  print("Loading NOAA GHCN-Daily weather station info...")
  fileNames <- c("countries","inventory","states","stations","version")
  
  # Load the info text files and save them locally as data frames
  sapply(fileNames, function(y){
    data    <- readLines(paste(xi,"ghcnd-",y,".txt",sep=""))
    print(paste(y,"file rows:",length(data)),sep="")
    assign(y,data) # Creates locally defined variables within the function for the if-else statements 
    
    # Re-format each of the lists from unicolumnar to multi-columnar using string split, bind by column, and load as global data frames
    if(y=="countries"){
      Code      <- substr(countries,1, 2)
      Name      <- substr(countries,4,50)
      bound     <- data.frame(cbind(Code,Name))
      name      <- paste("ghcnd_",y,sep="")
      assign(name,bound,envir=.GlobalEnv)
      write.csv(bound,paste(xi,name,".csv",sep=""),row.names=TRUE)
    }
    else if(y=="inventory"){
      ID        <- substr(inventory, 1,11)
      Lat       <- substr(inventory,13,20)
      Long      <- substr(inventory,22,30)
      Element   <- substr(inventory,32,35)
      FirstYear <- substr(inventory,37,40)
      LastYear  <- substr(inventory,42,45)
      bound     <- data.frame(cbind(ID,Lat,Long,Element,FirstYear,LastYear))
      name      <- paste("ghcnd_",y,sep="")
      assign(name,bound,envir=.GlobalEnv)
      write.csv(bound,paste(xi,name,".csv",sep=""),row.names=TRUE)
    }
    else if(y=="states"){
      Code      <- substr(states,1,2)
      Name      <- substr(states,4,50)
      bound     <- data.frame(cbind(Code,Name))
      name      <- paste("ghcnd_",y,sep="")
      assign(name,bound,envir=.GlobalEnv)
      write.csv(bound,paste(xi,name,".csv",sep=""),row.names=TRUE)
    }
    else if(y=="stations"){
      ID        <- substr(stations, 1,11)
      Lat       <- substr(stations,13,20)
      Long      <- substr(stations,22,30)
      Elevation <- substr(stations,32,37)
      State     <- substr(stations,39,40)
      Name      <- substr(stations,42,71)
      GSNflag   <- substr(stations,73,75)
      HCNflag   <- substr(stations,77,79)
      WMOID     <- substr(stations,81,85)
      bound     <- data.frame(cbind(ID,Lat,Long,Elevation,State,Name,GSNflag,HCNflag,WMOID))
      name      <- paste("ghcnd_",y,sep="")
      assign(name,bound,envir=.GlobalEnv)
      write.csv(bound,paste(xi,name,".csv",sep=""),row.names=TRUE)
    }
    else if(y=="version"){
      VersInfo  <- substr(version, 1,155)
      bound     <- data.frame(VersInfo)
      name      <- paste("ghcnd_",y,sep="")
      assign(name,bound,envir=.GlobalEnv,)
      write.csv(bound,paste(xi,name,".csv",sep=""),row.names=FALSE)
    }
    else{
      print("NOAA GHCN-Daily reference data frame processes complete")
    }
  })
  # Merge date from the 'ghcnd_stations' file into the 'ghcnd_inventory' file
  ghcnd_merged <- merge(ghcnd_inventory, ghcnd_stations, by="ID", all.x=TRUE)
  
  # Create a master key data frame from the newly created data frames, starting by splitting the ID column into its three components
  ID1 <- substr(ghcnd_merged$ID,1, 2)
  ID2 <- substr(ghcnd_merged$ID,3, 3)
  ID3 <- substr(ghcnd_merged$ID,4,12)
  
  # Bind the columns together into a new data frame
  ghcnd_merged_cut               <- cbind(ghcnd_merged[,1],ID1,ID2,ID3,ghcnd_merged[,4:14])
  colnames(ghcnd_merged_cut)     <- c("ID","Country","Network","Station","Element","FirstYear","LastYear","Lat","Long","Elevation","State","Name","GSN_Flag","HCN_Flag","WMO_ID")
  
  ghcnd_merged_cut[,'FirstYear'] <- as.integer(as.character(ghcnd_merged_cut[,'FirstYear']))
  ghcnd_merged_cut[,'LastYear']  <- as.integer(as.character(ghcnd_merged_cut[,'LastYear']))
  ghcnd_merged_cut[,'Lat']       <- as.double(as.character(ghcnd_merged_cut[, 'Lat']))
  ghcnd_merged_cut[,'Long']      <- as.double(as.character(ghcnd_merged_cut[, 'Long']))
  ghcnd_merged_cut[,'Elevation'] <- as.double(as.character(ghcnd_merged_cut[, 'Elevation']))
  
  assign("ghcndMaster", ghcnd_merged_cut, envir=.GlobalEnv)
  write.csv(ghcnd_merged_cut, paste(xi,"ghcndMaster.csv",sep=""), row.names=TRUE)
  print("NOAA GHCN-Daily station info loaded. The 'ghcndMaster' reference data frame was successfully created")
}
