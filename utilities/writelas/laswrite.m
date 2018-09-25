function laswrite(fname,xyz,intensity,t,rgb)
%% Initialize and Empty lasobj using lasdata
lasobj = lasdata(fname,'createemptyobj');

%% Set header parameters
lasobj.header.source_id                  = 0;
lasobj.header.global_encoding            = 0;
lasobj.header.project_id_guid1           = 0;
lasobj.header.project_id_guid2           = 0;
lasobj.header.project_id_guid3           = 0;
lasobj.header.project_id_guid4           = zeros(8,1);
lasobj.header.version_major              = 1;
lasobj.header.version_minor              = 2;
lasobj.header.system_identifier          = ' MATLAB(WRITELAS.M V0)          ';
lasobj.header.generating_software        = ' MATLAB(WRITELAS.M V0)          ';
lasobj.header.file_creation_daobj.y      = 0;
lasobj.header.file_creation_year         = 0;
lasobj.header.header_size                = 227;
lasobj.header.offset_to_point_data       = 227;
lasobj.header.number_of_variable_records = 0;
lasobj.header.point_data_format          = 2;
lasobj.header.point_data_record_length   = 26;
lasobj.header.number_of_point_records    = size(xyz,1);
lasobj.header.number_of_points_by_return = [size(xyz,1) 0 0 0 0];
lasobj.header.scale_factor_x             = 0.001;
lasobj.header.scale_factor_y             = 0.001;
lasobj.header.scale_factor_z             = 0.001;
lasobj.header.x_offset                   = round(mean(xyz(:,1)),100);
lasobj.header.y_offset                   = round(mean(xyz(:,2)),100);
lasobj.header.z_offset                   = round(mean(xyz(:,3)),100);
lasobj.header.max_x                      = max(xyz(:,1));
lasobj.header.min_x                      = min(xyz(:,1));
lasobj.header.max_y                      = max(xyz(:,2));
lasobj.header.min_y                      = min(xyz(:,2));
lasobj.header.max_z                      = max(xyz(:,3));
lasobj.header.min_z                      = min(xyz(:,3));

lasobj.header.filename                   = fname;

%% Add xyz data
lasobj.x = xyz(:,1);
lasobj.y = xyz(:,2);
lasobj.z = xyz(:,3);
if exist('intensity','var')
    lasobj.intensity = intensity;
end
if exist('t','var')
    lasobj.gps_time = t;
end
if exist('rgb','var')
    lasobj.red = rgb(:,1);
    lasobj.green = rgb(:,2);
    lasobj.blue = rgb(:,3);
end
%% Save LAS file
write_las_2(lasobj, fname);

end