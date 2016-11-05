info=session_info.txt

# Session Information
echo "Session Info" > $info
echo >> $info

# Make Version
echo "Make Version" >> $info
make --version >> $info
echo >> $info
echo >> $info

# Git
echo "Git Version" >> $info
git --version >> $info
echo >> $info
echo >> $info

# Pandoc Version
echo "pandoc Version" >> $info
pandoc --version >> $info
echo >> $info
echo >> $info

# R Version
echo "R Version" >> $info
cd code/scripts; Rscript session_info_script.R