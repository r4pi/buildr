#!/usr/bin/env Rscript

url <- "https://cran.rstudio.com/src/base/VERSION-INFO.dcf"
localdcf <- "~/.R-VERSION-INFO.dcf"

get_r_version_info <- function(){
download.file(url, localdcf)
}

version_data <- read.dcf(localdcf)

print_r_version_info <- function(){
	version_data <- read.dcf(localdcf)
	cat(version_data[1, "Release"], "\n")
	}

print_r_version_info()
