ncdc_add_units <- function(x, datasetid) {
  stopifnot(is.data.frame(x))
  if (datasetid %in% c('NEXRAD2', 'NEXRAD3')) x else unit_adder(datasetid, x)
}

unit_adder <- function(datasetid, x) {
  x <- dplyr::rowwise(x)
  df <- dplyr::do(x, data.frame(units = pick_by_datatype(datasetid, .$datatype),
    stringsAsFactors = FALSE))
  df <- dplyr::bind_cols(x, df)
  dplyr::ungroup(df)
}

pick_by_datatype <- function(datasetid, var) {
  src <- paste0("ncdc_units_", tolower(datasetid))
  src <- eval(parse(text = src))
  tmp <- which(vapply(names(src), function(z) grepl(z, var), logical(1)))
  if (length(tmp) == 0) return("unknown; see docs")
  src[tmp][[1]]$units
}
