#=====================================================================================================================================================================
# NOAA GHCND
# Function to format the downloaded DLY weather station data, which may take some time
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndFormatData <- function(x,y){
  # x=Main folder path; subdirectories are automatically searched, but use the directory from previous
  # y=Element list used to filter the individual station data; user can specify "all" as before
  
  x <- paste(x,"Data/",sep="")
  
  # Read the folder and extract both file and class names before combining into a new data frame
  DLYfilesFull <- list.files(path=x, pattern="*.dly", recursive=TRUE, full.names=TRUE)
  DLYfilesPart <- list.files(path=x, pattern="*.dly", recursive=TRUE, full.names=FALSE)
  DLYstnList   <- sapply(strsplit(basename(DLYfilesFull),"\\."), function(xx) paste(xx[1:(length(xx)-1)], collapse="."))
  DLYclasses   <- sapply(strsplit(DLYfilesPart,"/"), function(yy) paste(yy[1:(length(yy)-1)]))
  DLYstnClass  <- data.frame(DLYstnList,DLYclasses)
  
  # Load the info text files and save them locally as data frames
  apply(DLYstnClass, 1, function(z){
    DLYdata <- readLines(paste(x,z[2],"/",z[1],".dly",sep=""))
    
    ID      <- as.character(substr(DLYdata, 1,11))
    ID1     <- as.character(substr(DLYdata, 1, 2))
    ID2     <- as.character(substr(DLYdata, 3, 3))
    ID3     <- as.character(substr(DLYdata, 4,12))
    Year    <- as.integer(substr(DLYdata,12,15))
    Month   <- as.integer(substr(DLYdata,16,17))
    Element <- as.character(substr(DLYdata,18,21))
    
    values  <- c(1:31)
    for(i in 1:length(values)){
      assign(paste("Value",values[i],sep=""), as.integer(substr(DLYdata,   (14+(8*values[i])), (18+(8*values[i])))))
      assign(paste("MFlag",values[i],sep=""), as.character(substr(DLYdata, (19+(8*values[i])), (19+(8*values[i])))))
      assign(paste("QFlag",values[i],sep=""), as.character(substr(DLYdata, (20+(8*values[i])), (20+(8*values[i])))))
      assign(paste("SFlag",values[i],sep=""), as.character(substr(DLYdata, (21+(8*values[i])), (21+(8*values[i])))))
    }
    # Create the formatted data frames and save to CSV
    DLYcols <- cbind(ID,ID1,ID2,ID3,Year,Month,Element,Value1, MFlag1, QFlag1, SFlag1, Value2, MFlag2, QFlag2, SFlag2,
                     Value3, MFlag3, QFlag3, SFlag3, Value4, MFlag4, QFlag4, SFlag4, Value5, MFlag5, QFlag5, SFlag5,
                     Value6, MFlag6, QFlag6, SFlag6, Value7, MFlag7, QFlag7, SFlag7, Value8, MFlag8, QFlag8, SFlag8,
                     Value9, MFlag9, QFlag9, SFlag9, Value10,MFlag10,QFlag10,SFlag10,Value11,MFlag11,QFlag11,SFlag11,
                     Value12,MFlag12,QFlag12,SFlag12,Value13,MFlag13,QFlag13,SFlag13,Value14,MFlag14,QFlag14,SFlag14,
                     Value15,MFlag15,QFlag15,SFlag15,Value16,MFlag16,QFlag16,SFlag16,Value17,MFlag17,QFlag17,SFlag17,
                     Value18,MFlag18,QFlag18,SFlag18,Value19,MFlag19,QFlag19,SFlag19,Value20,MFlag20,QFlag20,SFlag20,
                     Value21,MFlag21,QFlag21,SFlag21,Value22,MFlag22,QFlag22,SFlag22,Value23,MFlag23,QFlag23,SFlag23,
                     Value24,MFlag24,QFlag24,SFlag24,Value25,MFlag25,QFlag25,SFlag25,Value26,MFlag26,QFlag26,SFlag26,
                     Value27,MFlag27,QFlag27,SFlag27,Value28,MFlag28,QFlag28,SFlag28,Value29,MFlag29,QFlag29,SFlag29,
                     Value30,MFlag30,QFlag30,SFlag30,Value31,MFlag31,QFlag31,SFlag31)
    
    # Create the data frames for each station
    DLYdf1   <- data.frame(DLYcols)
    
    # Setup list for the "all" condition before subsetting by element
    if(y[1]=="all" | y[1]=="All" | y[1]=="ALL" | y[1]=="a" | y[1]=="ALL"){
      y <- c(as.character(unique(DLYdf1$Element)))
    }
    DLYdf2   <- DLYdf1[DLYdf1$Element %in% y,]
    assign("dfDLY",DLYdf2,envir=.GlobalEnv)
    
    # Reshape the data frames with the base reshape function; we will use data.table function in the future to improve speed
    rshpDLY1 <- reshape(dfDLY,varying=colnames(dfDLY)[8:131],v.names="Value",timevar="Variable",times=colnames(dfDLY)[8:131],direction="long")
    
    # Split the Variable column into two columns, variable and day, and bind the new columns
    Variable <- as.character(substr(rshpDLY1$Variable,1,5))
    Day      <- as.integer(substr(rshpDLY1$Variable,6,7))
    rshpDLY2 <- as.data.frame(cbind(rshpDLY1[,c(1:6)],Day,Element=rshpDLY1[,7],Variable,Value=rshpDLY1[,9]))
    
    # Set blank and -9999 values to NA
    rshpDLY2$Value[which(rshpDLY2$Value==-9999 | rshpDLY2$Value==" ")] <- NA
    
    # Reshape the Variable column from narrow to wide, also known as casting, and hide row.names
    rshpDLY3 <- reshape(rshpDLY2, timevar="Variable",idvar=c("ID","ID1","ID2","ID3","Year","Month","Day","Element"),direction="wide")
    row.names(rshpDLY3) <- NULL
    colnames(rshpDLY3)[9:12] <- c("Value","MFlag","QFlag","SFlag")
    
    # Save each of the formatted weather station files to CSV in their respective folders
    write.csv(rshpDLY3,file=paste(x,z[2],"/",z[1],".csv",sep=""),row.names=TRUE)
  })
  print("NOAA GHCN-Daily DLY weather station file formatting and saving to CSV complete")
}
