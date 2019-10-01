#' @title Project Settings
#'
#' @author Nicolas Casajus, \email{nicolas.casajus@@gmail.com}



rm(list = ls())



#' ----------------------------------------------------------------------------- @LoadLibraries

pkgs <- c(
  "devtools",
  "readxl"
)

lapply(
  pkgs[!(pkgs %in% installed.packages())],
  install.packages,
  dependencies = TRUE
)

if (!("emo" %in% installed.packages())) devtools::install_github("hadley/emo")


if (sum(unlist(lapply(pkgs, require, character.only = TRUE))) == length(pkgs)) {

  cat("\n", emo::ji("computer"), ">>> All packages loaded !\n")

} else {

  cat("\n", emo::ji("warning"), ">>> Some packages failed to load !\n")

}



#' ----------------------------------------------------------------------------- @CreateResultFolders

script_names <- list.files(path = "src", pattern = "^[0-9]{2}.+\\.R$")
script_names <- script_names[-1]
dir_names    <- gsub("\\.R", "", script_names)
dir_vars     <- regmatches(
  x = dir_names,
  m = regexpr(
    pattern = "^[0-9]{2}[a-z]?",
    text = dir_names
  )
)

if (length(dir_vars) > 0) {

  dir_vars     <- paste0("res_dir_", dir_vars)

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

  cat("\n", emo::ji("folder"), ">>> All folders created !\n")

}



#' ----------------------------------------------------------------------------- @CleanMemoryVariables

rm(list = c("script_names", "dir_names", "dir_vars", "pkgs"))
