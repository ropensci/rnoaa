ghcndGetInfo("~/")
ghcndFormatInfo("~/")
# ghcndFilterInfo (optional)
# ghcndMapInfo (optional)
ghcndGetData(v="ghcndMaster.csv",w="~/",x="Country",y="all",z="all")
  # v=Data frame to use 
  # w=Destination folder used with formatInfo (e.g., x0)
  # x=Column name (in quotes) or number (integer) for the class variable (e.g., you can specify "Country", "State", "Name", etc.)
  # y=List of classes to filter the DLY stations, based on the first column of the main shapefile; users may specify "all" classes.
  # z=List of desired weather station elements or metrics; users may specify "all" elements
  
ghcndFormatData
ghcndRunStats