#!/usr/bin/env bash

export PATH=/Library/TeX/texbin:/usr/local/opt/gnu-sed/libexec/gnubin:$PATH

# Change default package repository
sudo tlmgr option repository https://mirrors.rit.edu/CTAN/systems/texlive/tlnet

# Keep no backups (not required, simply makes cache bigger)
sudo tlmgr option -- autobackup 0

# Update the TL install but add nothing new
sudo tlmgr update --self --all --no-auto-install

# Packages
sudo tlmgr install            \
  algorithmicx                \
  algorithms                  \
  anyfontsize                 \
  biber                       \
  biblatex                    \
  biblatex-gb7714-2015        \
  boondox                     \
  collection-fontsrecommended \
  ctex                        \
  enumitem                    \
  environ                     \
  fandol                      \
  fontaxes                    \
  footmisc                    \
  latexmk                     \
  logreq                      \
  multirow                    \
  newtx                       \
  ntheorem                    \
  pageslts                    \
  siunitx                     \
  sourcecodepro               \
  threeparttable              \
  tocloft                     \
  trimspaces                  \
  undolabl                    \
  was                         \
  xstring                     \
  zhnumber
