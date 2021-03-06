#' Set API key and API URL for Santiment GraphQL queries.
#'
#' Note that setting API key and API URL is optional. Without them queries will default to a free Santiment account.
#'
#' @param key API key
#' @param url GraphQL server URL
#'
#' @examples
#' setSantimentVariables("y4i3n5xk6p")
#'
#' @export
setSantimentVariables <- function(key, url = "https://api.santiment.net/graphql")
{
  # set API key
  Sys.setenv(SANTIMENT_API_KEY = key)

  # set API URL
  Sys.setenv(SANTIMENT_API_URL = url)
}

#' Execute Santiment query.
#'
#' A new GraphQL client is generated. A new query is generated, filled with the query string and (optional) variables, and then executed.
#' 
#' @param query_string query string
#' @param query_variables optional list of query variables
#'
#' @return query result
#'
#' @examples
#' santimentQuery('{projectBySlug(slug: "ethereum") {availableQueries}}')
#'
#' string <- 'query MyQuery($slug: String = \"bitcoin\")
#'            {projectBySlug(slug: $slug) {availableQueries}}'
#' variables <- list(slug = 'ethereum')
#' santimentQuery(string, variables)
#'
#' @import ghql jsonlite tidyr
#' @export
santimentQuery <- function(query_string, query_variables)
{
  # use API URL if set
  if (Sys.getenv("SANTIMENT_API_URL")=="")
  {
    url_ = "https://api.santiment.net/graphql"
  }
  else
  {
    url_ = Sys.getenv("SANTIMENT_API_URL")
  }
  
  # use API key if set
  if (Sys.getenv("SANTIMENT_API_KEY")=="")
  {
    headers_ = list()
  }
  else
  {
    headers_ = list(Authorization = paste0("Apikey ", Sys.getenv("SANTIMENT_API_KEY")))
  }
  
  # new client
  client <- GraphqlClient$new(
    url = url_,
    headers = headers_
  )
  
  # new query
  query <- Query$new()
  query$query('myquery', query_string)
  
  # execute query
  if (missing(query_variables))
  {
    result <- client$exec(query$queries$myquery) %>% fromJSON()
  }
  else
  {
    result <- client$exec(query$queries$myquery, query_variables) %>% fromJSON()
  }
  
  return(result)
}

#' Get the available Santiment metrics for a specific project.
#'
#' Returns all availabale timeseries metrics (note not the histogram metrics) for a slug.
#'
#' @param slug project
#'
#' @return vector of available metrics
#'
#' @examples
#' availableMetrics('ethereum')
#'
#' @export
availableMetrics <- function(slug)
{
  result <- santimentQuery('query MyQuery($slug: String = \"bitcoin\") {
    all_metrics_for_a_slug: projectBySlug(slug: $slug) {
      availableTimeseriesMetrics
    }
  }', list(slug = slug))
  data <- result$data$all_metrics_for_a_slug$availableTimeseriesMetrics
  
  return(data)
}

#' Get the available slugs for a specific metric
#'
#' @param metric Santiment metric
#'
#' @return vector of available slugs
#'
#' @examples
#' availableSlugs('daily_active_addresses')
#'
#' @export
availableSlugs <- function(metric)
{
  result <- santimentQuery('query MyQuery($metric: String = \"daily_active_addresses\") {
    getMetric(metric: $metric) {
      metadata{
        availableSlugs
      }
    }
  }', list(metric = metric))
  
  data <- result$data$getMetric$metadata$availableSlugs
  
  return(data)
}

#' Get the earliest date for which the Santiment metric is available.
#'
#' @param metric metric
#' @param slug project
#'
#' @return earliest date
#'
#' @examples
#' availableSince('daily_active_addresses', 'ethereum')
#'
#' @export
availableSince <- function(metric, slug)
{
  result <- santimentQuery('query MyQuery($metric: String = \"daily_active_addresses\", $slug: String = \"ethereum\") {
    getMetric(metric: $metric) {
      availableSince(slug: $slug)
    }
  }', list(metric = metric, slug = slug))
  available.since <- result$data$getMetric$availableSince
  available.since <- substr(available.since, 1, 10)
  
  return(available.since)
}

#' Get access restrictions for a specific Santiment metric or query.
#'
#' @param name name of Santiment metric or query
#'
#' @return single row with columns (isRestricted, name, restrictedFrom, restrictedTo, type)
#'
#' @examples
#' accessRestrictions('daily_active_addresses')
#'
#' @export
accessRestrictions <- function(name)
{
  result <- santimentQuery('{
    getAccessRestrictions{
      name
      type
      isRestricted
      restrictedFrom
      restrictedTo
    }
  }')
  data <- result$data$getAccessRestrictions
  
  data <- data[which(data$name == name),]
  data$restrictedFrom <- substr(data$restrictedFrom, 1, 10)
  data$restrictedTo <- substr(data$restrictedTo, 1, 10)
  
  return(data)
}

