# from https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_HLY_documentation.pdf
ncdc_units_precip_hly <- list(
  HPCP = list(
    name = "HPCP", 
    units = "mm_tenths", 
    description = "The amount of precipitation recorded at the station for the hour ending at the time specified for DATE above given in hundredths of inches or tenths of millimeters depending on user's specification of standard or metric units. The values 99999 means the data value is missing.  Hours with no precipitation are not shown."
  )
)
