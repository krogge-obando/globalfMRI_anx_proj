
#Code we used to derive the 40 components, to run FSL must be installed. Note: fix_ICA_paths.txt can be found in our repo in the data folder.

melodic -i /data1/neurdylab/datasets/nki_rockland/vigilance_analysis/fix_ICA_paths.txt -d 40 -o /data1/neurdylab/datasets/nki_rockland/vigilance_analysis/FIX_ICA_40comps --Oorig --report --tr=2.1 -v
