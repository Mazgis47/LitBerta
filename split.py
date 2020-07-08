import os
import sys

input_file = sys.argv[1]
output_file_train = 'train_' + input_file
output_file_eval = 'eval_' + input_file
val_ratio = 5
x_param = sys.argv[2]
x = int(x_param)
print('Starting eval line:', x)
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
