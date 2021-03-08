from pathlib import Path

from tokenizers import ByteLevelBPETokenizer
#from tokenizers import BertWordPieceTokenizer

paths = [str(x) for x in Path("./data").glob("**/*.txt")]
#paths = [str(x) for x in Path("./data/").glob("**/*.txt")]
print(paths)
if len(paths) == 0:
    print('ERROR: no files found in the path')
    exit(1)

# Initialize a tokenizer
tokenizer = ByteLevelBPETokenizer()
#tokenizer=BertWordPieceTokenizer(lowercase=True)
tokenizer.do_lower_case=True
# Customize training
tokenizer.train(files=paths, vocab_size=128_000, min_frequency=2, special_tokens=[
    "<s>",
    "<pad>",
    "</s>",
    "<unk>",
    "<mask>",
])

# Save files to disk
tokenizer.save_model("litberta")
