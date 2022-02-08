r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)
remotes::install_github("ManuelHentschel/vscDebugger")
install.packages("httpgd")
install.packages("languageserver")