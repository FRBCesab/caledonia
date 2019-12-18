#' @title Project Settings
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@fondationbiodiversite.fr}



rm(list = ls())



#' ----------------------------------------------------------------------------- @LoadLibraries

pkgs <- c(
  "readxl"
)

lapply(
  pkgs[!(pkgs %in% installed.packages())],
  install.packages,
  dependencies = TRUE
)



#' ----------------------------------------------------------------------------- @CreateResultFolders

script_names <- list.files(path = "src", pattern = "^.+\\.R$")
script_names <- script_names[-which(script_names == "setup.R")]
dir_names    <- gsub("\\.R", "", script_names)
dir_vars     <- dir_names

if (length(dir_vars) > 0) {

  dir_vars <- paste0("res_dir_", dir_vars)

  sapply(1:length(dir_names), function(i) {

    dir.create(
      path          = file.path("res", dir_names[i]),
      showWarnings  = FALSE,
      recursive     = TRUE
    )

    assign(
      x      = dir_vars[i],
      value  = file.path("res", dir_names[i]),
      envir  = .GlobalEnv
    )
  })
}



#' ----------------------------------------------------------------------------- @CleanMemoryVariables

rm(list = c("script_names", "dir_names", "dir_vars", "pkgs"))
