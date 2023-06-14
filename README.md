# get_metadata :telescope:

The `get_metadata` function retrieves satellite metadata from different sensors and filters the images captured at the same moment. 🛰️

## Description :memo:

The function uses Earth Engine API and the R packages `rgee`, `dplyr`, `lubridate`, and `sf` to extract metadata for satellite images. It takes a geojson file with points of interest, satellite collection names, and a time threshold in seconds.

## Usage :computer:

```R
# Usage example
C12 <- "data/cloudsen12_db.geojson"
Sec <- 10
L41 <- "LANDSAT/LT04/C02/T2"
L42 <- "LANDSAT/LM04/C02/T2"
get_metadata(C12, L41, L42, Sec)
```

## Dependencies :package:

Make sure to install the required R packages:

- `dplyr` :bar_chart:
- `lubridate` :calendar:
- `rgee` :earth_americas:
- `sf` :world_map:

## How to Contribute :raised_hands:

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## Acknowledgements :clap:

This function utilizes the capabilities of the `rgee` package, which provides an interface to Google Earth Engine.

Happy satellite metadata extraction! :rocket:
