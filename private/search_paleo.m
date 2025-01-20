function [JSON,API] = search_paleo(dataTypeId,varargin)
%Returns json file for search queries
%
%Inputs
% dataTypeId :: (scalar or vector) data type ID numbers
%
%Outputs
% JSON :: (struct) json-formatted search results
% API :: (string) the API search string

% Define dataTypeId query string
if isscalar(dataTypeId)
 dataTypeId = num2str(dataTypeId);
else
 id_link = '%7C';
 all_dataTypeIds = strsplit(num2str(dataTypeId));
 dataTypeId = all_dataTypeIds{1};
 for id = 2:length(all_dataTypeIds)
   dataTypeId = [dataTypeId id_link all_dataTypeIds{id}];
 end
end

% Stable API string
api_base = 'https://www.ncei.noaa.gov/access/paleo-search/study/search.json?';
api_required_parameters = 'dataPublisher=NOAA&dataTypeId=';

% Add queries to API search string
API = [api_base api_required_parameters dataTypeId];

% Get JSON file
options = weboptions('Timeout', 25);
JSON = webread(API,options);

end