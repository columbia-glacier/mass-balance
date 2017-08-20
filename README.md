
Surface Mass Balance Data
=========================

Preview this [Data Package](http://specs.frictionlessdata.io/data-packages/) using the [Data Package Viewer](http://data.okfn.org/tools/view?url=https://github.com/columbia-glacier/mass-balance).

Data
----

<details><summary>View metadata (<i>datapackage.json</i>)</summary>

-   **name**: mass-balance
-   **title**: Columbia Glacier Surface Mass Balance Data
-   **description**: Annual surface mass balance measurements compiled from the 1978 campaign (sources/mayo-and-others-1979.pdf) and the 2010-2011 campaign (sources/oneel-2012.pdf).
-   **version**: 0.1.0
-   **sources**:
    -   \[1\]
        -   **title**: Original data and documentation
        -   **path**: sources/
-   **contributors**:
    -   \[1\]
        -   **title**: Ethan Welty
        -   **email**: <ethan.welty@gmail.com>
        -   **role**: author
    -   \[2\]
        -   **title**: Shad O'Neel
        -   **role**: Led the 2010-2011 campaign and reduced the data from the 1978 campaign
-   **resources**:
    -   \[1\]
        -   **name**: data
        -   **path**: data/data.csv
        -   **title**: Mass balance data
        -   **schema**:
            -   **fields**:
                -   \[1\]
                    -   **name**: year
                    -   **type**: date
                    -   **format**: %Y
                    -   **description**: Mass balance year
                -   \[2\]
                    -   **name**: name
                    -   **type**: string
                    -   **description**: Site name
                -   \[3\]
                    -   **name**: alt\_name
                    -   **type**: string
                    -   **description**: Alternate site name
                -   \[4\]
                    -   **name**: longitude
                    -   **type**: number
                    -   **description**: Longitude (WGS84, EPSG:4326)
                    -   **unit**: °
                -   \[5\]
                    -   **name**: latitude
                    -   **type**: number
                    -   **description**: Latitude (WGS84, EPSG:4326)
                    -   **unit**: °
                -   \[6\]
                    -   **name**: elevation
                    -   **type**: number
                    -   **description**: Elevation (height above the WGS84 ellipsoid)
                    -   **unit**: m
                -   \[7\]
                    -   **name**: annual\_balance\_we
                    -   **type**: number
                    -   **description**: Water-equivalent annual mass balance (from autumn the previous year to autumn of the current year)
                    -   **unit**: m </details>

### Description

Annual surface mass balance measurements compiled from the 1978 campaign [sources/mayo-and-others-1979.pdf](sources/mayo-and-others-1979.pdf) and the 2010-2011 campaign [sources/oneel-2012.pdf](sources/oneel-2012.pdf).

### Citations

> Shad O'Neel (2012). Surface Mass Balance of the Columbia Glacier, Alaska, 1978 and 2010 Balance Years. U.S. Geological Survey Data Series 676. Retrieved from <http://pubs.er.usgs.gov/publication/ds676>. Archived at [sources/oneel-2012.pdf](sources/oneel-2012.pdf).

> Larry R. Mayo, D. C. Trabant, Rod March, and Wilfried Haeberli (1979). Columbia Glacier Stake Location, Mass Balance, Glacier Surface Altitude, and Ice Radar Data, 1978 Measurement Year. U.S. Geological Survey Open File Report 79–1168. Online at <https://pubs.er.usgs.gov/publication/ofr791168>. Archived at [sources/mayo-and-others-1979.pdf](sources/mayo-and-others-1979.pdf).

To Do
-----

-   GPS coordinates of the 2011 TazDivide site.
