# Magma set

yin 2022/02/18  

## 1. Create spherical magma
Change vp & vs inside magma.  
Type 1 constant velocity  
Type 2 velocity with cosine decay  
```
jupyter lab  
magma_5_kinds.ipynb
mv result_file Loop_magma/USED_MAG
```


## 2. create crosssection for earthquake  
conda should contain gmt6
```
cd Loop_magma  
conda install -c conda-forge gmt  
conda activate conda_yin
./sh_mag_event_loop.csh
``` 
`USED_MAG/` magma chamber with different depth, velocity  
`CMT/` eqrthquake events CMTSOLUSION


