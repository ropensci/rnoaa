#=====================================================================================================================================================================
# NOAA GHCND
# Optional function to intersect and map the ghcnd info, based on a user-provided polygon shapefile, required to be placed in the "Spatial" subdirectory
# Adam Erickson, IRSS Lab, UBC
# July 29, 2013
#=====================================================================================================================================================================
# Function to map the GHCND data; the first column in the attribute table of your shapefile should contain class information, used by complete.cases to filter data
# Requires rgdal, sp, and maptools

ghcndMapInfo <- function(w,x,y,z){
  # w=Folder containing shapefiles
  # x=Main class shapefile
  # y=Background shapefile for cartography
  # z=ghcnd data frame to use
  
  # Spatial packages
  library(sp)              # For working with spatial data
  library(maptools)        # For working with ESRI shapefiles
  library(rgdal)           # For basic mapping functions
  library(RColorBrewer)    # For generating colours
  library(scales)          # For transparencies
  
  w <- paste(w,"Spatial/",sep="")
  
  # Import an ESRI polygon shapefile with rgdal to store the map projection and/or use to clip the weather station data
  importProj <- OGRSpatialRef(dsn=substr(w, 1, nchar(w)-1), layer=x)
  
  # Read in shapefiles with the new projection information using maptools
  mainShape  <- suppressWarnings(readShapePoly(paste(w,x,sep=""),     verbose=TRUE, proj4string=CRS(importProj), delete_null_obj=TRUE))
  backShape  <- try(suppressWarnings(readShapePoly(paste(w,y,sep=""), verbose=TRUE, proj4string=CRS(importProj), delete_null_obj=TRUE)), silent=TRUE)
  
  # Create x and y limits from the shapefile bounding box to use as the mapping extent
  xlim <- mainShape@bbox[1, ]
  ylim <- mainShape@bbox[2, ] 
  
  # Remove any empty latlong rows in the data frame
  z <- z[complete.cases(z[,8:9]),]
  
  # Convert latitude and longitude values to projected coordinates using sp package methods
  ghcndPoint              <- SpatialPointsDataFrame(coords=cbind(z[,9],z[,8]), data=z)
  proj4string(ghcndPoint) <- CRS("+proj=longlat +datum=WGS84")
  ghcndReproj             <- spTransform(ghcndPoint,CRS(importProj)) # This line is throwing errors... The sp package has memory issues, use rgdal!
  
  # Save the reprojected point shapefile to disk using rgdal
  dir.create(file.path(paste(w,"Output/",sep="")), showWarnings = FALSE)
  saveLoc1 <- paste(w,"Output/ghcndPoint.shp",sep="")     
  writeOGR(ghcndReproj, dsn=saveLoc1, layer="ghcndPoint", driver="ESRI Shapefile")
  
  # Intersect points falling within each class of mainShape, returns a SpatialPointsDataFrame with appended table of polygon attributes  
  # Set up overlay with new column of join IDs in x and then bind captured data to points dataframe, derived from a bivariate function
  #------------------------------------------------------------------------------------------------------------------------------------
  overlayRes   <- suppressWarnings(overlay(mainShape,ghcndReproj)) # Overlay using sp package
  ghcndReproj2 <- cbind(ghcndReproj,overlayRes)
  ghcndReproj3 <- ghcndReproj2[complete.cases(ghcndReproj2[,18]),]
  row.names(ghcndReproj3) <- NULL
  assign("ghcndClass", ghcndReproj3, envir=.GlobalEnv)
  
  # Convert points data frame back into a SpatialPointsDataFrame, accounting for different coordinate variable names
  if(("coords.x1" %in% colnames(ghcndReproj3)) & ("coords.x2" %in% colnames(ghcndReproj3))){
    coordinates(ghcndReproj3) <- ~coords.x1 + coords.x2
  }
  else if(("ghcndReproj" %in% colnames(ghcndReproj3)) & ("ghcndReproj" %in% colnames(ghcndReproj3))){
    coordinates(ghcndReproj3) <- ~ghcndReproj + mainShape
  }
  
  # Reassign the projection
  if(is.na(CRSargs(ghcndReproj@proj4string)) == "FALSE"){
    ghcndReproj3@proj4string <- ghcndReproj@proj4string
  }
  saveLoc <- paste(w,"Output/ghcndOverlay.shp",sep="")     
  writeOGR(ghcndReproj3, dsn=saveLoc, layer="ghcndClass", driver="ESRI Shapefile")
  assign("ghcndClassPoints", ghcndReproj3, envir=.GlobalEnv)
  
  # Plot the shapefiles, starting with the background layers if there are any
  #--------------------------------------------------------------------------
  try(plot(backShape, xlim=xlim, ylim=ylim, col="gray90", axes=TRUE), silent=TRUE)
  suppressWarnings(plot(mainShape, col=alpha(colorRampPalette(brewer.pal(15,"Set2"))(length(mainShape)),0.6), border="gray50", bty="n", add=TRUE))
  points(ghcndReproj,      pch=20, col=alpha('red',  0.05), cex=1)
  points(ghcndClassPoints, pch=20, col=alpha('black',0.2),  cex=1)
  title(main="NOAA GHCN-Daily Weather Station Location and Class Shapefile", xlab="longitude (UTM)", ylab="latitude (UTM)")
  
  print("Operation complete")
}
