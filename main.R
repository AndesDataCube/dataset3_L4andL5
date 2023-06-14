# /*
# MIT License
#
# Copyright (c) [2023] [AndesDataCube team]
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


# R packages
library(rgee)
library(sf)
source("utils.R")

# Initialize EE
ee_Initialize()


# Load initial dataset
metadata <- read_sf("data/cloudsen12_metadata.geojson")

# Create metadata table L4 MSS/TM
container <- list()
for (index in 1:nrow(metadata)) {
    print(index)
    coordinate <- metadata[index,]
    container[[index]] <- get_metadata(
        sensorMSS = "LANDSAT/LT04/C02/T2",
        sensorTM = "LANDSAT/LM04/C02/ ",
        timediff = 10,
        point = coordinate
    )
}
metadata_L4 <- do.call(rbind, container)



# Create metadata table L5 MSS/TM
container <- list()
for (index in 1:nrow(metadata)) {
    print(index)
    coordinate <- metadata[index,]
    container[[index]] <- get_metadata(
        sensorMSS = "LANDSAT/LT05/C02/T2",
        sensorTM = "LANDSAT/LM05/C02/T2",
        timediff = 10,
        point = coordinate
    )
}
metadata_L5 <- do.call(rbind, container)
