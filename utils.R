library(lubridate)
library(rgeeExtra)
library(dplyr)
library(rgee)
library(sf)

check_01 <- function(df) {
    if (nrow(df) == 0) {
        TRUE
    } else {
        FALSE
    }
}

get_metadata <- function(sensorMSS, sensorTM, timediff, point) {
    # Extract the name of the sensor
    sensor_id <- gsub(".*/(.*)/.*/.*", "\\1", sensorMSS)
    if (sensor_id == "LM05") {
        sensor_name <- "L5"
    } else if (sensor_id == "LM04") {
        sensor_name <- "L4"
    }

    # From local to EE server
    ee_point <- sf_as_ee(point$geometry)

    # Get the dates of the MSS image
    mss_ic <- ee$ImageCollection(sensorMSS) %>%
        ee$ImageCollection$filterBounds(ee_point) %>%
        ee_get_date_ic()

    # Check if there is any image in the collection
    if (check_01(mss_ic)) {
       return(NULL)
    }

    # Get the dates of the TM images
    tm_ic <- ee$ImageCollection(sensorTM) %>%
        ee$ImageCollection$filterBounds(ee_point) %>%
        ee_get_date_ic()

    # Check if there is any image in the collection
    if (check_01(tm_ic)) {
        return(NULL)
    }

    # Get the images on the same time interval (timediff)
    r_collocation <- sapply(
        X = tm_ic$time_start,
        FUN = function(x) {
            vresults <- abs(as.numeric(mss_ic$time_start - x, units = "secs"))
            c(min(vresults), which.min(vresults))
        } 
    )
    r_difftime <- r_collocation[1,]
    idx_mss <- r_collocation[2,]
    
    # Check if the images are on the time interval (timediff)
    if (sum(r_difftime < timediff) == 0) {
        return(NULL)
    }

    # Create the final dataset
    final_tm_ic <- tm_ic[r_difftime < timediff, ]
    final_mss_ic <- mss_ic[idx_mss[r_difftime < timediff], ]
        
    data.frame(
        mission = sensor_name,
        mss_id = final_mss_ic$id,
        tm_id = final_tm_ic$id,
        roi_id = point$roi_id
    )
}

