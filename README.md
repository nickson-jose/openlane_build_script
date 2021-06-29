# openlane_build_script
This script builds openlane and all its dependencies on an Ubuntu (only) System.
The scripts in this repo are namely:
 - openlane_script.sh
 - openlane_script_wo_depends.sh
 
**openlane_script.sh** is a standalone script where it builds openlane (latest version) and all its dependencies; while **openlane_script_wo_depends.sh** works in conjunction with [vsdflow script](https://github.com/kunalg123/vsdflow) and builds only openlane (hence lesser run-time).


# Contents
- [Steps to build Openlane](#steps-to-build-openlane)
- [Steps to run Openlane](#steps-to-run-openlane)
- [Acknowledgments](#acknowledgments)
 
# STEPS TO BUILD OPENLANE

1. `git clone https://github.com/nickson-jose/openlane_build_script`
2. `sudo -i` #switch to root user (compulsory).
3. Change directory to where openlane_build_script folder was cloned. `cd /path/to/openlane_build_script`
4. Execute the script as below:

      - **For standalone build**
       
        - `chmod 775 openlane_script.sh`
        - `./openlane_script.sh`
     
      - **For build in conjunction with vsdflow**
       
        -  Copy the `openlane_script_wo_depends.sh` to vsdflow folder.
        - `chmod 775  openlane_script_wo_depends.sh`
        - `./openlane_script_wo_depends.sh`
      
5. This script would create following directory structure:

- **For build in conjunction with vsdflow**
```bash 
vsdflow/
  └── work
     └── tools
      ├── cmake-3.13.0
      ├── cmake-3.13.0.tar.gz
      ├── graywolf
      ├── magic-8.3.50
      ├── magic-8.3.50.tgz
      ├── netgen-1.5.134
      ├── netgen-1.5.134.tgz
      ├── openlane_working_dir
      ├── OpenSTA
      ├── OpenTimer
      ├── qflow-1.3.17
      ├── qflow-1.3.17.tgz
      ├── qrouter-1.4.59
      ├── qrouter-1.4.59.tgz

```
- **For standalone build**
 ```bash  
 Desktop/
 ...
  └── work
    └── tools
        ├── cmake-3.13.0 
        ├── magic-8.3.60 
        └── openlane_working_dir
            
```              
 
# STEPS TO RUN OPENLANE

1. Go to /path/to/openlane (i.e., ~/work/tools/openlane_working_dir/openlane)

2. `export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks reside>`
   
   - For eg.: `export PDK_ROOT=/home/<username>/Desktop/work/tools/openlane_working_dir/pdks/`
   - To permanently set the variable, add a line to '/etc/environment' setting the PDK_ROOT as the absolute path to the pdks directory.For example:`PDK_ROOT="/home/<username>/Desktop/openlane_build_script/work/tools/openlane_working_dir/pdks/"`
   - **Note:** The machine might have to be restarted once for the above changes to reflect.

3. `docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) openlane:rc6`
   - **Note:** If you face "permission denied" after executing the above command, just restart the machine once. Else logout/login of the user to see the changes reflect immediately.

4. `./flow.tcl -design spm`
(the above flow.tcl command will run RTL2GDS flow for design named "spm". Same can be done for other designs which are present in ~/work/tools/openlane_working_dir/openlane/designs)

5. Refer to: https://github.com/efabless/openlane for detailed instructions.

# ACKNOWLEDGMENTS

[efabless openlane team](https://github.com/efabless/openlane).
