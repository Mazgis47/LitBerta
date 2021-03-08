#!/bin/bash
# train_data_file='.webcrawl/etar2/e-tar.lt-lt-nextsent.txt'
train_data_file='data/full-nodup-256.txt'
v=1
next_v=$((v + 1))
curr_dir="./.models2/LitBERTa-base-v$v"
# curr_dir="./litberta"
next_dir="./.models2/LitBERTa-base-v$next_v"
epochs=4
python run_mlm.py \
        --train_file $train_data_file \
	--model_name_or_path "$curr_dir" \
        --output_dir "$next_dir" \
        --overwrite_output \
        --model_type roberta \
        --config_name "$curr_dir" \
        --tokenizer_name "$curr_dir" \
        --do_train  \
	--line_by_line \
        --learning_rate 1e-5 \
        --num_train_epochs $epochs \
        --save_total_limit 1 \
        --save_steps 5000 \
        --per_device_train_batch_size 4 \
        --warmup_steps 5000 \
        --gradient_accumulation_steps 4 \
        --seed 42 \
	--max_seq_length 256 \
        --fp16
exit 0
python run_language_modeling.py \
	--train_data_file $train_data_file \
	--output_dir "$next_dir" \
	--overwrite_output \
	--model_type roberta \
	--mlm \
	--config_name "$curr_dir" \
	--tokenizer_name "$curr_dir" \
	--do_train  \
	--line_by_line \
	--learning_rate 1e-5 \
	--num_train_epochs $epochs \
	--save_total_limit 1 \
	--save_steps 5000 \
	--per_gpu_train_batch_size 1 \
	--warmup_steps 5000 \
	--gradient_accumulation_steps 4 \
	--seed 42 \
	--no_cuda # \ 
	# --block_size 256 #\
	#--fp16
