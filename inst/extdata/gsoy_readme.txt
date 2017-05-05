GLOBAL SUMMARY OF THE YEAR (GSOY) DATA FILES
(Last Updated:  3/27/2017)

1.  INTRODUCTION

    1.1  OVERVIEW

         The Global Summary Of The Year (GSOY) Data Files contain quality controlled annual
         summaries of more than 50 elements (max temp, snow, etc.) computed from stations in
         the Global Historical Climatology Network (GHCN)-Daily dataset.  These include non-US
         stations, providing a global product from 1763 to present that is updated weekly.
         This is not to be confused with GHCN-Monthly, which only contains temperature and
         precipitation elements and which include bias corrected data (which are not available
         in the first release of GSOM/GSOY).  Annual averages in the GSOY Data Files are computed
         from equally weighted months; (e.g, no weighting of months by number of days).  This is 
         to remain consistent with the National Data Stewardship Committee’s recommendation
         established in 2015.  Annual values are set to missing if one or more data-months during a
         data-year are missing.  A description of the files are included below in Section 1.3.

    1.2  ACCESS

         The GSOY Data Files can be accessed at the following location:

         https://www.ncei.noaa.gov/data/gsom/

    1.3  DOWNLOADING

         There are three sets of individual files that are included as part of the HPD Digital Inventory Reports:

         a.  XXY########.csv (GSOY Station Data File Name)

             XXY######## is the GHCN ID for the station in question, where:

             XX = FIPS Country Code Two-Letter Identifier
             Y = Station Network Code (Identifies The Station Numbering System Used)

                 Valid Station Network Codes:

                     0 = unspecified (station identified by up to eight 
	                 alphanumeric characters)
	             1 = Community Collaborative Rain, Hail,and Snow (CoCoRaHS)
	                 based identification number.  To ensure consistency with
	                 with GHCN Daily and GSOY, all numbers in the original CoCoRaHS
                         ID have been left-filled to make them all four digits long. 
	                 In addition, the characters "-" and "_" have been removed 
	                 to ensure that the IDs do not exceed 11 characters when 
	                 preceded by "US1". For example, the CoCoRaHS ID 
	                 "AZ-MR-156" becomes "US1AZMR0156" in GSOY
                     C = U.S. Cooperative Network identification number (last six 
                         characters of the GHCN ID)
	             E = Identification number used in the ECA&D non-blended
	                 dataset
	             M = World Meteorological Organization ID (last five
	                 characters of the GHCN ID)
	             N = Identification number used in data supplied by a 
	                 National Meteorological or Hydrological Center
	             R = U.S. Interagency Remote Automatic Weather Station (RAWS)
	                 identifier
	             S = U.S. Natural Resources Conservation Service SNOwpack
	                 TELemtry (SNOTEL) station identifier
                     W = WBAN identification number (last five characters of the 
                         GHCN ID)

             ######### = Actual Station ID (Format Is Dependent on the Station Network Code)
             .csv = Comma-Delimited File Format Extension (can be opened in Excel, OpenOffice, etc.)

             For a complete list of stations and their Metadata, please see https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt .

             The following is the format of the data records that are contained within the GSOY Files (line spacing shown below between 
             element groups/attributes does NOT imply spacing within the GSOY Data Files):

                  "STATION" = GHCN ID (see above for further explanation)
                  "DATE" = YYYY-MM where YYYY is 4-digit year and MM is 2-digit month
                  "AWND" = Annual Average Wind Speed. Given in miles per hour or meters per second depending
                           on user specification.
                  "AWND_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "CDSD" = Cooling Degree Days (season-to-date). Running total of monthly cooling degree days through the
                           end of the season. Each month is summed to produce a season-to-date total. Season starts in January
                           in Northern Hemisphere and July in Southern Hemisphere. Given in Celsius or Fahrenheit degrees depending on user
                           specification.
                  "CDSD_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                         
                  "CLDD" = Cooling Degree Days. Computed when daily average temperature is more than 65 degrees Fahrenheit/18.3 degrees 
                  Celsius. (CDD = mean daily temperature - 65 degrees Fahrenheit/18.3 degrees Celsius). Each month is summed to produce an 
                  annual total. Annual totals are computed based on a January – December year in Northern Hemisphere and July – June
                  year in Southern Hemisphere). Given in Celsius or Fahrenheit degrees depending on user specification.
                  "CLDD_ATTRIBUTES" = a,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "DP01" = Number of days with >= 0.01 inch/0.254 millimeter in the year.  Values originally recorded in inches as 0.01
                           are stored as 3 tenths of a millimeter.  Technically, this test is for values greater than or equal to 3 tenths of
                           a millimeter.
                  "DP01_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)     
                                                               
                  "DP10" = Number of days with >= 0.1 inch/2.54 millimeter in the year.  Values originally recorded in inches as 0.10 are
                           stored as 25 tenths of a millimeter.  Technically, this test is for values greater than or equal to 25 tenths of
                           a millimeter.
                  "DP0X_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)      
                                                              
                  "DP1X" = Number of days with >= 1.00 inch/25.4 millimeters in the year.
                  "DP1X_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                                                    
                  "DSND" = Number of days with snow depth >= 1 inch/25 millimeters.
                  "DSND_ATTRIBUTES" = is blank
                                                                  
                  "DSNW" = Number of days with snowfall >= 1 inch/25 millimeters
                  "DSNW_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DT00" = Number of days with maximum temperature <= 0 degrees Fahrenheit/-17.8 degrees Celsius.
                  "DT00_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DT32" = Number of days with minimum temperature <= 32 degrees Fahrenheit/0 degrees Celsius.
                  "DT32_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)   
                                                                 
                  "DX32" = Number of days with maximum temperature <= 32 degrees Fahrenheit/0 degrees Celsius.
                  "DX32_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DX70" = Number of days with maximum temperature >= 70 degrees Fahrenheit/21.1 degrees Celsius.
                  "DX70_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  
                                                                  
                  "DX90" = Number of days with maximum temperature >= 90 degrees Fahrenheit/32.2 degrees Celsius
                  "DX90_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "EMNT" =  Extreme minimum temperature for the year. Lowest daily minimum temperature for the
                            year. Given in Celsius or Fahrenheit depending on user specification.
                  "EMNT_ATTRIBUTES" = S,cccc,d where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date during the year when the EMNT value occurred; if it occurs more than once,
                                                it's the last date during the year for which it occurred
                                                (originates from the DYNT element within the Raw GSOY Files)
                                           d = + if there's more than one date during the year when EMNT value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYNT element within the Raw GSOY Files)

                  "EMSD" = Highest daily snow depth in the year. Given in inches or millimeters depending on user
                           specification.
                  "EMSD_ATTRIBUTES" = M,S,cccc,d where:                                                                                               
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit/month two-digit date when the EMSD value occurred; if it occurs more than once,
                                                it's the last date during the year for which it occurred
                                               (originates from the DYSD element within the Raw GSOY Files)
                                           d = + if there's more than one date during the year when EMSD value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYSD element within the Raw GSOY Files)

                  "EMSN" = Highest daily snowfall in the year. Given in inches or millimeters depending on user
                           specification.
                  "EMSN_ATTRIBUTES" =  M,S,cccc,d where:                                                                                               
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit/month two-digit date when the EMSN value occurred; if it occurs more than once,
                                                it's the last date during the year for which it occurred
                                                (originates from the DYSN element within the Raw GSOY Files)
                                           d = + if there's more than one date during the year when EMSN value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYSN element within the Raw GSOY Files)

                  "EMXP" = Highest daily total of precipitation in the year. Given in inches or millimeters depending
                           on user specification.
                  "EMXP_ATTRIBUTES" =  S,cccc,d where:                                                                                               
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the EMXP value occurred; if it occurs more than once,
                                                it's the last date during the year for which it occurred
                                                (originates from the DYXP element within the Raw GSOY Files)
                                           d = + if there's more than one date during the year when EMXP value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYXP element within the Raw GSOY Files)

                  "EMXT" = Extreme maximum temperature for the year. Highest daily maximum temperature for the
                           year. Given in Celsius or Fahrenheit depending on user specification.
                  "EMXT_ATTRIBUTES" =  S,cccc,d where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the EMXT value occurred; if it occurs more than once,
                                                it's the last date during the year for which it occurred
                                                (originates from the DYXT element within the Raw GSOY Files)
                                           d = + if there's more than one date during the year when EMXT value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYXT element within the Raw GSOY Files)

                  "EVAP" = Total Annual Evaporation. Given in inches or millimeters depending on user specification.
                  "EVAP_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                             
                  "FZF0" = Temperature Value of First Freeze (at or less than 32 Degrees Fahrenheit/0 Degrees Celsius 
                           during August-December
                  "FZF0_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF0 value occurred

                  "FZF1" = Temperature Value of First Freeze (at or less than 28 Degrees Fahrenheit/-2.2 Degrees Celsius 
                           during August-December
                  "FZF1_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF1 value occurred

                  "FZF2" = Temperature Value of First Freeze (at or less than 24 Degrees Fahrenheit/-4.4 Degrees Celsius 
                           during August-December
                  "FZF2_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF2 value occurred

                  "FZF3" = Temperature Value of First Freeze (at or less than 20 Degrees Fahrenheit/-6.7 Degrees Celsius 
                           during August-December
                  "FZF3_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF3 value occurred

                  "FZF4" = Temperature Value of First Freeze (at or less than 16 Degrees Fahrenheit/-8.9 Degrees Celsius 
                           during August-December
                  "FZF4_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF4 value occurred

                  "FZF5" = Temperature Value of Last Freeze (at or less than 32 Degrees Fahrenheit/-0.0 Degrees Celsius 
                           during January through July
                  "FZF5_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF5 value occurred

                  "FZF6" = Temperature Value of Last Freeze (at or less than 28 Degrees Fahrenheit/-2.2 Degrees Celsius 
                           during January through July
                  "FZF6_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF6 value occurred

                  "FZF7" = Temperature Value of Last Freeze (at or less than 24 Degrees Fahrenheit/-4.4 Degrees Celsius 
                           during January through July
                  "FZF7_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF7 value occurred

                  "FZF8" = Temperature Value of Last Freeze (at or less than 20 Degrees Fahrenheit/-6.7 Degrees Celsius 
                           during January through July
                  "FZF8_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF8 value occurred

                  "FZF9" = Temperature Value of Last Freeze (at or less than 16 Degrees Fahrenheit/-8.9 Degrees Celsius 
                           during January through July
                  "FZF9_ATTRIBUTES" = S,cccc where:                                                                                               
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cccc = two-digit month/two-digit date when the FZF9 value occurred

                  "HDSD" = Heating Degree Days (season-to-date). Running total of monthly heating degree days through
                           the end of the season. Each month is summed to produce a season-to-date total. Season
                           starts in July in Northern Hemisphere and January in Southern Hemisphere. Given in Celsius or
                           Fahrenheit degrees depending on user specification.
                  "HDSD_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                                                    
                  "HNyz" = Highest minimum soil temperature for the year given in Celsius or Fahrenheit depending
                           on user specification.

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of HNyz.)

                  "HNyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "HTDD" = Heating Degree Days. Computed when daily average temperature is less than 65 degrees
                           Fahrenheit/18.3 degrees Celsius. (HDD = 65(F)/18.3(C) – mean daily temperature). Each month is summed to
                           produce an annual total. Annual totals are computed based on a July – June year in Northern Hemisphere and 
                           January – December year in Southern Hemisphere. Given in Celsius or Fahrenheit degrees depending on user specification.
                  "HTDD_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "HXyz" = Highest maximum soil temperature for the year given in Celsius or Fahrenheit depending
                           on user specification.

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of HXyz.)

                  "HXyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "LNyz" = Lowest minimum soil temperature for the year given in Celsius or Fahrenheit depending
                           on user specification.

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of LNyz.)

                  "LNyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "LXyz" = Lowest maximum soil temperature for the year given in Celsius or Fahrenheit depending
                           on user specification.

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of LXyz.)

                  "LXyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "MNPN" = Annual Mean Minimum Temperature of evaporation pan water. Given in Celsius or
                           Fahrenheit depending on user specification.
                  "MNPN_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "MNyz" = Annual Mean of daily minimum soil temperature given in Celsius or Fahrenheit
                           depending on user specification.
                           
                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of MNyz.) 

                  "MNyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "MXPN" = Annual Mean Maximum Temperature of evaporation pan water. Given in Celsius or
                           Fahrenheit depending on user specification.
                  "MXPN_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "MXyz" = Annual Mean of daily maximum soil temperature given in Celsius or Fahrenheit
                           depending on user specification.

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of MXyz.)

                  "MXyz_ATTRIBUTES" =  S,y,z where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code <--BK Note to Ron: What is P for USC00042294.csv?>
                                           z = Soil Depth Code <--BK Note to Ron: What is N for USC00042294.csv?>

                  "PRCP" = Total Annual Precipitation. Given in inches or millimeters depending on user
                           specification.
                  "PRCP_ATTRIBUTES" = M,S where: <--BK Note:  Ask Jay and Ron to check on this for both GSOM and GSOY-->
                                           M = Measurement Flag where:
                                                a is used for any accumulation within the year.
                                                T is used for Trace amount; Trace flag supersedes an accumulation flag. 
                                                blank is used if no days are missing
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "PSUN" = Annual average of the daily percents of possible sunshine.
                  "PSUN_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "SNOW" = Total Annual Snowfall. Given in inches or millimeters depending on user specification.
                  "SNOW_ATTRIBUTES" = M,S where: <--BK Note:  Ask Jay and Ron to check on this for both GSOM and GSOY-->
                                           M = Measurement Flag where:
                                                T is used for Trace amount; Trace flag supersedes an accumulation flag. 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TAVG" = Average Annual Temperature. Computed by adding the unrounded monthly average temperatures and dividing by 12.
                           Given in Celsius or Fahrenheit depending on user specification. Missing if one or more months are
                           missing or flagged.
                  "TAVG_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TMAX" = Average Annual Maximum Temperature. Average of the mean monthly maximum temperatures given in
                           Celsius or Fahrenheit depending on user specification. Missing if one or more months are
                           missing or flagged.
                  "TMAX_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TMIN" = Average Annual Minimum Temperature. Average of the mean monthly minimum temperatures given in
                           Celsius or Fahrenheit depending on user specification. Missing if one or more months are
                           missing or flagged.
                  "TMIN_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TSUN" = Annual total sunshine in minutes.
                  "TSUN_ATTRIBUTES" = a,S where:                                                                                              
                                           a = <--BK Note:  As Ron about this as it appears blank for USW00003812's GSOY File-->
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF1" = Wind Direction for Maximum Wind Speed/Fastest 1-Minute (WSF1). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.).
                  "WDF1_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF2" = Wind Direction for Maximum Wind Speed/Fastest 2-Minute (WSF2). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.).
                  "WDF2_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF5" = Wind Direction for Peak Wind Gust Speed – Fastest 5-second (WSF5). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.).
                  "WDF5_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                             
                  "WDFG" = Wind Direction for Peak Wind Gust Speed (WSFG). Given in 360-degree compass point
                           directions (e.g. 360 = north, 180 = south, etc.).
                  "WDFG_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 

                  "WDFI" = Direction of highest instantaneous wind speed (WDFI).  Given in 360-degree compass point
                           directions (e.g. 360 = north, 180 = south, etc.). Missing if more than 5 days within the month are missing
                           or flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing:
                           Flag indicating number of days missing or flagged (from 1 to 5).
                  "WDFI_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WDFM" = Wind Direction for Maximum Wind Speed/Fastest Mile (WSFM). Given in 360-degree compass
                           point directions (e.g. 360 = north, 180 = south, etc.).
                  "WDFM_ATTRIBUTES" =  S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WDMV" = Total Annual Wind Movement over evaporation pan. Given in miles or kilometers
                           depending on user specification.
                  "WDMV_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSF1" = Maximum Wind Speed/Fastest 1-minute. Maximum wind speed for the year reported as
                           the fastest 1-minute. 
                  "WSF1_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                            
                  "WSF2" = Maximum Wind Speed/Fastest 2-minute. Maximum wind speed for the year reported as
                           the fastest 2-minute. Given in miles per hour or meters per second depending on user specification.
                  "WSF2_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSF5" = Peak Wind Gust Speed – Fastest 5-second wind. Maximum wind gust for the year. Given
                           in miles per hour or second depending on user specification.
                  "WSF5_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSFG" = Peak Wind Gust Speed. Maximum wind gust for the year. Given in miles per hour or
                           second depending on user specification. 
                  "WSFG_ATTRIBUTES" = S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WSFI" = Highest instantaneous wind speed for the year.  Given in miles per hour or
                           second depending on user specification. Missing if more than 5 days within the month are missing or
                           flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag
                           indicating number of days missing or flagged (from 1 to 5).
                  "WSFI_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WSFM" = Maximum Wind Speed/Fastest Mile. Maximum wind speed for the year reported as the
                           fastest mile. Given in miles per hour or meters per second depending on user specification.
                  "WSFM_ATTRIBUTES" =  S where:                                                                                              
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

             i.  For the HNyz, HXyz, LNyz, LXyz, MNyz and MXyz elements, the “y” and "z" values within the Element Type Name are as follows:
             
                 For "y":
                      1 = grass
                      2 = fallow
                      3 = bare ground
                      4 = brome grass
                      5 = sod
                      6 = straw mulch
                      7 = grass muck
                      8 = bare muck
                      0 = unknown
             
                 For “z”:
                      1 = 2 inches or 5 centimeters depth
                      2 = 4 inches or 10 centimeters depth
                      3 = 8 inches or 20 centimeters depth
                      4 = 20 inches or 50 centimeters depth
                      5 = 40 inches or 100 centimeters depth
                      6 = 60 inches or 150 centimeters depth
                      7 = 72 inches or 180 centimeters depth
                      0 = unknown
             
             ii.    GHCN-Daily Dataset Measurement Flags (as of 1/10/2017):

                     Blank = no measurement information applicable
                     B     = precipitation total formed from two 12-hour totals
                     D     = precipitation total formed from four six-hour totals
	             H     = represents highest or lowest hourly temperature (TMAX or TMIN) 
	                     or the average of hourly values (TAVG)
	             K     = converted from knots 
	             L     = temperature appears to be lagged with respect to reported
	                     hour of observation 
                     O     = converted from oktas 
	             P     = identified as "missing presumed zero" in DSI 3200 and 3206
                     T     = trace of precipitation, snowfall, or snow depth
	             W     = converted from 16-point WBAN code (for wind direction)

             iii.   GHCN-Daily Dataset Quality Flags (as of 1/10/2017):

                      Blank = did not fail any quality assurance check
                      D     = failed duplicate check
                      G     = failed gap check
                      I     = failed internal consistency check
                      K     = failed streak/frequent-value check
	              L     = failed check on length of multiday period 
                      M     = failed megaconsistency check
                      N     = failed naught check
                      O     = failed climatological outlier check
                      R     = failed lagged range check
                      S     = failed spatial consistency check
                      T     = failed temporal consistency check
                      W     = temperature too warm for snow
                      X     = failed bounds check
	              Z     = flagged as a result of an official Datzilla 
	                      investigation

             iv.  GHCN-Daily Dataset Source Codes (as of 1/10/2017):
                  
                      Blank = No source (i.e., data value missing)
                      0     = U.S. Cooperative Summary of the Day (NCDC DSI-3200)
                      6     = CDMP Cooperative Summary of the Day (NCDC DSI-3206)
                      7     = U.S. Cooperative Summary of the Day -- Transmitted 
	                      via WxCoder3 (NCDC DSI-3207)
                      A     = U.S. Automated Surface Observing System (ASOS) 
                              real-time data (since January 1, 2006)
	              a     = Australian data from the Australian Bureau of Meteorology
                      B     = U.S. ASOS data for October 2000-December 2005 (NCDC 
                              DSI-3211)
	              b     = Belarus update
	              C     = Environment Canada
	              E     = European Climate Assessment and Dataset (Klein Tank 
	                      et al., 2002)	   
                      F     = U.S. Fort data 
                      G     = Official Global Climate Observing System (GCOS) or 
                              other government-supplied data
                      H     = High Plains Regional Climate Center real-time data
                      I     = International collection (non U.S. data received through
	                      personal contacts)
                      K     = U.S. Cooperative Summary of the Day data digitized from
	                      paper observer forms (from 2011 to present)
                      M     = Monthly METAR Extract (additional ASOS data)
	              N     = Community Collaborative Rain, Hail,and Snow (CoCoRaHS)
	              Q     = Data from several African countries that had been 
	                      "quarantined", that is, withheld from public release
	                      until permission was granted from the respective 
	                      meteorological services
                      R     = NCEI Reference Network Database (Climate Reference Network
	                      and Regional Climate Reference Network)
	              r     = All-Russian Research Institute of Hydrometeorological 
	                      Information-World Data Center
                      S     = Global Summary of the Day (NCDC DSI-9618)
                              NOTE: "S" values are derived from hourly synoptic reports
                              exchanged on the Global Telecommunications System (GTS).
                              Daily values derived in this fashion may differ significantly
                              from "true" daily data, particularly for precipitation
                              (i.e., use with caution).
	              s     = China Meteorological Administration/National Meteorological Information Center/
	                      Climatic Data Center (http://cdc.cma.gov.cn)
                      T     = SNOwpack TELemtry (SNOTEL) data obtained from the U.S. 
	                      Department of Agriculture's Natural Resources Conservation Service
	              U     = Remote Automatic Weather Station (RAWS) data obtained
	                      from the Western Regional Climate Center	   
	              u     = Ukraine update	   
	              W     = WBAN/ASOS Summary of the Day from NCDC's Integrated 
	                      Surface Data (ISD).  
                      X     = U.S. First-Order Summary of the Day (NCDC DSI-3210)
	              Z     = Datzilla official additions or replacements 
	              z     = Uzbekistan update

2.  DATA

     2.1  METADATA

          The metadata for GSOY Stations are provided by NCEI's Metadata Team via its Historical Observing Metadata
          Repository (HOMR) Website.  Please go to the NCEI Historical Observing Metadata Repository (HOMR) Website at 
          http://www.ncdc.noaa.gov/homr/ in order to access these particular Metadata reports.

          An overview of the GSOY Dataset is also available at the following web link:
          https://gis.ncdc.noaa.gov/all-records/catalog/search/resource/details.page?id=gov.noaa.ncdc:C00946

     2.2  DATA

          Global Summary Of The Month (GSOY) Data are available for access via the GSOY Raw Data Files at
          https://www.ncei.noaa.gov/data/gsoy/ and via the Climate Data Online (CDO) Website at 
          http://www.ncdc.noaa.gov/cdo-web .  

3.  CONTACT
      
     3.1  QUESTIONS AND FEEDBACK
     
          NCEI.Orders@noaa.gov
          

