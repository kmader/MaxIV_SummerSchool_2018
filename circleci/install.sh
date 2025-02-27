# Adapted shamelessly from https://github.com/scikit-learn-contrib/project-template/blob/master/ci_scripts/install.sh
# Deactivate the circleci-provided virtual environment and setup a
# conda-based environment instead
if [[ `type -t deactivate` ]]; then
  deactivate
fi

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends graphviz libgtk2.0-0

# Use the miniconda installer for faster download / install of conda
# itself
# XXX: Most of this is very similar to travis/install.sh. We should
# probably refactor it later.
pushd .
cd
mkdir -p download
cd download
echo "Cached in $HOME/download :"
ls -l
echo
if [[ ! -f miniconda.sh ]]
   then
   wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
       -O miniconda.sh
   fi
chmod +x miniconda.sh && ./miniconda.sh -b
cd ..
export PATH="$HOME/miniconda3/bin:$PATH"
conda update --yes conda
popd

# Configure the conda environment and put it in the path using the
# provided versions
conda env create -n qbi2018 -f binder/environment.yml
source activate qbi2018

export QBI_HOME=$(pwd)

conda install --yes jupyter
pip install pdoc==0.3.2 pygments

# importing matplotlib once builds the font caches. This avoids
# having warnings in our example notebooks
python -c "import matplotlib.pyplot as plt"
