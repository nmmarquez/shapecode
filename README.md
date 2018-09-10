# shapecode
####  A package for coding a location string to `R` spatial object

The package `shapecode` allows you to quickly go from a location to an R sptial object with just a single string. Using the openstreetmaps (OSM) API this package geocodes the string and returns geojson information that is converted to spatial objects. To do so you need to make sure that the function `rgdal::ogrDrivers()` has listed `geoJSON` as `TRUE`. If that is the case you can easily get a spatial object from just a string.

```
# Get results for the
mexicoTags <- geocode("Mexico", geojson=TRUE, sp=TRUE)

# plot the first result that seems like its a polygon
firstPoly <- grep("Polygon", mexicoTags$geoJSONtype)[1]
sp::plot(mexicoTags$shape[[firstPoly]])
```
