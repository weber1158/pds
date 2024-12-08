#!/usr/bin/env python
##
## Demonstrate use of WDS-Paleo API in a programmatic search, access, and analysis workflow
## Search via API for sites meeting criteria, extract site latitudes from returned metadata,
## plot latitudes in histogram
##
## Example from: https://www.ncei.noaa.gov/access/paleo-search/api#examples
##
import matplotlib.pyplot as plt
import numpy as np
import json
import requests
 
## Search via API for speleothem (dataTypeId=17) studies with magnesium/calcium data,
## retrieving "pages" of 10 studies at a time (limit=10). Setting this limit is a best
## practice to avoid overwhelming the API with large requests. Results are returned in
## JSON format as a dictionary called "json_data." Note that when searching via the user
## interface at: ncei.noaa.gov/access/paleo-search/, the API call used to retrieve
## the results is displayed immediately above the search results and can be used to
## generate search strings ("req_str") relevant to your use case.
 
## specify API request
api_base = "https://www.ncei.noaa.gov/access/paleo-search/study/search.json?"
req_params ="dataPublisher=NOAA&dataTypeId=17&cvWhats=chemical%20composition%3Eelement%20or%20compound%20ratio%3Emagnesium%2Fcalcium&limit=10"
req_str = api_base + req_params
 
lats = []                                              # initialize empty vector to store latitudes
 
## retrieve search results from API
while req_str:                                         # loop through search results one page at a time
  speleos = requests.get(req_str)
  json_data = json.loads(speleos.text)                 # load JSON-formatted search results
 
  ## extract latitudes
  numstudies = len(json_data['study'])                 # count number of studies returned
  study_list = json_data['study']                      # extract list of studies returned
  for i in range(numstudies):                          # loop through studies
    numsites = len(study_list[i]['site'])              # count number of sites in the study
    for j in range(numsites):                          # loop through sites within the study
      # extract latitude, convert to float, and append to vector
      lat_value = json_data['study'][i]['site'][j]['geo']['geometry']['coordinates'][0]
      lats.append(float(lat_value))
 
  req_str = json_data['page'][0]['next']               # specify API request for next page of studies
np_lats = np.array(lats)                               # convert list to numpy array required for histogram
 
## plot histogram of study latitudes
fig = plt.figure(figsize=(10,7))
ax = fig.add_subplot(1, 1, 1, title="Distribution of datasets by latitude", xlabel="Latitude", ylabel="Frequency")
ax.hist(np_lats,range=[-40,60])
plt.show()