<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{NOAA NCDC dataset attributes}
%\VignetteEncoding{UTF-8}
-->

NOAA NCDC dataset attributes
======

The attributes, or "flags", for each row of the output for data may have a flag with it.
Each `datasetid` has it's own set of flags. The following are flag columns, and what they
stand are. `fl_` is the beginning of each flag column name, then one or more characters
to describe the flag, keeping it short to maintain a compact data frame. Some of these
fields are the same across datasetids, but they may have different possible values. See
below details on each dataset.

* fl_c = completeness
* fl_m = measurement
* fl_d =  day
* fl_q = quality
* fl_s = source
* fl_t = time
* fl_cmiss = consecutive missing
* fl_miss = missing
* fl_u = units

__Datasets__

* [GHCND](#ghcnd)
* [GSOM](#gsom)
* [GSOY](#gsoy)
* [NORMAL_ANN](#normalann)
* [NORMAL_DLY](#normaldly)
* [NORMAL_HLY](#normalhly)
* [NORMAL_MLY](#normalmly)
* [PRECIP_HLY](#preciphly)
* [PRECIP_15](#precip15)
* NEXRAD2 - not working yet
* NEXRAD3 - not working yet


### <a href="#ghcnd" name="ghcnd"/>#</a> Dataset: GHCND

#### flm_m (Measurement flag)

* __Blank:__ no measurement information applicable
* __A:__ value in precipitation or snow is a multi-day total, accumulated since last measurement (used on Daily Form pdf file)
* __B:__ precipitation total formed from two 12-hour totals
* __D:__ precipitation total formed from four six-hour totals
* __K:__ converted from knots
* __L:__ temperature appears to be lagged with respect to reported hour of observation
* __O:__ converted from oktas
* __P:__ identified as "missing presumed zero" in DSI 3200 and 3206
* __T:__ trace of precipitation, snowfall, or snow depth
* __W:__ converted from 16-point WBAN code (for wind direction)

#### fl_q (Quality flag)

* __Blank:__ did not fail any quality assurance check
* __D:__ failed duplicate check
* __G:__ failed gap check
* __I:__ failed internal consistency check
* __K:__ failed streak/frequent-value check
* __L:__ failed check on length of multiday period
* __M:__ failed mega-consistency check
* __N:__ failed naught check
* __O:__ failed climatological outlier check
* __R:__ failed lagged range check
* __S:__ failed spatial consistency check
* __T:__ failed temporal consistency check
* __W:__ temperature too warm for snow
* __X:__ failed bounds check
* __Z:__ flagged as a result of an official Datzilla investigation

#### fl_s (Source flag)

* __Blank:__ No source (i.e., data value missing)
* __0:__ U.S. Cooperative Summary of the Day (NCDC DSI-3200)
* __6:__ CDMP Cooperative Summary of the Day (NCDC DSI-3206)
* __7:__ U.S. Cooperative Summary of the Day, Transmitted via WxCoder3 (NCDC DSI-3207)
* __A:__ U.S. Automated Surface Observing System (ASOS) real-time data (since January 1, 2006)
* __a:__ Australian data from the Australian Bureau of Meteorology
* __B:__ U.S. ASOS data for October 2000-December 2005 (NCDC DSI-3211)
* __b:__ Belarus update
* __E:__ European Climate Assessment and Dataset (Klein Tank et al., 2002)
* __F:__ U.S. Fort data
* __G:__ Official Global Climate Observing System (GCOS) or other government-supplied data
* __H:__ High Plains Regional Climate Center real-time data
* __I:__ International collection (non U.S. data received through personal contacts)
* __K:__ U.S. Cooperative Summary of the Day data digitized from paper observer forms (from 2011 to present)
* __M:__ Monthly METAR Extract (additional ASOS data)
* __N:__ Community Collaborative Rain, Hail,and Snow (CoCoRaHS)
* __Q:__ Data from several African countries that had been "quarantined", that is, withheld from public release until permission was granted from the respective meteorological services
* __R:__ NCDC Reference Network Database (Climate Reference Network and Historical Climatology Network-Modernized)
* __r:__ All-Russian Research Institute of Hydrometeorological Information-World Data Center
* __S:__ Global Summary of the Day (NCDC DSI-9618) NOTE: "S" values are derived from hourly synoptic reports exchanged on the Global Telecommunications System (GTS). Daily values derived in this fashion may differ significantly from "true" daily data, particularly for precipitation(i.e., use with caution).
* __u:__ Ukraine update
* __W:__ WBAN/ASOS Summary of the Day from NCDC's Integrated Surface Data (ISD).
* __X:__ U.S. First-Order Summary of the Day (NCDC DSI-3210)
* __Z:__ Datzilla official additions or replacements
* __z:__ Uzbekistan update

#### fl_t (Time of observation flag)

Is the (2 digit hour, 2 digit minute) 24 hour clock time of the observation given as the
local time at the station of record.



### <a href="#gsom" name="gsom"/>#</a> Dataset: GSOM

__More info:__ <https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/gsom-gsoy.pdf>

Observations are synonymous with elements or values, and defined in Table A below. 9999 indicates missing data or data that has not been received.

__flags:__ Missing flag , Consecutive Missing flag

#### fl_miss (Missing flag)

Defined as total number of days observation/element is missing in that month. This can  be taken as a measure of quality or completeness as the higher the number of days sampled in the month, the more representative the value is for the entire month.

#### fl_cmiss (Consecutive missing flag)

Defined as the maximum number of consecutive days in the month that an  observation/element is missing.



### <a href="#gsoy" name="gsoy"/>#</a> Dataset: GSOY

__More info:__ <https://www1.ncdc.noaa.gov/pub/data/cdo/documentation/gsom-gsoy.pdf>

#### fl_m (Measurement flag)

* __A:__ Accumulated amount. This value is a total that may include data from a previous month or months
(TPCP).
* __B:__ Adjusted Total. Monthly value totals based on proportional available data across the entire month.
(CLDD, HTDD)
* __E:__ An estimated monthly or annual total.
* __I:__ Monthly means or totals based on incomplete time series. 1 to 9 days are missing. (MMNT,MMXP,
MMXT, MNTM, TPCP, TSNW)
* __M:__ used to indicate data element missing.
* __S:__ Precipitation for the amount is continuing to be accumulated. Total will be included in a
__subsequent value (TPCP). Example:__ Days 1-20 had 1.35 inches of precipitation, then a period of accumulation began. The element TPCP would then be 00135S and the total accumulated amount value appears in a subsequent monthly value. If TPCP = 0 there was no precipitation measured during the month. flag 1 is set to "S" and the total accumulated amount appears in a subsequent monthly value.
* __T:__ Trace of precipitation, snowfall, or snow depth. The precipitation data value will = "00000".
(EMXP, MXSD, TPCP, TSNW)
* __+:__ The phenomena in question occurred on several days. The date in the DAY field is the last day
of occurrence.
* __Blank:__ No report

#### fl_q (Quality flag)

* __A:__ Accumulated amount
* __E:__ Estimated value
* __+:__ Value occurred on more than one day, last date of occurrence is used

#### fl_d (Number of days flag )

Number of days is given as 00 when all days in the month are considered in
computing data value or otherwise the maximum number of consecutive days in the month considered
in computing the data value.

#### fl_u (Units flag)

* __C:__ Whole degree Celsius
* __D:__ Whole Fahrenheit Degree Day
* __F:__ Whole degree Fahrenheit
* __HI:__ Hundredths of inches
* __I:__ Whole inches
* __M:__ Whole miles
* __MH:__ Miles per hour
* __MM:__ Millimeters
* __NA:__ No units applicable (dimensionless)
* __TC:__ Tenths of degrees Celsius
* __TF:__ Tenths of degrees Fahrenheit
* __TI:__ Tenths of inches
* __TM:__ Tenths of millimeters
* __1:__ Soils, degrees Fahrenheit, soil depths in inches and hundredths
* __2:__ Soils, degrees Celsius, soil depth in whole centimeters
* __3:__ Soils, degrees Celsius, soil, soil depth in inches and hundredths
* __4:__ Soils, degrees Fahrenheit, soil depth in whole centimeters
* __5:__ Soils, If the soil station closed during the current month, '5' indicates the station has closed.



### <a href="#normalann" name="normalann"/>#</a> Dataset: NORMAL_ANN

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_ANN_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_ANN_documentation.pdf)

#### Description
The 1981-2010 Normals comprise all climate normals using the thirty year period of temperature,
degree days, precipitation, snowfall, snow depth, wind, etc. Data is organized into hourly, daily,
monthly, seasonal and annual. This document describes the elements and layout of the Seasonal and
Annual Normals which are derived from a composite of climate records from numerous sources that
were merged and then subjected to a suite of quality assurance reviews.

#### fl_c (Completeness flag)

flags accompany every Normals value and indicate the completeness of the data record used to
compute each value, accounting for methodological differences for different product classes. There are
six flag options described generally below. Due to methodological differences, the flags are
applied somewhat differently between the temperature-based normals and the precipitation-based
normals. For the precipitation-based and hourly normals, the following flags were assigned
independently for each normals value reported based on number of years available for that individual
calculation. For temperature-based normals, strong precedence is given to the monthly normals of
maximum and minimum temperature or derived from the flags for these two variables.

* __C:__ complete (all 30 years used)
* __S:__ standard (no more than 5 years missing and no more than 3 consecutive
 years missing among the sufficiently complete years)
* __R:__ representative (observed record utilized incomplete, but value was scaled
 or based on filled values to be representative of the full period of record)
* __P:__ provisional (at least 10 years used, but not sufficiently complete to be
 labeled as standard or representative). Also used for parameter values on
 February 29 as well as for interpolated daily precipitation, snowfall, and
 snow depth percentiles.
* __Q:__ quasi-normal (at least 2 years per month, but not sufficiently complete to
 be labeled as provisional or any other higher flag code. The associated
 value was computed using a pseudonormals approach or derived from monthly
 pseudonormals.
* __Blank:__ the data value is reported as a special value (see section B under III. Additional Information
below).

__Note:__ flags Q and R aren't applicable to average number of days with different precipitation,
snowfall, and snow depth threshold exceedance; precipitation/snowfall/snow
probabilities of occurrence. Further, Q flags are not applicable for standard deviations.

### <a href="#normaldly" name="normaldly"/>#</a> Dataset: NORMAL_DLY

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_DLY_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_DLY_documentation.pdf)

#### Description
The 1981-2010 Normals comprise all climate normals using the thirty year period of temperature,
degree days, precipitation, snowfall, snow depth, wind, etc. Data is organized into hourly, daily,
monthly, seasonal and annual. This document describes the elements and layout of the Daily Normals
which are derived from a composite of climate records from numerous sources that were merged and
then subjected to a suite of quality assurance reviews.


#### fl_c (Completeness flag)

Same as NORMAL_ANN, see the description above at [Completeness flag](#completenessflag).


### <a href="#normalhly" name="normalhly"/>#</a> Dataset: NORMAL_HLY

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_HLY_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_HLY_documentation.pdf)

#### Description
The 1981-2010 Normals comprise all climate normals using the thirty year period of temperature,
degree days, precipitation, snowfall, snow depth, wind, etc. Data is organized into hourly, daily,
monthly, seasonal and annual normals. This document describes the elements and layout of the Hourly
Normals which are derived from a composite of climate records from numerous sources that were
merged and then subjected to a suite of quality assurance reviews.
The hourly normals provide a suite of descriptive statistics based on hourly observations at a few
hundred stations from across the United States and its Pacific territories. Statistics are provided as 30-
year averages, frequencies of occurrence, and percentiles for each hour and day of the year. These
products are useful in examination of the diurnal change of a particular variable.

For temperature, dew point and mean sea level pressure an average hourly value as well as a 10th and
90th percentile of hourly values is given. For heating and cooling degree hours, an average hourly value is
given using a 65 degree F base. Average hourly values are also given for heat index and wind chill. Cloud
cover statistics include percent frequency of clear, few, scattered, broken and overcast conditions. Wind
statistics include prevailing and secondary wind direction and percent frequency, average wind speed,
percentage of calm winds and mean wind vector direction and magnitude.

The statistics are computed from the ISD-lite dataset. 262 stations were selected from
the ISD-lite data, based on their completeness and membership in a list of what were known as "first
order stations." These are typically airport locations with the needed 24 hours/day observations to
make hourly normals meaningful. All stations had at least 27 of the 30 years represented.

Each hourly normal is computed on the basis of 450 possible values. This is the aggregation of the value
for a particular date and time, plus and minus 7 days, over each of 30 years. If fewer than 350 valid
values are present, the output is given as the special value 9999. No normals are computed for February
29, but data for February 29 is included in the 15 day window for leap years. The original data has been
shifted from Greenwich Mean Time to an end product in local standard time.

#### fl_c (Completeness flag)

Same as NORMAL_ANN, see the description above at [Completeness flag](#completenessflag).

### <a href="#normalmly" name="normalmly"/>#</a> Dataset: NORMAL_MLY

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_MLY_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/NORMAL_MLY_documentation.pdf)

#### Description

The 1981-2010 Normals comprise all climate normals using the thirty year period of temperature,
degree days, precipitation, snowfall, snow depth, wind, etc. Data are organized into hourly, daily,
monthly, seasonal and annual. This document describes the elements and layout of the Monthly
Normals which are derived from a composite of climate records from numerous sources that were
merged and then subjected to a suite of quality assurance reviews.

#### fl_c (Completeness flag)

Same as NORMAL_ANN, see the description above at [Completeness flag](#completenessflag).

### <a href="#preciphly" name="preciphly"/>#</a> Dataset: PRECIP_HLY

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_HLY_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_HLY_documentation.pdf)

#### Description

Hourly Precipitation Data (labeled Precipitation Hourly in Climate Data Online system) is
a database that gives time-sequenced hourly precipitation amounts for a network of
over 7000 reporting station located primarily in the United States. Data is collected from
a variety of sources including National Weather Service reporting stations, volunteer
cooperative observers, Federal Aviation Administration (FAA), utility companies, etc.

Concerning rain gages/data processing: Data from weighing rain gages, Fischer-Porter
gages, Universal rain gages and in recent years, more modern measuring equipment in
conjunction with automated recording sites, etc. have been used in this dataset over the
period. Precipitation values have been checked and edited as necessary by both
automated and manual methods. Because of some inconsistencies identified with the
earlier data (prior to 1996), historical data were reprocessed in 1997. This rehabilitated
data covered 53 million observations between 1900 and 1995. Similar quality control
checks are in place that maintain consistency between the historical and operationally
received data.

#### fl_m (Measurement flag)

__Note:__ This field is left blank when no flag is needed.

* __a:__ Begin accumulation. A data value of 99999 accompanies this flag. It indicates that the
accumulation has begun at some time during the hour.

* __A:__ End accumulation (an amount is associated with this flag). It indicates that
accumulation has ended sometime during the hour. Accumulated period indicates that
the precipitation amount is correct, but only the exact beginning and ending times are
known. A data value of 99999 occurring on the last day and hour of a month indicates
the accumulation continues into the next month.

* __, (comma):__ Used at the beginning of a data month when an accumulation is in progress
from the previous month. A data value of 99999 always accompanies this flag. This flag
is used prior to 1984.

* __{ :__ Begin deleted period during the hour (inclusive). The original data were received, but
were unreadable or clearly recognized as noise. A value of 99999 accompanies this
flag. Primarily used since 1984. Also used in Alaska for 1976-1978.

* __}:__ End deleted period during the hour (inclusive). The original data were received, but
were unreadable or clearly recognized as noise. A value of 99999 accompanies this
flag. Primarily used since 1984. Also used in Alaska for 1976-1978.

* __[:__ Begin missing period during the hour (inclusive). A value of 99999 accompanies this
flag.

* __]:__ End missing period during the hour (inclusive). A value of 99999 accompanies this
flag. Prior to 1984 if precipitation occurred during the last hour of the missing period, the
ending missing value appears with a non-zero value. Beginning in 1984, the beginning
and ending hours of the missing period are recorded as "99999[" and "99999],"
respectively.. A missing flag indicates that the data were not received. The flag appears
on the first and last day of each month for which data were not received or not
processed by NCDC.

* __E:__ Evaporation may have occurred. Data may or may not be reliable. This flag was used
during the period 1984-1993.

* __g:__ Only used for day 1, hour 0100, when precipitation amount is zero.

* __T:__ Indicates a "trace" amount. Data value with this will be zero. "T" flags appear on
National Weather Service data only since July 1996.

* __M:__ Missing data. No data available for this period.

#### fl_q (Data quality flag)

* __Z:__ Indicates probable amounts as a result of melting frozen precipitation. This flag may
be used to identify those sites that are deficient in the manner the snow shields are  employed.
Used since January 1996.
* __R:__ This data value failed one of the NCDC's quality control tests.
* __Q:__ Pre 1996 usage, Indicates value failed an extreme value test (value will be present).
Data are to be used with caution. Extreme tests used are 1) value was not an accumulated amount and was higher than
the one-hour statewide 100 year return period precipitation amount or 2) if they value
was an accumulated amount and was higher than the 24 hour statewide extreme
precipitation total.
* __Q:__ 1996 to present usage. A single erroneous value (value will be present). Rarely
used since 1996.
* __q:__ An hourly value excludes one or more 15 minute periods. Lowest data resolution is
15 minutes. Used since January 1996.


### <a href="#precip15" name="precip15"/>#</a> Dataset: PRECIP_15

__More info:__ [http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_15_documentation.pdf](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/PRECIP_15_documentation.pdf)

#### Description

15 Minute Precipitation Data (labeled Precipitation 15 Minute in Climate Data Online
system) is a database that gives time-sequenced quarter-hour precipitation amounts for
a network of over 3600 reporting station located primarily in the United States. Data is
collected from a variety of sources including National Weather Service reporting
stations, volunteer cooperative observers, Federal Aviation Administration (FAA), utility
companies, etc.

Concerning rain gages/data processing: Data from Fischer-Porter gages between May
1971 and December 1983 have been used in this dataset. Precipitation values have
been checked and edited as necessary by both automated and manual methods. Data
processing procedures were updated in January 1984 to produce the element
structured data base files and further enhanced beginning with the January 1996 data
month. Currently, interactive quality control procedures are in place that has added
many checks and features and data are subjected to automated editing procedures that
reduce the manual handling of the data.

#### fl_m (Data measurement flag)

__QPCP__

__Note:__ This field is left blank when no flag is needed.

* __a:__ Begin accumulation. A data value of 99999 accompanies this flag. It indicates that the
accumulation has begun at some time during the 15 minute period.
* __A:__ End accumulation (an amount is associated with this flag). It indicates that
accumulation has ended sometime during the 15 minute period. Accumulated period
indicates that the precipitation amount is correct, but only the exact beginning and
ending times are known. A data value of 99999 occurring on the last day and hour of a
month indicates the accumulation continues into the next month.
* __, (comma):__ Used at the beginning of a data month when an accumulation is in progress.
This flag is used prior to 1984.
* __{ :__ Begin deleted period during the hour (inclusive).
* __}:__ End deleted period during the hour (inclusive).
* __[:__ Begin missing period during the hour (inclusive).
* __]:__ End missing period during the hour (inclusive).
* __E:__ Evaporation may have occurred. Data may or may not be reliable. This flag was used
during the period 1984-1993.
* __g:__ Only used on day 1 when precipitation amount is zero.
* __T:__ Indicates a "trace" amount. Data value with this will be zero. "T" flags appear on
National Weather Service data only.
* __M:__ Missing data. No data available for this period.


__QGAG__

* __a:__ begin accumulation (indicates measurement periods overlapped)
* __A:__ end accumulation
* __[:__ begin missing
* __]:__ end missing
* __{:__ begin delete
* __}:__ end delete
* __S:__ gage reset

#### fl_q (Data quality flag)

__QPCP__

* __X:__ Used for data prior to 1996 as part of a 1997 data rehabilitation effort. Indicates value
failed an extreme value test; data are to be used with caution. Extreme tests were: 1) if
the value was not an accumulated precipitation total, the value failed the one hour
statewide 100 year return period precipitation and 2) if the value was an accumulated
precipitation total, the value failed the 24 hour statewide extreme precipitation total.
* __Z:__ Indicates probable amounts as a result of melting frozen precipitation. This flag may
be used to identify those sites that are deficient in the manner the snow shields are
employed. Used since January 1996.
* __R:__ This data value failed one of NCDC's quality control tests.
* __Q:__ A single erroneous value (value will be present). Used since January 1996.
* __q:__ An hourly value excludes one or more 15 minute periods. Lowest data resolution is
15 minutes. Used since January 1996.
* __A:__ Accumulated period and amount. An accumulated period indicates that the
precipitation amount is correct, but the exact beginning and ending times are only
known to the extent that the precipitation occurred sometime within the accumulation
period.

__QGAG__

* __Q:__ Questionable value. Data not used.
* __P:__ Punched mechanism failure, missing punch assumed. Assumed punch value being
used.
* __V:__ Evaporation likely. Gage value has dropped. Data are being used.


#### fl_u (Units flag)

HI indicates data values (QGAG or QPCP) are in hundredths of inches. HT indicates data values (QGAG or QPCP) are in tenths of inches.
