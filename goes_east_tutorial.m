%% Reading and Visualizing NetCDF data from GOES
% Matlab contains functions that makes it easy to read and visualize
% geospatial data. In this script we will look at two functions that can be
% used to interact with NetCDF's and ways we can visualize the data in
% them.

%% NetCDF Functions
% For the GOES data, there will always at least be 2 NetCDF files that you
% must work with. The first one is the file with the Latitude and Longitude
% coordinates, and the second one is the NetCDF with the LST data.

%%
% First we will use a function for reading any NetCDF file.
% Here 'ncread' is given the filename and the variable of interest. Here we
% load the Latitude and Longitude into our MATLAB workspace.

Lat = ncread('sample_CONUS_data.nc', 'Latitude');
Lon = ncread('sample_CONUS_data.nc', 'Longitude');

%%
% We will also use the same function to read the GOES Land Surface
% Temperature (LST) data. 
GOES_LST = ncread('sample_LST_data.nc','LST');

%% 
% The function 'ncdisp' can be used to look at the metadata for the GOES
% data. This may be useful if you are interested in the particular 'Attributes'
% like units, the full name of a variable, how the variable handles missing
% data, etc.

ncdisp('sample_LST_data.nc');

%%
% The call to ncdisp has been suppressed because a lot of information is
% displayed. Below is image of the first few lines of output of the call
% to ncdisp.

%%
% If you take a look at your workspace you will notice that all 3 variables
% are the same size.

%%
% Double-clicking on these variables will show you the contents of each
% variable. Below is image of the GOES LST data. Here I have scrolled to
% a region in the matrix where there is both NaN ("Not a number", ie.
% missing data) and LST values.

%% Visualizing GOES LST Data
% Here we show you two simple methods for quickly visualizing GOES LST
% data. One method uses the default MATLAB function and the other uses the
% Mapping Toolbox. Most of the names of functions in the Mapping Toolbox 
% are have the same name as the functions from the default MATLAB with an
% 'm' appended to it. 

%% 
% Here we will use the 'pcolor' function to visualize the data. This
% creates a checkerboard-like image for the data.
figure(1)
pcolor(Lon, Lat, GOES_LST)
shading flat
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)') % Add the axis for the LST data
title("GOES-East Land Surface Temperature")

%%
% Using the MATLAB Mapping toolbox we can use aadditional functions that
% can interpret the spatial coordinates more readily.
figure(2)
worldmap([min(min(Lat)) max(max(Lat))], [min(min(Lon)) max(max(Lon))])
pcolorm(Lat, Lon, GOES_LST) % different order than the default 'pcolor'
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)')
title("GOES-East LST: Entire Range")

%% 
% The 'worldmap' function sets the limits of the bounding box that will
% encompass the region we are looking at. The inputs used here are the
% minimum and maximum for the latitude and the longitude, respectively.

%%
% You can specify the two extreme corners for your region of interest.
% Below is the code to visualize the same data as before but only for
% Texas.
figure(3)
worldmap([25.32, 37.93], [-109.06, -92.6])
pcolorm(Lat, Lon, GOES_LST)
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)')
title("GOES-East LST: Texas")

%%
% We can do the same thing for New York.
figure(4)
IN = ingeoquad(Lat, Lon, [38.59, 42.28], [-77.56, -70.96]);
% worldmap([35.35, 46.53], [-82.51, -66.06])
worldmap([38.59, 42.28], [-77.56, -70.96])
pcolorm(Lat, Lon, GOES_LST(IN))
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)')
title("GOES-East LST: New York")

%% Adding A Shapefile
% We can also use the Mapping Toolbox to add a shapefile delineating the
% borders between states. We can read a shapefile using 'shaperead' and
% then show it with 'geoshow'. Here we have downloaded a shapefile from 
% https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
land = shaperead('shapefiles\cb_2017_us_state_20m.shp', 'UseGeoCoords', true, 'BoundingBox', [-109.06, 25.32; -92.6, 37.93]);

figure(5)
worldmap([25.32, 37.93], [-109.06, -92.6])
pcolorm(Lat, Lon, GOES_LST)
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)')
geoshow(land, 'DisplayType', 'polygon', 'FaceColor', 'none');
title("GOES-East LST: Texas")

figure(6)
worldmap([40.34, 40.90], [-74.49, -73.4])
%land = shaperead('shapefiles\cb_2017_us_state_20m.shp', 'UseGeoCoords', true, 'BoundingBox', [-82.51, 35.35; -66.06, 46.53]);
land = shaperead('C:\Users\melev\Desktop\FORCE\Maps\dtl_counties_NewYorkState.shp', 'UseGeoCoords', true, 'BoundingBox', [-82.51, 35.35; -66.06, 46.53]);
pcolorm(Lat, Lon, GOES_LST)
h = colorbar; set(get(h, 'label'), 'string', 'LST (K)')
geoshow(land, 'DisplayType', 'polygon', 'FaceColor', 'none');
title("GOES-East LST: New York")

%%
% There are many places online where you can search GIS datasets. A good
% starting point is: https://freegisdata.rtwilson.com/
%