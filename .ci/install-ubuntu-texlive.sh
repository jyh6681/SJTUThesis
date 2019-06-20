#!/usr/bin/env bash

# Change default package repository
export REPO=https://mirrors.rit.edu/CTAN/systems/texlive/tlnet

# See if there is a cached version of TL available
export PATH=/tmp/texlive/bin/x86_64-linux:$PATH
if ! command -v texlua > /dev/null; then
  # Obtain TeX Live
  wget $REPO/install-tl-unx.tar.gz
  tar -xzf install-tl-unx.tar.gz
  cd install-tl-20*

  # Install a minimal system
  ./install-tl --profile ../.ci/texlive-ubuntu.profile --repository $REPO
  cd ..
fi

# Packages
tlmgr install                 \
  algorithmicx                \
  algorithms                  \
  anyfontsize                 \
  biber                       \
  biblatex                    \
  biblatex-gb7714-2015        \
  booktabs                    \
  boondox                     \
  caption                     \
  cjk                         \
  collection-fontsrecommended \
  ctex                        \
  enumitem                    \
  environ                     \
  eso-pic                     \
  etoolbox                    \
  fandol                      \
  float                       \
  fontaxes                    \
  fontspec                    \
  footmisc                    \
  kastrup                     \
  l3kernel                    \
  l3packages                  \
  latexmk                     \
  listings                    \
  logreq                      \
  mathtools                   \
  ms                          \
  multirow                    \
  newtx                       \
  ntheorem                    \
  pageslts                    \
  pdfpages                    \
  pgf                         \
  siunitx                     \
  sourcecodepro               \
  tex-gyre                    \
  threeparttable              \
  tocloft                     \
  translator                  \
  trimspaces                  \
  ulem                        \
  undolabl                    \
  was                         \
  xcolor                      \
  xecjk                       \
  xetex                       \
  xkeyval                     \
  xstring                     \
  zhnumber

# Keep no backups (not required, simply makes cache bigger)
tlmgr option -- autobackup 0

# Update the TL install but add nothing new
tlmgr update --self --all --no-auto-install
