# Runtime:
# Update:

# setup ------------------------------------------------------------------------
tic <- Sys.time()

library("here")
library("dplyr")
library("purrr")


# data -------------------------------------------------------------------------

# get file names 
codebook_files <- 
  list.files(
    path = file.path("C:\\Users\\zakhi\\Harvard University Dropbox\\Israel and the Regional Economy Project\\Jonah_Zak\\Data\\CBS - PUFs\\ISS"),
    recursive = TRUE,
    full.names = TRUE,
    all.files = FALSE
  )

codebook_files <- 
  codebook_files[grepl(pattern = "odebook.xls", x = codebook_files) &
                   !grepl(pattern = "naC", x = codebook_files)]

# convert all xls files to csv
xls_codebooks <- codebook_files[endsWith(codebook_files, ".xls")]

for (cb in xls_codebooks) {
  readxl::read_xls(cb) |> 
    write.csv(file = sub(".xls", ".csv", cb), 
              row.names = F)
}


readxl::read_xls(codebook_files[9])
