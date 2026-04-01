#' Query the 'IPGeolocation.io IP Location API'
#'
#' Queries the 'IPGeolocation.io IP Location API'
#' (<https://ipgeolocation.io/documentation/ip-location-api.html>)
#' to retrieve IP geolocation and related network intelligence data.
#'
#' Supports response filtering using 'fields' and 'excludes'
#' parameters (dot notation supported), and optional objects
#' using the 'include' parameter.
#'
#' @param ip A character string specifying the IP address.
#' @param api_key A character string containing your API key.
#' @param fields Optional character vector of fields to include.
#' @param excludes Optional character vector of fields to exclude.
#' @param include Optional character vector of additional objects
#'   (e.g., "security", "hostname", "geo_accuracy", "abuse",
#'   "user_agent").
#'
#' @return A list containing the parsed API response.
#'
#' @examples
#' api_key <- Sys.getenv("IPGEOLOCATION_API_KEY")
#'
#' if (nzchar(api_key)) {
#'   result <- ipgeo("8.8.8.8", api_key)
#'   str(result)
#' }
#'
#' @export
ipgeo <- function(ip,
                  api_key,
                  fields = NULL,
                  excludes = NULL,
                  include = NULL) {

  if (!is.character(ip)) {
    stop("`ip` must be a character string.", call. = FALSE)
  }

  if (!is.character(api_key) || !nzchar(api_key)) {
    stop("A valid `api_key` must be provided.", call. = FALSE)
  }

  base_url <- "https://api.ipgeolocation.io/ipgeo"

  req <- httr2::request(base_url) |>
    httr2::req_url_query(
      apiKey = api_key,
      ip = ip
    )

  if (!is.null(fields)) {
    req <- httr2::req_url_query(req, fields = paste(fields, collapse = ","))
  }

  if (!is.null(excludes)) {
    req <- httr2::req_url_query(req, excludes = paste(excludes, collapse = ","))
  }

  if (!is.null(include)) {
    if (any(grepl("\\.", include))) {
      stop("`include` does not support dot notation.", call. = FALSE)
    }
    req <- httr2::req_url_query(req, include = paste(include, collapse = ","))
  }

  resp <- httr2::req_perform(req)

  if (httr2::resp_status(resp) >= 400) {
    stop("API request failed.", call. = FALSE)
  }

  httr2::resp_body_json(resp)
}
