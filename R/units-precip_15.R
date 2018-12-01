# from https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_15_documentation.pdf
ncdc_units_precip_15 <- list(
  QGAG = list(
    name = "QGAG", 
    units = "mm_tenths", 
    description = "The volume of precipitation (calculated by weight) accumulated in measuring bucket as recorded at the station for the 15 minute period ending at the time specified for DATE above given in hundredths of inches or tenths of millimeters depending on user's specification of standard or metric units."
  ),
  QPCP = list(
    name = "QPCP", 
    units = "mm_tenths", 
    description = "The amount of precipitation recorded at the station for the 15 minute period ending at the time specified for DATE above given in hundredths of inches or tenths of millimeters depending on user's specification of standard or metric units."
  )
)
