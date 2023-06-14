get_metadata <- function(C12, S1, S2, Sec) {
  # Libraries
  library(dplyr)
  library(lubridate)
  library(rgee)
  library(rgeeExtra)
  library(sf)
  ee_Initialize()
  # Read the geojson file
  Gjson <- st_read(C12)
  name <- strsplit(S1, "/")[[1]][2]
  
  # Extract satellite name
  Sat <- paste0(substr(name, 1, 1),
                substr(name, nchar(name), nchar(name)))
  
  # Create an empty dataframe to store the results
  table_ic <- data.frame()
  
  # Iterate over the rows of CS12
  for(i in 1:nrow(Gjson)) { 
    
    # Get coordinates of the point
    Point <- ee$Geometry$Point(st_coordinates(Gjson[i,])[, 1],
                               st_coordinates(Gjson[i,])[, 2])
    
    # Get the image collection for S1 and S2
    S1IC <- ee_get_date_ic(ee$ImageCollection(S1)$
                             filterBounds(Point)) %>%
      mutate(time_start = ymd_hms(time_start))
    S2IC <- ee_get_date_ic(ee$ImageCollection(S2)$
                             filterBounds(Point)) %>%
      mutate(time_start = ymd_hms(time_start),
             Mission = Sat) %>%
      rename(MSS_id = id,
             MSS_time = time_start) %>%
      relocate(Mission, .before = 1)
    if ((nrow(S1IC) > 0) & (nrow(S2IC) > 0)) {
      for (j in 1:length(S1IC$time_start)) {
        result <- S2IC %>%
          filter(abs(MSS_time - S1IC$time_start[j]) <= seconds(Sec)) %>%
          mutate(TM_id = S1IC$id[j],
                 TM_time = S1IC$time_start[j])
        if (nrow(result) > 0) {
          table_ic <- table_ic %>%
            bind_rows(result)
        }
      }
    }
    print(i)
  }
  return(table_ic)
}

C12 <- "data/cloudsen12_db.geojson"
Sec <- 10
L41 <- "LANDSAT/LT04/C02/T2"
L42 <- "LANDSAT/LM04/C02/T2"
L51 <- "LANDSAT/LT05/C02/T2"
L52 <- "LANDSAT/LM05/C02/T2"
get_metadata(C12, L41, L42, Sec)