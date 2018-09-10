#' Converts A geoJSON string to a Spatial Object
#'
#' @description Converts a geoJSON string to a spatial object using the
#' readOGR function from the rgdal package.
#' @usage geojson2SPDF(geoJSONstr, ...)
#'
#' @param geoJSONstr str, a valid geoJSON string in a character vector of
#' length 1.
#' @param ... , additional parameters passed to readOGR
#'
#' @return A spatial object with class coresponding to the class of the
#' equivilent geoJSON object type.
#'
#' A spatial object with class coresponding to the class of the equivilent
#' geoJSON object type.
#'
#' @examples
#' # Make a simple polygon object
#' simplePolygon <- '{
#' "type": "Polygon",
#' "coordinates": [
#'     [
#'         [-64.73, 32.31],
#'         [-80.19, 25.76],
#'         [-66.09, 18.43],
#'         [-64.73, 32.31]
#'         ]
#'     ]
#' }'
#'
#' # transform it to spatial polygon and plot
#' sp::plot(geojson2SPDF(simplePolygon, verbose=FALSE))
#'
#' @export

geojson2SPDF <- function(geoJSONstr, ...){
    stopifnot(length(geoJSONstr) == 1)
    wgs84 <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
    objSP <- rgdal::readOGR(geoJSONstr, "OGRGeoJSON", ...)
    sp::proj4string(objSP) <- sp::CRS(wgs84)
    return(objSP)
}
