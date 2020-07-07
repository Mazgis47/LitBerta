from transformers import AutoModelWithLMHead, AutoTokenizer
import os
directory = ".models/LitBERT-small-v2/checkpoint-30000/"
model = AutoModelWithLMHead.from_pretrained(directory)
tokenizer = AutoTokenizer.from_pretrained(directory)
out = "LitBERT-small-v2"
os.makedirs(out, exist_ok=True)
model.save_pretrained(out)
tokenizer.save_pretrained(out)
