function investigators = get_Investigators(dataTypeId)
%Investigator list for a NOAA data type
%
%Syntax
% investigators = getInvestigators(dataTypeId)
%
%Inputs
% dataTypeId {Int} :: ID number for a NOAA data type. E.g., ice cores = 7
%
%Outputs
% investigators {Cell} :: List of investigators
%
%Example
% dt = getDataTypeId();
% investigators = getInvestigators(dt.IceCores);
%
%See also
% get_dataTypeId

arguments
  dataTypeId {mustBePositive, mustBeInteger}
end

% Define base API link
base_api = 'https://www.ncei.noaa.gov/access/paleo-search/study/params.json';

% Get the parameters JSON file
options = weboptions('Timeout', 25);
JSON = webread(base_api,options);

% Convert dataTypeId to string
x = "x";
id_Str = string(dataTypeId);
id_Str = x+id_Str;

% Extract investigators list
investigators = JSON.investigators.NOAA.(id_Str);

end