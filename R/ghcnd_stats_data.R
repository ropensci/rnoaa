#=====================================================================================================================================================================
# NOAA GHCND
# Function to read CSV files into the workspace and create daily summaries based on region, element, year range, and function(s) to apply
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================

ghcndStatsData <- function(v,w,x,y,z){
  # IMPORTANT: The extended range must be a multiple of the desired range
  # v=Integer multiple of year range (+-) for extended temporal averaging; Set to 0 to disable; 1=(Range*3), 2=(Range*5), 3=(Range*7)
  # w=Statistical function(s) to apply to each daily element value across stations; MEDIAN IS AUTOMATICALLY COMPUTED FOR EXTENDED RANGE
  # x=Main folder path; subdirectories are automatically searched
  # y=Element(s) by which to subset data for processing
  # z=Year range of interest
  
  # Data packages
  library(zoo)             # For working with irregular time-series data
  library(plyr)            # For working with lists of matrices
  library(foreach)         # For parallel processing with plyr, setup_parallel() must be performed
  library(doSNOW)          # For a parallel backend to foreach
  library(data.table)      # For faster aggregation functions
  library(FastImputation)  # For fast imputation; replace with mtsdi to improve imputation performance
  
  # Setup the parallel backend for foreach using doSNOW
  clust <- makeCluster(6,type="SOCK")
  registerDoSNOW(clust)
  
  # Setup list for the "all" condition before subsetting by element
  if(y[1]=="all" | y[1]=="All" | y[1]=="ALL" | y[1]=="a" | y[1]=="ALL"){
    try(y <- elementList)
  }
  v <- as.integer(v)
  totRange     <- c((min(z)-(length(z)*v)):(max(z)+(length(z)*v)))               # Calculate total range based on the year range and multiplier
  
  # Location to output CSV files
  inFolder     <- paste(x,"Data/",sep="")
  outFolder    <- paste(x,"Processed/",sep="")
  dir.create(file.path(outFolder), showWarnings=FALSE)
  
  # Read the folder and extract both file and class names before combining into a new data frame
  CSVfilesFull <- list.files(path=inFolder, pattern="*.csv", recursive=TRUE, full.names=TRUE)                             # Full file paths
  CSVfilesPart <- list.files(path=inFolder, pattern="*.csv", recursive=TRUE, full.names=FALSE)                            # Classes and stations
  CSVstations  <- sapply(strsplit(basename(CSVfilesPart),"\\."), function(xx) paste(xx[1:(length(xx)-1)], collapse="."))  # List of stations
  CSVclasses   <- sapply(strsplit(CSVfilesPart,"/"), function(yy) paste(yy[1:(length(yy)-1)]))                            # List of classes
  
  # Data frame of stations and classes for referencing
  CSVstnClass  <- data.frame(CSVstations,CSVclasses)
  colnames(CSVstnClass) <- c("station","class")
  
  # Create a template of the years, months, and days for the target year range
  template     <- data.frame(Year=rep(z,each=12*31,times=1), Month=rep(c(1:12),each=31,times=length(z)), Day=rep(c(1:31),each=1,times=length(z)*12))
  template     <- template[with(template, order(Year,Month,Day)),]
  row.names(template) <- NULL
  
  # Subset the full data frame into data frames based on class
  foreach(CSVstnClass,.packages=c("foreach","data.table","plyr","FastImputation")) %dopar% by(CSVstnClass,factor(CSVstnClass[,2]), function(a){
    stations   <- as.character(a[,1])
    classes    <- as.character(unique(a[,2]))
    paths      <- unique(dir(paste(inFolder,classes,"/",sep=""),pattern ="\\.csv$",full.names=TRUE))                     # Paths for each class
    
    # Read-in CSV files for a class and keep them within a list container
    raw        <- lapply(paths, function(b) read.csv(b))
    rawDT      <- lapply(raw, data.table)
    bound      <- do.call("rbind",rawDT)                                        # Using do.call(rbind) instead of rbindlist due to a factor bug
    bound[,X:=NULL]                                                             # Fast data.table column removal
    setkey(bound,Year)
    medYears   <- bound[bound$Year %in% z,]                                     # Subset for the target year range
    
    # Fast data.table column re-ordering
    setcolorder(bound,   c("ID","ID1","ID2","ID3","Year","Month","Day","Element","Value","MFlag","QFlag","SFlag"))
    setcolorder(medYears,c("ID","ID1","ID2","ID3","Year","Month","Day","Element","Value","MFlag","QFlag","SFlag"))
    
    # Script to support extended temporal range averaging of daily climate data, without imputation
    if(v > 0){
      totYears <- bound[bound$Year %in% totRange,]
      if(nrow(totYears) > 0){
        sapply(y, function(d){
          sapply(w, function(f){
            setkey(medYears,Year)
            cols <- c(5:7,9)
            suppressWarnings(for(k in 1:length(cols)) bound[,k]    <- as.integer(bound[,k]))
            suppressWarnings(for(k in 1:length(cols)) medYears[,k] <- as.integer(medYears[,k]))
            avgYears  <- list()
            multYears <- list()
            
            # For each multiple, determine the range of years and change the year values to match the target
            foreach(i=(1:v),.packages=c("data.table","foreach")) %dopar% {
              minRange <- c((min(z)-(length(z)*i)):(max(z)-(length(z)*i)))      # e.g., from 1991:2000 to 1981:1990
              maxRange <- c((min(z)+(length(z)*i)):(max(z)+(length(z)*i)))      # e.g., from 1991:2000 to 2001:2010 
              minYears <- bound[bound$Year %in% minRange,]                      # Subset the data for the negative range
              maxYears <- bound[bound$Year %in% maxRange,]                      # Subset the data for the positive range
              setkey(minYears,Year)
              setkey(maxYears,Year)
              
              # For each year, change year column of multiplier tables to match target range for computing averages
              foreach(j=(1:length(z)),.packages=c("data.table","foreach")) %dopar% {
                minYears[Year==minRange[j],Year:=z[j]]
                maxYears[Year==maxRange[j],Year:=z[j]]
                
                # Row bind year range using fast rbindlist
                avgYears[[j]] <- rbind(minYears[minYears$Year==z[j]],maxYears[maxYears$Year==z[j]])
              }
              multYears[[i]]  <- rbind(avgYears)
            }
            # Row bind the parallel extended year range data table for each multiple using fast rbindlist
            unlisted <- lapply(multYears, function(m) do.call("rbind",m))
            allMult  <- do.call("rbind",unlisted)
            
            # Compute the vector stats for the extended year range
            setkey(allMult,Year,Month,Day,Element)
            outYears <- allMult[,get(f)(Value),by="Year,Month,Day,Element"]
            setnames(outYears,"V1","Value")
            
            # Computer the vector stats for the target year range
            setkey(medYears,Year,Month,Day,Element)
            tarYears <- medYears[,get(f)(Value),by="Year,Month,Day,Element"]
            setnames(tarYears,"V1","Value")
            
            # Compute the weighted vector average of the target year range and the extended year range 
            weighted <- data.table(rbind(tarYears,outYears))
            setkey(weighted,Element)
            filterGo <- weighted[J(d)]                                         # Binary search with data.table, faster than vector scanning
            setkey(filterGo,Year,Month,Day)                                    # Key by Year, Month, and Day to apply functions
            outData  <- filterGo[,mean(Value),by="Year,Month,Day"]
            setnames(outData,"V1","Value")
            
            # Match the output to the template
            output   <- merge(template,outData,by=c("Year","Month","Day"),all=TRUE)
            
            # If merging with the template produces NAs, impute the missing values with FastImputation for multivariate normal datasets
            if(any(is.na(output))){
              pattern <- TrainFastImputation(as.data.frame(outData))           # Training data sample to speed the imputation process
              output  <- FastImputation(output,pattern)
            }
            
            # Correct the number of days per month
            output[which(output$Month==2  & output$Day > 28),] <- NA
            output[which(output$Month==4  & output$Day > 30),] <- NA
            output[which(output$Month==6  & output$Day > 30),] <- NA
            output[which(output$Month==9  & output$Day > 30),] <- NA
            output[which(output$Month==11 & output$Day > 30),] <- NA
            output <- output[complete.cases(output),]
            output <- output[with(output,order(Year,Month,Day)),]
            
            # Change the column classes to integer to speed operations
            output <- data.table(output)
            output[,Year  := as.integer(Year)]
            output[,Month := as.integer(Month)]
            output[,Day   := as.integer(Day)]
            output[,Value := as.integer(Value)]
            
            # If the class name is a number, save it to the end of the object and file name
            if(substr(classes,1,1) %in% as.character(c(0:9))){
              #assign(paste(d,"_",f,"_",classes,sep=""), output, envir=.GlobalEnv)
              write.table(output, file=paste(outFolder,d,"_",f,"_",classes,".csv",sep=""),sep=",",na="",row.names=FALSE)
            }
            else{
              #assign(paste(classes,"_",d,"_",f,sep=""), output, envir=.GlobalEnv)
              write.table(output, file=paste(outFolder,classes,"_",d,"_",f,".csv",sep=""),sep=",",na="",row.names=FALSE)
            }
          })
        })
      }
    }
    else{
      # Remove empty data frames and apply each function to each element
      if(nrow(medYears) > 0){
        sapply(y, function(d){
          sapply(w, function(f){
            
            # Training and imputation with FastImputation
            classDF    <- as.data.frame(medYears)
            classRed   <- classDF[,c(5:9)]                                      # We have to remove non-numeric columns for the imputation to function
            #training   <- TrainFastImputation(classRed)                        # Training data sample to speed the imputation process
            #impClass   <- FastImputation(classRed,training)
            #finClass   <- cbind(impClass,classDF[,8])                          # Bind the imputation results back with the descriptive columns
            
            # Using data.table for fast grouping
            classDT    <- data.table(classRed)
            #classDT[,Value:=as.integer(Value)]
            #setnames(classDT,5,"Element")  
            setkey(classDT,Element)
            filterGo   <- classDT[J(d)]                                         # Binary search with data.table, faster than vector scanning
            setkey(filterGo,Year,Month,Day)                                     # Key by Year, Month, and Day to apply functions
            output1    <- filterGo[,get(f)(Value),by="Year,Month,Day"]
            setnames(output1,"V1","Value")                                      # Fast name setting with data.table
            
            # Match element output to the template to impute NA values
            output     <- merge(template,output1,by=c("Year","Month","Day"),all=TRUE)
            
            # If merging with the template produces NAs, impute their value
            if(any(is.na(output))){
              pattern  <- TrainFastImputation(as.data.frame(output1))
              output   <- FastImputation(output,pattern)
            }
            
            # Correct the number of days per month
            output[which(output$Month==2  & output$Day > 28),] <- NA
            output[which(output$Month==4  & output$Day > 30),] <- NA
            output[which(output$Month==6  & output$Day > 30),] <- NA
            output[which(output$Month==9  & output$Day > 30),] <- NA
            output[which(output$Month==11 & output$Day > 30),] <- NA
            output <- output[complete.cases(output),]
            output <- output[with(output,order(Year,Month,Day)),]
            
            # Change the column classes to integer to speed operations
            output <- data.table(output)
            output[,Year :=as.integer(Year)]
            output[,Month:=as.integer(Month)]
            output[,Day  :=as.integer(Day)]
            output[,Value:=as.integer(Value)]
            
            # If the class name is a number, save it to the end of the object and file name
            if(substr(classes,1,1) %in% as.character(c(0:9))){
              #assign(paste(d,"_",f,"_",classes,sep=""), output, envir=.GlobalEnv)
              write.table(output, file=paste(outFolder,d,"_",f,"_",classes,".csv",sep=""),sep=",",na="",row.names=FALSE)
            }
            else{
              #assign(paste(classes,"_",d,"_",f,sep=""), output, envir=.GlobalEnv)
              write.table(output, file=paste(outFolder,classes,"_",d,"_",f,".csv",sep=""),sep=",",na="",row.names=FALSE)
            }
          })
        })
      }
    }
  })
  print("Successfully computed statistics for NOAA GHCN-Daily weather station data")
  print(paste("Daily values averaged from the year range ",min(totRange),":",max(totRange),sep=""))
  stopCluster(clust)
}
