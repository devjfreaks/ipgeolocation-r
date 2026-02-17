# ipgeolocation

R client for the [IPGeolocation.io IP Location API](https://ipgeolocation.io/documentation/ip-location-api.html).
This package provides a minimal interface to query the IPGeolocation.io IP
Location API from R.

## Installation

Until published on CRAN:

```r
# install.packages("remotes")
remotes::install_github("ipgeolocation/ipgeolocation-r")
```

Once available on CRAN:

```r
install.packages("ipgeolocation")
```

## API Key

An API key is required. You can obtain one from <https://ipgeolocation.io/>.

It is recommended to store the API key in an environment variable:

```r
Sys.setenv(IPGEOLOCATION_API_KEY = "YOUR_API_KEY")
api_key <- Sys.getenv("IPGEOLOCATION_API_KEY")
```

## Basic Usage

```r
library(ipgeolocation)

result <- ipgeo(
  ip      = "8.8.8.8",
  api_key = api_key
)

str(result)
```

## Selecting Specific Fields (`fields`)

The `fields` parameter allows you to return only selected objects or nested
fields. It supports:

- Entire objects (e.g., `"location"`)
- Nested fields using dot notation (e.g., `"location.city"`)

You may provide either a character vector or a comma-separated string.

```r
# Entire object
ipgeo(ip = "8.8.8.8", api_key = api_key,
      fields = "location")

# Nested field
ipgeo(ip = "8.8.8.8", api_key = api_key,
      fields = "location.city")

# Multiple fields
ipgeo(ip = "8.8.8.8", api_key = api_key,
      fields = c("location", "location.city"))

# Comma-separated string
ipgeo(ip = "8.8.8.8", api_key = api_key,
      fields = "location,security")
```

## Excluding Fields (`excludes`)

The `excludes` parameter removes specific objects or nested fields from the
default response. It supports entire objects and dot notation for nested fields.

```r
# Exclude entire object
ipgeo(ip = "8.8.8.8", api_key = api_key,
      excludes = "security")

# Exclude nested field
ipgeo(ip = "8.8.8.8", api_key = api_key,
      excludes = "location.zipcode")

# Multiple exclusions
ipgeo(ip = "8.8.8.8", api_key = api_key,
      excludes = c("location.zipcode", "continent_code"))
```

## Including Additional Modules (`include`)

The `include` parameter requests additional modules not part of the default
response. Supported module names are `"hostname"`, `"security"`,
`"dma_code"`, `"abuse"`, `"geo_accuracy"`, and `"user_agent"`.

> **Note:** Dot notation is not supported for `include`. Comma-separated values and character vectors are accepted. Availability depends on your API plan.

```r
ipgeo(
  ip      = "8.8.8.8",
  api_key = api_key,
  include = "security"
)

ipgeo(
  ip      = "8.8.8.8",
  api_key = api_key,
  include = c("security", "hostname")
)
```

## Combining Parameters

`fields`, `excludes`, and `include` can be used together:

```r
ipgeo(
  ip      = "8.8.8.8",
  api_key = api_key,
  fields  = c("location", "location.city"),
  excludes = "location.zipcode",
  include  = "security"
)
```

## Error Handling

The function validates parameter types, normalizes vectors to comma-separated
strings, fails gracefully if the API is unreachable, and returns parsed JSON
as an R list.

## Function Reference

### `ipgeo()`

| Argument  | Type      | Description                                          |
|-----------|-----------|------------------------------------------------------|
| `ip`      | character | IP address to look up                                |
| `api_key` | character | Your IPGeolocation.io API key                        |
| `fields`  | character | Optional object names or nested fields to return     |
| `excludes`| character | Optional object names or nested fields to exclude    |
| `include` | character | Optional additional modules: `hostname`, `security`, `dma_code`, `abuse`, `geo_accuracy`, `user_agent` (dot notation not supported; comma-separated values accepted) |

**Returns:** A list parsed from the JSON API response.

## License

MIT
