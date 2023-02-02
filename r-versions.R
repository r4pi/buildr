#!/usr/bin/env Rscript

url <- "https://cran.rstudio.com/src/base/VERSION-INFO.dcf"
localdcf <- "~/.R-VERSION-INFO.dcf"
localjson <- "~/.R-VERSION-INFO.json"

get_r_version_info <- function(){
download.file(url, localdcf)
}

version_data_to_json <- function(){
library(jsonlite)
version_data <- read.dcf(localdcf)
# version_data[1,"Release"]

release <- list(version = version_data[1,"Release"],
                nick    = version_data[1,"Nickname"],
                date    = version_data[1,"Date"])

old_rel <- list(version = version_data[1,"Old-release"],
                nick    = version_data[1,"Old-nick"],
                date    = version_data[1,"Old-date"])

next_rel <- list(version = version_data[1,"Next-release"],
                nick     = version_data[1,"Next-nick"],
                date.    = version_data[1,"Next-date"])

dev_rel <- list(version = version_data[1,"Devel"],
                nick    = version_data[1,"Devel-nick"])


write_json(list("release" = release,
                "old"     = old_rel,
                "next"    = next_rel,
                "dev"     = dev_rel,
                "updated" = Sys.time()),
           localjson)
}


print_r_version_info <- function(){
	version_data <- read.dcf(localdcf)
	cat(" -- R versions -- \n")
	cat(sprintf("%-15s\t%-5s\t%-10s\n",
		    "",
		    "Version",
		    "Date"))
	cat(sprintf("%-15s\t%5s\t%10s\n",
		    "Release",
		    version_data[1, "Release"],
		    version_data[1, "Date"]))
	cat(sprintf("%-15s\t%5s\t%10s\n",
		    "Old-release",
		    version_data[1, "Old-release"],
		    version_data[1, "Old-date"]))
	cat(sprintf("%-15s\t%5s\t%10s\n",
		    "Next-release",
		    version_data[1, "Next-release"],
		    version_data[1, "Next-date"]))
	cat(sprintf("%-15s\t%5s\n",
		    "Dev-release",
		    version_data[1, "Devel"]))
	}

if (file.exists(localdcf)){
  if (difftime(file.info(localdcf)["mtime"][[1]], Sys.time(), units = "hours") < -6){
	  get_r_version_info()
  }
} else {
	get_r_version_info()
}
print_r_version_info()
