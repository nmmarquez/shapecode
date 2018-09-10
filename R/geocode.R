#' Geocode a string using the openstreet maps API
#'
#' @description Geocodes a string using the OSM API. Has the ability to return
#' additional information such as the geoJSON string and converting the geojson
#' string to a spatial object.
#' @usage geocode(x, geojson=T, sp=F, verbose=F, ...)
#'
#' @param x str, a location name to geocode in the form of a character vector of
#' length 1.
#' @param geojson bool, should the geoJSON information also be retrieved
#' @param sp bool, should the geoJSON data be converted to spatial objects
#' @param verbose bool, verbose argument passed to readOGR
#' @param ... additional parameters passed to readOGR
#'
#' @return A dataframe with the reults from the OSM geotag call.
#'
#' A dataframe with the results from the OSM geotag call. This dataframe may
#' include lists of coordinates and spatial objects depending on the parameters
#' specified
#'
#' @examples
#' # Get results for the
#' mexicoTags <- geocode("Mexico", geojson=TRUE, sp=TRUE)
#'
#' # plot the first result that seems like its a polygon
#' firstPoly <- grep("Polygon", mexicoTags$geoJSONtype)[1]
#' sp::plot(mexicoTags$shape[[firstPoly]])
#'
#' @export

geocode <- function(x, geojson=T, sp=F, verbose=F, ...){
    stopifnot(length(x) == 1)
    gs <- ifelse(geojson | sp, "&polygon_geojson=1", "")
    call_ <- utils::URLencode(paste0(
        "https://nominatim.openstreetmap.org/search.php?q=",
        gsub(" |,|  |#", " ", x),
        "&format=json",
        gs))
    result <- jsonlite::fromJSON(call_, ...)
    if(geojson | sp){
        result$geoJSONtype <- result$geojson$type
        result$geoJSONcoordinates <- result$geojson$coordinates
        result$geoJSONstr <- sapply(1:nrow(result$geojson), function(i){
            geoJSONraw <- as.character(jsonlite::toJSON(result$geojson[i,]))
            substr(geoJSONraw, 2, nchar(geoJSONraw)-1)
        })
        result$geojson <- NULL
    }
    if(sp){
        result$shape <- lapply(1:nrow(result), function(i){
            geojson2SPDF(result$geoJSONstr[i], verbose)
        })
        if(!geojson){
            result$geoJSONtype <- NULL
            result$geoJSONcoordinates <- NULL
            result$geoJSONstr <- NULL
        }
    }
    result
}

