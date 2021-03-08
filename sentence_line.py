import torch
from pytorch_transformers import BertTokenizer, BertModel, BertForMaskedLM, BertConfig, BertForSequenceClassification
from tokenizers import BertWordPieceTokenizer
from tokenizers import ByteLevelBPETokenizer
import sys

input_file = sys.argv[1]
output_file = sys.argv[2]

#USE_GPU = 1 #!!!!
# Device configuration
#device = torch.device('cuda' if (torch.cuda.is_available() and USE_GPU) else 'cpu')
#print(device)
# pretrained_model = '/home/mp/notebooks/lt/.models/LitBERTa-base-v11'
pretrained_model = './litberta'
tokenizer = ByteLevelBPETokenizer(
    pretrained_model+"/vocab.json",
    pretrained_model+"/merges.txt",
)

i = 0
j = 0
with open(input_file) as ifile:
    with open(output_file, "w") as ofile:
        line_write = ""
        token_count = 0
        for i, line in enumerate(ifile):
            # print('>>>>>>>',line, '<<<<<<')
            i = i + 1
            if i % 50000 == 0:
                print('total:',i, line)
            if line == "\n":
                continue
            line = line.replace("\n", "")
            line = line.replace("\r", "")
            encoded = tokenizer.encode(line)
            token_count = token_count + len(encoded.tokens)
            if (token_count >= 256):
                # print(token_count, '>>>>>>>',line_write, '<<<<<<')
                j = j + 1 
                if j % 10000 == 0:
                    print(j, token_count, line_write)
                ofile.write(line_write + "\n")
                line_write = line
                token_count =len(encoded.tokens)
                continue
            line_write = line_write + " " + line 
        ofile.write(line_write + "\n")




