
git clone https://github.com/wch/r-source.git
cd r-source
git fetch
git checkout origin/R-4-1-branch

echo "Installing Recommended Tools"
# Get recommended packages if necessary
tools/rsync-recommended

R_PAPERSIZE=letter                              \
R_BATCHSAVE="--no-save --no-restore"            \
R_BROWSER=xdg-open                              \
PAGER=/usr/bin/pager                            \
PERL=/usr/bin/perl                              \
R_UNZIPCMD=/usr/bin/unzip                       \
R_ZIPCMD=/usr/bin/zip                           \
R_PRINTCMD=/usr/bin/lpr                         \
LIBnn=lib                                       \
AWK=/usr/bin/awk                                \
CC="ccache gcc"                                 \
CFLAGS="-ggdb -pipe -std=gnu99 -Wall -pedantic" \
CXX="ccache g++"                                \
CXXFLAGS="-ggdb -pipe -Wall -pedantic"          \
FC="ccache gfortran"                            \
F77="ccache gfortran"                           \
MAKE="make"                                     \
./configure                                     \
    --prefix=${1}            \
    --enable-R-shlib                            \
    --with-blas                                 \
    --with-lapack                               \
    --with-readline

#CC="clang -O3"                                  \
#CXX="clang++ -03"                               \


# Workaround for explicit SVN check introduced by
# https://github.com/wch/r-source/commit/4f13e5325dfbcb9fc8f55fc6027af9ae9c7750a3

# Need to build FAQ
(cd doc/manual && make front-matter html-non-svn)

rm -f non-tarball

# Get current SVN revsion from git log and save in SVN-REVISION
echo -n 'Revision: ' > SVN-REVISION
git log --format=%B -n 1 \
  | grep "^git-svn-id" \
  | sed -E 's/^git-svn-id: https:\/\/svn.r-project.org\/R\/.*?@([0-9]+).*$/\1/' \
  >> SVN-REVISION
echo -n 'Last Changed Date: ' >>  SVN-REVISION
git log -1 --pretty=format:"%ad" --date=iso | cut -d' ' -f1 >> SVN-REVISION

# End workaround

# Set this to the number of cores on your computer
make --jobs=6

make && make install