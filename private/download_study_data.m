function download_study_data(JSON)
%Downloads paleodata using information from JSON

%=========================================================================%
%Begin main function
%=========================================================================%
num_studies = length(JSON.study);
  for num = 1:num_studies
    loop_through_sites(JSON,num)
  end
end

%=========================================================================%
% Begin local functions
%=========================================================================%
function loop_through_sites(JSON,study_num)
    num_sites = length(JSON.study(study_num).site);
    for site = 1:num_sites
        loop_through_datasets(JSON,study_num,site)
    end
end

function loop_through_datasets(JSON,study_num,site_num)
   num_datasets = length(JSON.study(study_num).site(site_num).paleoData);
   for dataset = 1:num_datasets
    save_JSON_data(JSON,study_num,site_num,dataset)
   end
end

function save_JSON_data(JSON,study_num,site_num,dataset_num)
   %Get data file URL
   fileURL = JSON.study(study_num).site(site_num).paleoData(dataset_num).dataFile.fileUrl;
   %Get data table name
   dataTableName = JSON.study(study_num).site(site_num).paleoData(dataset_num).dataTableName;
   %Save the data
   filePath=websave(strrep([dataTableName '.txt'],' ',''),fileURL);
   %Print path
   fprintf('File saved on the following path: ''%s''\n',filePath)
end