#' Get a metric from the Santiment GraphQL API.
#'
#' Checks if the metric is available for the slug. If not, a constant vector is returned.
#' Checks if the metric is available for this time window. For unavailable dates, zeros are returned.
#'
#' https://neuro.santiment.net
#' https://graphql.org
#'
#' @param metric Santiment metric
#' @param slug project (e.g. ethereum, bitcoin, tezos ...)
#' @param from start of the time window
#' @param to end of the time window
#' @param aggregation aggregation (SUM, AVG, MEDIAN, MIN, MAX, FIRST, LAST)
#' @param selector_option optional string for selector field, for example "holdersCount:10" for "amount_in_top_holders" metric, see "selector: {slug: "ethereum", holdersCount:10}"
#'
#' @return table with columns (date, <metric>)
#'
#' @examples
#' santimentMetric('dev_activity', 'ethereum')
#'
#' @export
santimentMetric <- function(metric, slug, from = '2019-01-01', to = '2020-01-01', aggregation = 'SUM', selector_option)
{
  # Check if the metric is available for this project.
  # If not, return a zero vector.
  available.slugs <- availableSlugs(metric)
  if (!(slug %in% available.slugs))
  {
    dates <- seq(as.Date(from), as.Date(to), by=1)
    data <- data.frame(dates, 0)
    colnames(data) <- c('date', metric)
    
    return(data)
  }
  
  # correct time window
  from_ <- from
  to_ <- to
  
  # get the earliest date for the metric
  available.since <- availableSince(metric, slug)
  from_ <- as.character(max(as.Date(available.since), as.Date(from_)))
  
  # check access restrictions
  restrictions <- accessRestrictions(metric)
  if (restrictions$isRestricted)
  {
    from_ <- as.character(max(as.Date(restrictions$restrictedFrom), as.Date(from_)))
    to_ <- as.character(min(as.Date(restrictions$restrictedTo), as.Date(to_)))
  }
  
  # correct aggregation
  # TODO: check with availableAggregations
  if (metric == 'amount_in_top_holders')
  {
    aggregation <- 'LAST'
  }
  
  # set optional selector parameters
  if (missing(selector_option))
  {
    selector_option_ = ""
  }
  else
  {
    selector_option_ = paste0(", ", selector_option)
  }
  
  # generate query string
  query_string <- paste0('query MyQuery($metric: String = \"daily_active_addresses\", $slug: String = \"bitcoin\", $from: String = \"2019-01-01T00:00:00Z\", $to: String = \"2020-01-01T23:59:59Z\", $aggregation: String = \"NULL\") {
    getMetric(metric: $metric) {
      timeseriesData(
        selector: {slug: $slug', selector_option_, '}
        from: $from
        to: $to
        interval:"1d"
        aggregation: $aggregation) {
          datetime
          value
        }
      }
    }')
  
  # for huge queries (prior 2013) run two separate queries and combine
  # avoids complexity error https://github.com/santiment/san-sdk/issues/18
  if (as.Date(from_) < as.Date('2013-01-01'))
  {
    result <- santimentQuery(query_string, list(metric = metric, slug = slug, from = paste0(from_, "T00:00:00Z"), to = "2012-12-31T23:59:59Z", aggregation = aggregation))
    data.1 <- result$data$getMetric$timeseriesData
    
    result <- santimentQuery(query_string, list(metric = metric, slug = slug, from = "2013-01-01T00:00:00Z", to = paste0(to_, "T23:59:59Z"), aggregation = aggregation))
    data.2 <- result$data$getMetric$timeseriesData
    
    data <- rbind(data.1, data.2)
  }
  else
  {
    result <- santimentQuery(query_string, list(metric = metric, slug = slug, from = paste0(from_, "T00:00:00Z"), to = paste0(to_, "T23:59:59Z"), aggregation = aggregation))
    data <- result$data$getMetric$timeseriesData
  }
  
  # date only, remove time
  data$datetime <- as.Date(substr(data$datetime, 1, 10))
  
  # fill in zero rows for dates which are missing in the API call
  dates <- seq(as.Date(from), as.Date(to), by=1)
  idx <- match(data$datetime, dates)
  data.temp <- data.frame(dates, 0)
  colnames(data.temp) <- c('datetime', 'value')
  data.temp$value[idx] <- data$value
  data <- data.temp
  
  colnames(data) <- c('date', metric)
  
  return(data)
}

