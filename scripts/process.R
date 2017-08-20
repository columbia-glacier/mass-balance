library(magrittr)

# ---- O'Neel (2010-2011) ----

# Prepare station ids
station_ids <- c(
  Wire1 = "MB1",
  Wire2 = "MB2",
  Wire3 = "MB3",
  `km 14` = "GPSlow",
  ACC1 = "ACC1",
  ACC2 = "ACC2",
  ELA = "ELA"
)

# Load Table 1
tab1 <- readr::read_csv("sources/oneel-2012-table-1.csv")
tab1 %<>%
  # Initial formatting
  dplyr::transmute(
    id = station_ids[`Marker or site`],
    alt_id = `Marker or site` %>%
      gsub(" ", "", .) %>%
      replace(. == id, NA),
    x = Easting,
    y = Northing,
    elevation = Altitude,
    install_date = `Install date`,
    autumn_visit_date = `Autumn visit date`,
    methods = Measurements %>%
      gsub(";", ",", .),
    description = Description
  )

# Add Tazlina Divide
# (see sources/Columbia_Balance_2011.xlsx, sources/CG_MBprofiles.txt)
tab1 %<>%
  tibble::add_row(
    id = "TazDivide",
    elevation = 1711,
    methods = "Snow pit"
  )

# Add MB8
# (see sources/Columbia_Balance_2011.xlsx, sources/massbalancestakes.xlsx)
mb8_xyz <- c(-147.25079, 61.18586, 505) %>%
  cgr::sp_transform(from = "+proj=longlat +datum=WGS84", to = "+proj=utm +zone=6")
tab1 %<>%
  tibble::add_row(
    id = "MB8",
    x = mb8_xyz[1],
    y = mb8_xyz[2],
    elevation = mb8_xyz[3],
    methods = "Ablation wire"
  )

# Stations
# id, alt_id, x, y, elevation, install_date, methods, description
oneel_stations <- tab1 %>%
  dplyr::select(-autumn_visit_date)

# Station data
# year, station_id, balance, autumn_visit_date
balances <- readr::read_delim("sources/CG_MBprofiles.txt", delim = "\t", na = "NaN") %>%
  tidyr::gather(key = "year", value = "balance", `2010`, `2011`)
oneel_data <- tab1 %>%
  dplyr::left_join(balances, by = c(elevation = "z"))
autumn_visit_dates_2011 <- c(
  "MB1" = as.Date("2011-09-18"),
  "MB3" = as.Date("2011-08-22"),
  "MB8" = as.Date("2011-09-18"),
  "ACC1" = as.Date("2011-08-29"),
  "ACC2" = as.Date("2011-08-29"),
  "TazDivide" = as.Date("2011-08-29")
)
is_2011 <- oneel_data$year == "2011"
oneel_data[is_2011, "autumn_visit_date"] <- autumn_visit_dates_2011[oneel_data$id[is_2011]]
oneel_data %<>%
  dplyr::transmute(
    year,
    station_id = id,
    balance,
    autumn_visit_date
  )

# ---- Mayo (1978) ----

# Load Table 2
tab2 <- readr::read_csv("sources/oneel-2012-table-2.csv")
tab2 %<>%
  dplyr::transmute(
    id = `Site name` %>%
      gsub(" ", "", .),
    x = Easting,
    y = Northing,
    elevation = Altitude,
    methods = "Stake",
    balance = `Point Balance`,
    snow_density = Density
  )

# stations
# id, x, y, elevation, methods
mayo_stations <- tab2 %>%
  dplyr::select(
    id, x, y, elevation, methods
  )

# data
# year, station_id, balance, snow_density
mayo_data <- tab2 %>%
  dplyr::transmute(
    year = "1978",
    station_id = id,
    balance,
    snow_density
  )

# ---- Data Package ----

# Prepare data resource
stations <- dplyr::bind_rows(oneel_stations, mayo_stations)
data <- dplyr::bind_rows(oneel_data, mayo_data) %>%
  dplyr::left_join(stations, by = c(station_id = "id")) %>%
  cgr::sp_transform(
    cols = c("x", "y"),
    from = "+proj=utm +zone=6 +datum=WGS84",
    to = "+proj=longlat +datum=WGS84"
  ) %>%
  dplyr::transmute(
    year = year %>%
      dpkg::set_field(description = "Mass balance year", format = "%Y", type = "date"),
    name = station_id %>%
      dpkg::set_field(description = "Site name"),
    alt_name = alt_id %>%
      dpkg::set_field(description = "Alternate site name"),
    longitude = x %>%
      units2::as_units("degree") %>%
      dpkg::set_field(description = "Longitude (WGS84, EPSG:4326)"),
    latitude = y %>%
      units2::as_units("degree") %>%
      dpkg::set_field(description = "Latitude (WGS84, EPSG:4326)"),
    elevation = elevation %>%
      units2::as_units("m") %>%
      dpkg::set_field(description = "Elevation (height above the WGS84 ellipsoid)"),
    annual_balance_we = balance %>%
      units2::as_units("m") %>%
      dpkg::set_field(description = "Water-equivalent annual mass balance (from autumn the previous year to autumn of the current year)")
  ) %>%
  dplyr::filter(!is.na(annual_balance_we)) %>%
  dplyr::arrange(year, elevation) %>%
  dpkg::set_resource(
    name = "data",
    path = "data/data.csv",
    title = "Mass balance data"
  )

# Prepare and write package
list(data) %>%
  dpkg::set_package(
    name = "mass-balance",
    title = "Columbia Glacier Surface Mass Balance Data",
    description = "Annual surface mass balance measurements compiled from the 1978 campaign (sources/mayo-and-others-1979.pdf) and the 2010-2011 campaign (sources/oneel-2012.pdf).",
    version = "0.1.0",
    contributors = list(
      dpkg::contributor("Ethan Welty", email = "ethan.welty@gmail.com", role = "author"),
      dpkg::contributor("Shad O'Neel", role = "Led the 2010-2011 campaign and reduced the data from the 1978 campaign")
    ),
    sources = list(
      dpkg::source("Original data and documentation", path = "sources/")
    )
  ) %>%
  dpkg::write_package()
