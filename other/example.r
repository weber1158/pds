##
## Demonstrate use of WDS-Paleo API in a programmatic search, access, and analysis workflow
## Search via API for sites meeting criteria, extract site latitudes from returned metadata,
## plot latitudes in histogram
##
## Example from: https://www.ncei.noaa.gov/access/paleo-search/api#examples 
##
 
library(jsonlite)
 
## Search via API for speleothem (dataTypeId=17) studies with magnesium/calcium data,
## retrieving "pages" of 10 studies at a time (limit=10). Setting this limit is a best
## practice to avoid overwhelming the API with large requests. Results are returned in
## JSON format as a list called "json_data." Note that when searching via the user
## interface at: ncei.noaa.gov/access/paleo-search/, the API call used to retrieve
## the results is displayed immediately above the search results and can be used to
## generate search strings ("req_str") relevant to your use case.
 
## specify API request
api_base = "https://www.ncei.noaa.gov/access/paleo-search/study/search.json?"
req_params = "dataPublisher=NOAA&dataTypeId=17&cvWhats=chemical%20composition%3Eelement%20or%20compound%20ratio%3Emagnesium%2Fcalcium&limit=10"
req_str = paste(api_base, req_params, sep="")
 
lats=c()                                                # initialize empty vector to store latitudes
 
## retrieve search results from API
while (!is.null(req_str)) {                             # loop through search results one page at a time
  json_data = jsonlite::fromJSON(req_str)               # load JSON-formatted search results
 
  ## extract latitudes
  numstudies = nrow(json_data$study)                    # count number of returned studies
  if (is.null(numstudies)) break                        # end while loop if no studies returned
  for (i in 1:numstudies) {                             # loop through studies
    numsites=nrow(json_data$study$site[[1]])            # count number of sites in the study
    for (j in 1:numsites) {                             # loop through sites within the study
      # extract latitude, convert to numeric, and append to vector
      lats = append(lats,as.numeric(json_data$study$site[[i]]$geo$geometry$coordinates[[j]][1]))
    }
  }
  req_str = json_data$page$'next'                       # specify API request for next page of studies
}
 
## plot histogram of study latitudes
hist(lats, main="Distribution of datasets by latitude", xlab="Latitude", breaks=10)