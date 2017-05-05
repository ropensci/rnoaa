GLOBAL SUMMARY OF THE MONTH (GSOM) DATA FILES
(Last Updated:  3/27/2017)

1.  INTRODUCTION

    1.1  OVERVIEW

         The Global Summary Of The Month (GSOM) Data Files contain quality controlled monthly
         summaries of more than 50 elements (max temp, snow, etc.) computed from stations in
         the Global Historical Climatology Network (GHCN)-Daily dataset.  These include non-US
         stations, providing a global product from 1763 to present that is updated weekly.
         This is not to be confused with GHCN-Monthly, which only contains temperature and
         precipitation elements and which include bias corrected data (which are not available
         in the first release of GSOM/GSOY).  A description of the files are included below in
         Section 1.3.

    1.2  ACCESS

         The GSOM Data Files can be accessed at the following location:

         https://www.ncei.noaa.gov/data/gsom/

    1.3  DOWNLOADING

         There are three sets of individual files that are included as part of the HPD Digital Inventory Reports:

         a.  XXY########.csv (GSOM Station Data File Name)

             XXY######## is the GHCN ID for the station in question, where:

             XX = FIPS Country Code Two-Letter Identifier
             Y = Station Network Code (Identifies The Station Numbering System Used)

                 Valid Station Network Codes:

                     0 = unspecified (station identified by up to eight 
	                 alphanumeric characters)
	             1 = Community Collaborative Rain, Hail,and Snow (CoCoRaHS)
	                 based identification number.  To ensure consistency with
	                 with GHCN Daily and GSOM, all numbers in the original CoCoRaHS
                         ID have been left-filled to make them all four digits long. 
	                 In addition, the characters "-" and "_" have been removed 
	                 to ensure that the IDs do not exceed 11 characters when 
	                 preceded by "US1". For example, the CoCoRaHS ID 
	                 "AZ-MR-156" becomes "US1AZMR0156" in GSOM
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

             The following is the format of the data records that are contained within the GSOM Files (line spacing shown below between 
             element groups/attributes does NOT imply spacing within the GSOM Data Files):

                  "STATION" = GHCN ID (see above for further explanation)
                  "DATE" = YYYY-MM where YYYY is 4-digit year and MM is 2-digit month
                  "AWND" = Monthly Average Wind Speed. Given in miles per hour or meters per second depending
                           on user specification. Missing if more than 5 days within the month are missing or flagged or if more
                           than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number
                           of days missing or flagged (from 1 to 5).
                  "AWND_ATTRIBUTES" = a,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "CDSD" = Cooling Degree Days (season-to-date). Running total of monthly cooling degree days through the
                           end of the most recent month. Each month is summed to produce a season-to-date total. Season starts in January
                           in Northern Hemisphere and July in Southern Hemisphere. Given in Celsius or Fahrenheit degrees depending on user
                           specification.
                  "CDSD_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                         
                  "CLDD" = Cooling Degree Days. Computed when daily average temperature is more than 65 degrees Fahrenheit/18.3 degrees 
                  Celsius. CDD = mean daily temperature - 65 degrees Fahrenheit/18.3 degrees Celsius. Each day is summed to produce a 
                  monthly total. Given in Celsius or Fahrenheit degrees depending on user specification.
                  "CLDD_ATTRIBUTES" = a,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "DP01" = Number of days with >= 0.01 inch/0.254 millimeter in the month.  Values originally recorded in inches as 0.01
                           are stored as 3 tenths of a millimeter.  Technically, this test is for values greater than or equal to 3 tenths of
                           a millimeter.
                  "DP01_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)     
                                                               
                  "DP10" = Number of days with >= 0.1 inch/2.54 millimeter in the month.  Values originally recorded in inches as 0.10 are
                           stored as 25 tenths of a millimeter.  Technically, this test is for values greater than or equal to 25 tenths of
                           a millimeter.
                  "DP10_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)      
                                                              
                  "DP1X" = Number of days with >= 1.00 inch/25.4 millimeters in the month.
                  "DP1X_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                                                    
                  "DSND" = Number of days with snow depth >= 1 inch/25 millimeters.
                  "DSND_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  
                                                                  
                  "DSNW" = Number of days with snowfall >= 1 inch/25 millimeters
                  "DSNW_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DT00" = Number of days with maximum temperature <= 0 degrees Fahrenheit/-17.8 degrees Celsius.
                  "DT00_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DT32" = Number of days with minimum temperature <= 32 degrees Fahrenheit/0 degrees Celsius.
                  "DT32_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)   
                                                                 
                  "DX32" = Number of days with maximum temperature <= 32 degrees Fahrenheit/0 degrees Celsius.
                  "DX32_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "DX70" = Number of days with maximum temperature >= 70 degrees Fahrenheit/21.1 degrees Celsius.
                  "DX70_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  
                                                                  
                  "DX90" = Number of days with maximum temperature >= 90 degrees Fahrenheit/32.2 degrees Celsius
                  "DX90_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                                                   
                  "EMNT" =  Extreme minimum temperature for month. Lowest daily minimum temperature for the
                            month. Given in Celsius or Fahrenheit depending on user specification.
                  "EMNT_ATTRIBUTES" = a,S,cc,d where:                                                                                               
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                                                            blank if no days are missing or flagged  
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cc = two-digit date during the month when the EMNT value occurred; if it occurs more than once,
                                                it's the last date during the month for which it occurred
                                                (originates from the DYNT element within the Raw GSOM Files)
                                           d = + if there's more than one date during the month when EMNT value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYNT element within the Raw GSOM Files)

                  "EMSD" = Highest daily snow depth in the month. Given in inches or millimeters depending on user
                           specification.
                  "EMSD_ATTRIBUTES" = a,M,S,cc,d where:                                                                                               
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                                                            blank if no days are missing or flagged  
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cc = two-digit date during the month when the EMSD value occurred; if it occurs more than once,
                                                it's the last date during the month for which it occurred
                                               (originates from the DYSD element within the Raw GSOM Files)
                                           d = + if there's more than one date during the month when EMSD value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYSD element within the Raw GSOM Files)

                  "EMSN" = Highest daily snowfall in the month. Given in inches or millimeters depending on user
                           specification.
                  "EMSN_ATTRIBUTES" =  a,M,S,cc,d where:                                                                                               
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                                                            blank if no days are missing or flagged  
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cc = two-digit date during the month when the EMSN value occurred; if it occurs more than once,
                                                it's the last date during the month for which it occurred
                                                (originates from the DYSN element within the Raw GSOM Files)
                                           d = + if there's more than one date during the month when EMSN value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYSN element within the Raw GSOM Files)

                  "EMXP" = Highest daily total of precipitation in the month. Given in inches or millimeters depending
                           on user specification.
                  "EMXP_ATTRIBUTES" =  a,M,S,cc,d where:                                                                                               
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                                                            blank if no days are missing or flagged  
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cc = two-digit date during the month when the EMXP value occurred; if it occurs more than once,
                                                it's the last date during the month for which it occurred
                                                (originates from the DYXP element within the Raw GSOM Files)
                                           d = + if there's more than one date during the month when EMXP value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYXP element within the Raw GSOM Files)

                  "EMXT" = Extreme maximum temperature for month. Highest daily maximum temperature for the
                           month. Given in Celsius or Fahrenheit depending on user specification.
                  "EMXT_ATTRIBUTES" =  a,S,cc,d where:                                                                                               
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided
                                                                            blank if no days are missing or flagged  
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)                         
                                           cc = two-digit date during the month when the EMXT value occurred; if it occurs more than once,
                                                it's the last date during the month for which it occurred
                                                (originates from the DYXT element within the Raw GSOM Files)
                                           d = + if there's more than one date during the month when EMXT value occurred more than once
                                               blank if it only occurred once
                                               (originates from the DYXT element within the Raw GSOM Files)

                  "EVAP" = Total Monthly Evaporation. Given in inches or millimeters depending on user
                           specification. Measurement Flags: T is used for trace amount, a is used for any accumulation within a
                           month that includes missing days. If no days are missing, no flag is used. Source Flag: Source flag
                           from GHCN-Daily (see separate documentation for GHCN-Daily). Days Miss Flag: Number of days missing
                           or flagged.
                  "EVAP_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                             
                  "HDSD" = Heating Degree Days (season-to-date). Running total of monthly heating degree days through
                           the end of the most recent month. Each month is summed to produce a season-to-date total. Season
                           starts in July in Northern Hemisphere and January in Southern Hemisphere. Given in Celsius or
                           Fahrenheit degrees depending on user specification.
                  "HDSD_ATTRIBUTES" = S where:
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                                                    
                  "HNyz" = Highest minimum soil temperature for the month given in Celsius or Fahrenheit depending
                           on user specification. Missing if more than 5 days within the month are missing or flagged or if more
                           than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number
                           of days missing or flagged (from 1 to 5).

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of HNyz.)

                  "HNyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "HTDD" = Heating Degree Days. Computed when daily average temperature is less than 65 degrees
                           Fahrenheit/18.3 degrees Celsius. HDD = 65(F)/18.3(C) – mean daily temperature. Each day is summed to
                           produce a monthly total.  Given in Celsius or Fahrenheit degrees depending on user specification.
                  "HTDD_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "HXyz" = Highest maximum soil temperature for the month given in Celsius or Fahrenheit depending
                           on user specification. Missing if more than 5 days within the month are missing or flagged or if more
                           than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number
                           of days missing or flagged (from 1 to 5). 

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of HXyz.)

                  "HXyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "LNyz" = Lowest minimum soil temperature for the month given in Celsius or Fahrenheit depending
                           on user specification. Missing if more than 5 days within the month are missing or flagged or if more 
                           than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number
                           of days missing or flagged (from 1 to 5).

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of LNyz.)

                  "LNyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "LXyz" = Lowest maximum soil temperature for the month given in Celsius or Fahrenheit depending
                           on user specification. Missing if more than 5 days within the month are missing or flagged or if more
                           than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number
                           of days missing or flagged (from 1 to 5).

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of LXyz.)

                  "LXyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "MNPN" = Monthly Mean Minimum Temperature of evaporation pan water. Given in Celsius or
                           Fahrenheit depending on user specification. Missing if more than 5 days within the month are missing or
                           flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag
                           indicating number of days missing or flagged (from 1 to 5).
                  "MNPN_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "MNyz" = Monthly Mean of daily minimum soil temperature given in Celsius or Fahrenheit
                           depending on user specification. Missing if more than 5 days within the month are missing or flagged or
                           if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating
                           number of days missing or flagged (from 1 to 5).
                           
                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of MNyz.) 

                  "MNyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "MXPN" = Monthly Mean Maximum Temperature of evaporation pan water. Given in Celsius or
                           Fahrenheit depending on user specification. Missing if more than 5 days within the month are missing or
                           flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag
                           indicating number of days missing or flagged (from 1 to 5).
                  "MXPN_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "MXyz" = Monthly Mean of daily maximum soil temperature given in Celsius or Fahrenheit
                           depending on user specification. Missing if more than 5 days within the month are missing or flagged or
                           if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag indicating
                           number of days missing or flagged (from 1 to 5). 

                           (See Section 1.3.a.i for details on what 'y' and 'z' mean within this element header of MXyz.)

                  "MXyz_ATTRIBUTES" =  a,M,Q,S,y,z where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                           y = Ground Cover Code
                                           z = Soil Depth Code

                  "PRCP" = Total Monthly Precipitation. Given in inches or millimeters depending on user
                           specification. Measurement Flags: T is used for trace amount, a is used for any accumulation within a
                           month that includes missing days. If no days are missing, no flag is used.
                  "PRCP_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "PSUN" = Monthly Average of the daily percents of possible sunshine. Days Miss Flag: Number of
                           days missing or flagged.
                  "PSUN_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "SNOW" = Total Monthly Snowfall. Given in inches or millimeters depending on user specification.
                           Measurement Flags:  T is used for trace amount, a is used for any accumulation within a month that
                           includes missing days. If no days are missing, no flag is used.
                  "SNOW_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TAVG" = Average Monthly Temperature. Computed by adding the unrounded monthly
                           maximum and minimum temperatures and dividing by 2. Given in Celsius or Fahrenheit depending on
                           user specification. Missing if more than 5 days within the month are missing or flagged or if more than 3
                           consecutive values within the month are missing or flagged. DaysMissing: Flag indicating number of days
                           missing or flagged (from 1 to 5).
                  "TAVG_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TMAX" = Monthly Maximum Temperature. Average of daily maximum temperature given in
                           Celsius or Fahrenheit depending on user specification. Missing if more than 5 days within the month are
                           missing or flagged or if more than 3 consecutive values within the month are missing or flagged.
                           DaysMissing: Flag indicating number of days missing or flagged (from 1 to 5).
                  "TMAX_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TMIN" = Monthly Minimum Temperature. Average of daily minimum temperature given in
                           Celsius or Fahrenheit depending on user specification. Missing if more than 5 days within the month are
                           missing or flagged or if more than 3 consecutive values within the month are missing or flagged.
                           DaysMissing: Flag indicating number of days missing or flagged (from 1 to 5).
                  "TMIN_ATTRIBUTES" =  a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "TSUN" = Daily total sunshine in minutes. Days Miss Flag: Number of days missing or flagged.
                  "TSUN_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF1" = Wind Direction for Maximum Wind Speed/Fastest 1-Minute (WSF1). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.). Missing if more than 5 days within the
                           month are missing or flagged or if more than 3 consecutive values within the month are missing or
                           flagged. DaysMissing: Flag indicating number of days missing or flagged (from 1 to 5).
                  "WDF1_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF2" = Wind Direction for Maximum Wind Speed/Fastest 2-Minute (WSF2). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.).
                  "WDF2_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WDF5" = Wind Direction for Peak Wind Gust Speed – Fastest 5-second (WSF5). Given in 360-degree
                           compass point directions (e.g. 360 = north, 180 = south, etc.). Missing if more than 5 days within the
                           month are missing or flagged or if more than 3 consecutive values within the month are missing or
                           flagged. DaysMissing: Flag indicating number of days missing or flagged (from 1 to 5).
                  "WDF5_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)
                                             
                  "WDFG" = Wind Direction for Peak Wind Gust Speed (WSFG). Given in 360-degree compass point
                           directions (e.g. 360 = north, 180 = south, etc.). Missing if more than 5 days within the month are missing
                           or flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing:
                           Flag indicating number of days missing or flagged (from 1 to 5).
                  "WDFG_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
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
                  "WDFM_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WDMV" = Total Monthly Wind Movement over evaporation pan. Given in miles or kilometers
                           depending on user specification. Days Miss Flag: Number of days missing or flagged.
                  "WDMV_ATTRIBUTES" = a,M,Q,S where:
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           M = GHCN-Daily Dataset Measurement Flag (see Section 1.3.a.ii for more details) 
                                           Q = GHCN-Daily Dataset Quality Flag (see Section 1.3.a.iii for more details)
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSF1" = Maximum Wind Speed/Fastest 1-minute. Maximum wind speed for the month reported as
                           the fastest 1-minute. Given in miles per hour or meters per second depending on user specification.
                           Missing if more than 5 days within the month are missing or flagged or if more than 3 consecutive values
                           within the month are missing or flagged. DaysMissing: Flag indicating number of days missing or flagged
                           (from 1 to 5).
                  "WSF1_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details) 
                                            
                  "WSF2" = Maximum Wind Speed/Fastest 2-minute. Maximum wind speed for the month reported as
                           the fastest 2-minute. Given in miles per hour or meters per second depending on user specification.
                           Missing if more than 5 days within the month are missing or flagged or if more than 3 consecutive values
                           within the month are missing or flagged. DaysMissing: Flag indicating number of days missing or flagged
                           (from 1 to 5).
                  "WSF2_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSF5" = Peak Wind Gust Speed – Fastest 5-second wind. Maximum wind gust for the month. Given
                           in miles per hour or second depending on user specification. Missing if more than 5 days within the
                           month are missing or flagged or if more than 3 consecutive values within the month are missing or
                           flagged. DaysMissing: Flag indicating number of days missing or flagged (from 1 to 5).
                  "WSF5_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)  

                  "WSFG" = Peak Wind Gust Speed. Maximum wind gust for the month. Given in miles per hour or
                           second depending on user specification. Missing if more than 5 days within the month are missing or
                           flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag
                           indicating number of days missing or flagged (from 1 to 5).
                  "WSFG_ATTRIBUTES" = a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WSFI" = Highest instantaneous wind speed for the month.  Given in miles per hour or
                           second depending on user specification. Missing if more than 5 days within the month are missing or
                           flagged or if more than 3 consecutive values within the month are missing or flagged. DaysMissing: Flag
                           indicating number of days missing or flagged (from 1 to 5).
                  "WSFI_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
                                           S = GHCN-Daily Dataset Source Code (see Section 1.3.a.iv for more details)

                  "WSFM" = Maximum Wind Speed/Fastest Mile. Maximum wind speed for the month reported as the
                           fastest mile. Given in miles per hour or meters per second depending on user specification. Missing if
                           more than 5 days within the month are missing or flagged or if more than 3 consecutive values within
                           the month are missing or flagged. DaysMissing: Flag indicating number of days missing or flagged (from
                           1 to 5).
                  "WSFM_ATTRIBUTES" =  a,S where:                                                                                              
                                           a = DaysMissing (Numeric value): The number of days (from 1 to 5) missing or flagged is provided   
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
             
             ii.    GHCN-Daily Dataset Measurement Flags (as of 1/9/2017):

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

             iii.   GHCN-Daily Dataset Quality Flags (as of 1/9/2017):

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

             iv.  GHCN-Daily Dataset Source Codes (as of 1/9/2017):
                  
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

          The metadata for GSOM Stations are provided by NCEI's Metadata Team via its Historical Observing Metadata
          Repository (HOMR) Website.  Please go to the NCEI Historical Observing Metadata Repository (HOMR) Website at 
          http://www.ncdc.noaa.gov/homr/ in order to access these particular Metadata reports.

          An overview of the GSOM Dataset is also available at the following web link:
          https://gis.ncdc.noaa.gov/all-records/catalog/search/resource/details.page?id=gov.noaa.ncdc:C00946

     2.2  DATA

          Global Summary Of The Month (GSOM) Data are available for access via the GSOM Raw Data Files at
          https://www.ncei.noaa.gov/data/gsom/ and via the Climate Data Online (CDO) Website at 
          http://www.ncdc.noaa.gov/cdo-web .  

3.  CONTACT
      
     3.1  QUESTIONS AND FEEDBACK
     
          NCEI.Orders@noaa.gov
          

