using HTTP
using JSON3
using Plots

# Specify API request
api_base = "https://www.ncei.noaa.gov/access/paleo-search/study/search.json?"
req_params = "dataPublisher=NOAA&dataTypeId=17&cvWhats=chemical%20composition%3Eelement%20or%20compound%20ratio%3Emagnesium%2Fcalcium&limit=10"
req_str = api_base * req_params

lats = Float64[]  # Initialize empty vector to store latitudes

# Retrieve search results from API
while !isempty(req_str)
    speleos = HTTP.get(req_str)
    json_data = JSON3.read(speleos.body)

    # Extract latitudes
    numstudies = length(json_data["study"])
    study_list = json_data["study"]
    for i in 1:numstudies
        numsites = length(study_list[i]["site"])
        for j in 1:numsites
            # Extract latitude, convert to float, and append to vector
            lat_value = study_list[i]["site"][j]["geo"]["geometry"]["coordinates"][1]
            push!(lats, float(lat_value))
        end
    end

    req_str = get(json_data["page"][1], "next", "")
end

# Plot histogram of study latitudes
histogram(lats, bins=20, xlims=(-40, 60), title="Distribution of datasets by latitude", xlabel="Latitude", ylabel="Frequency")