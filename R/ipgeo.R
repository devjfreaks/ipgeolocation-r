#' Query IPGeolocation.io IP Location API
#'
#' @param ip IP address (character)
#' @param api_key Your API key (character)
#' @param fields Optional. Character vector or comma-separated string.
#'   Supports object names (e.g., "location") and dot notation
#'   (e.g., "location.city").
#' @param excludes Optional. Character vector or comma-separated string.
#'   Supports object names and dot notation.
#' @param include Optional. Character vector or comma-separated string.
#'   Accepts module names only (no dot notation).
#'
#' @return Parsed JSON response as a list.
#' @export
#'
#' @examples
#' \dontrun{
#' ipgeo(
#'   ip = "8.8.8.8",
#'   api_key = Sys.getenv("IPGEOLOCATION_API_KEY"),
#'   fields = c("location", "location.city"),
#'   excludes = "location.zipcode",
#'   include = c("security", "hostname")
#' )
#' }
ipgeo <- function(ip,
                  api_key,
                  fields = NULL,
                  excludes = NULL,
                  include = NULL) {

  normalize_param <- function(x) {
    if (is.null(x)) return(NULL)

    if (!is.character(x)) {
      stop("Parameters must be character vectors or comma-separated strings.")
    }

    if (length(x) > 1) {
      x <- paste(x, collapse = ",")
    }

    x
  }

  if (!is.character(ip) || length(ip) != 1) {
    stop("`ip` must be a single character string.")
  }

  if (!is.character(api_key) || length(api_key) != 1) {
    stop("`api_key` must be a single character string.")
  }

  fields   <- normalize_param(fields)
  excludes <- normalize_param(excludes)
  include  <- normalize_param(include)

  # Include must NOT support dot notation
  if (!is.null(include) && grepl("\\.", include)) {
    stop("`include` does not support dot notation. Use module names only.")
  }

  req <- httr2::request("https://api.ipgeolocation.io/v3/ipgeo") |>
    httr2::req_url_query(
      apiKey = api_key,
      ip = ip,
      fields = fields,
      excludes = excludes,
      include = include
    )

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      stop("API request failed: ", conditionMessage(e))
    }
  )

  httr2::resp_body_json(resp, simplifyVector = TRUE)
}
