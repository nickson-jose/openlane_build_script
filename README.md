# openlane_build_script
This script builds openlane and all its dependencies on an Ubuntu (only) System.

            >--STEPS TO BUILD--<

1. `git clone https://github.com/nickson-jose/openlane_build_script`
2. `sudo -i` #switch to root user (compulsory)
3. `./openlane_script.sh`
4. This script would create following directory structure:
```bash  
  └── work
    └── tools
        ├── cmake-3.13.0 
        ├── magic-8.3.50 
        └── openlane_working_dir
        └── SPEF EXTRACTOR
            
```              
        >--STEPS TO RUN OPENLANE--<

1. Go to /path/to/openlane (i.e., ~/work/tools/openlane_working_dir/openlane)
2. `export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks reside>`
     - For eg.: `export PDK_ROOT= /home/<username>/Desktop/work/tools/openlane_working_dir/pdks`
3. `docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) openlane:rc2`
4. `./flow.tcl -design spm`
(the above flow.tcl command will run RTL2GDS flow for design named "spm". Same can be done for other designs which are present in ~/work/tools/openlane_working_dir/openlane/designs)
5. Refer to: https://github.com/efabless/openlane for detailed instructions..
