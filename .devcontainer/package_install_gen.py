#!/usr/bin/env python3
from typing import TextIO

i = 0
j = 0


def create_file(suffix: int, file: TextIO = None) -> TextIO:
    if file:
        file.close()
    w = open("install{}.r".format(suffix), "a")
    w.write("print('beginning file {}')".format(suffix))
    return w


w = create_file(i)
with open('packages.txt') as r:
    for line in r:
        l = line.strip()
        w.write(
            f'''
r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)
print('attempting to install {l}')
package.check <- lapply(
  '{l}',
  FUN = function(x) {{
    if (!require(x, character.only = TRUE)) {{
      withCallingHandlers(install.packages('{l}', repos="http://cran.us.r-project.org"),warning = function(w) stop(w))
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }}
  }}
)
print('{l} installed successfully')
'''
        )
        i += 1
        if i == 5:
            w = create_file(j)
            j += 1
            i = 0
