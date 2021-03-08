import os
import sys
import hashlib

dict = {}
input_file = sys.argv[1]
output_file = sys.argv[2]
with open(input_file) as ifile:
    with open(output_file, "w") as ofile:
        for i, line in enumerate(ifile):
            if line == "\n":
                continue
            hash_object = hashlib.md5(line)
            h = hash_object.hexdigest()
            if h in dict:
                continue
            ofile.write(line)
            dict[h] = True
