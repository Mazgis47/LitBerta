import os
import sys

input_file = sys.argv[1]
output_file_train = 'train-' + sys.argv[1]
output_file_eval = 'eval-' + sys.argv[1]
val_ratio = 5
x = 0
with open(input_file) as ifile:
    with open(output_file_train, "w") as ofile_train:
        with open(output_file_eval, "w") as ofile_eval:
            for i, line in enumerate(ifile):
                if line != "\n":
                    if x % val_ratio == 0:
                        ofile_eval.write(line)
                    else:
                        ofile_train.write(line)
                    x = x + 1
