## Replace the content of a specific column with awk.
awk '{$35 = $35"$"; print}' infile > outfile
