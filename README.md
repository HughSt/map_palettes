# MapPalettes
A set of awesome palettes and functions for maps designed by the DiSARM team at UCSF

# Install
```r
library(devtools)  
install_github("disarm-platform/MapPalettes")
library(MapPalettes)
```
# Palettes
<img src="https://raw.githubusercontent.com/HughSt/mappalettes/master/images/palettes.png" height="600">

# Examples
```r
view_palette("green_machine", n=64, type = "raster") 
```
<img src="https://raw.githubusercontent.com/HughSt/mappalettes/master/images/hugh_div_swz_elev.png" width="500">

```r
# To create a hex bin plot from a raster
library(leaflet) # for colorNumeric function
elevation <- raster::getData('alt', country="SWZ")
hexbins <- hexbin_raster(elevation, n=300, function(x) mean(x, na.rm = TRUE))
col_pal <- colorNumeric(map_palette("bruiser", n=10), hexbins$stat)
plot(hexbins, col = col_pal(hexbins$stat))
```
<img src="https://raw.githubusercontent.com/HughSt/mappalettes/master/images/hexbin_bruiser.png" width="500">

```r
# To get main color groups from an image
get_colors_from_image("https://upload.wikimedia.org/wikipedia/commons/e/e3/Red-eyed_Tree_Frog_%28Agalychnis_callidryas%29_1.png",
                       n = 8)
[1] "#5E8527" "#35374A" "#A4AD5F" "#CD3F09" "#6BC221" "#342610" "#010100" "#567096"
```
<img src="https://raw.githubusercontent.com/HughSt/mappalettes/master/images/frog_colors.png" width="500">
