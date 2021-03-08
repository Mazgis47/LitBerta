#!/bin/bash
train_data_file='./.initial_data/tst1.txt'
tmp_file='tmp.txt'
export TRAIN_FILE="./train_$tmp_file"
export EVAL_FILE="./eval_$tmp_file"
chunk_lines=2000000
epochs=1
epochs_idx=$((epochs -1))
log_file='log_train.log'

#export WANDB_WATCH=false
#export CUDA_LAUNCH_BLOCKING=1
echo "Counting lines in main file..." >> "$log_file"
line_count=$(wc -l "$train_data_file" | cut -d ' ' -f 1)
echo "$line_count" >> "$log_file"
next_v=0

for i in $(seq 0 $epochs_idx); do
	echo "EPOCH: $i"  >> "$log_file"
	start_line=0
	v=$next_v
	while [ $start_line -lt $line_count ]; do
		next_v=$((v+1))
		end_line=$((start_line + chunk_lines))
		echo "start_line $start_line end_line $end_line" >> "$log_file"
		date  >> "$log_file"
		sed -n "$start_line,$end_line p;$end_line q" "$train_data_file" > "$tmp_file"
		python split.py "$tmp_file" "$i"
		echo "-------------------- NEW LAUNCH---------------------> From $v to $next_v"
		echo "-------------------- NEW LAUNCH---------------------> From $v to $next_v" >> "$log_file"
		curr_dir="./.models/LitBERTa-base-v$v"
		next_dir="./.models/LitBERTa-base-v$next_v"
		echo "$curr_dir $next_dir" >> "$log_file"
		if [ ! -f "$curr_dir/config.json" ]; then
			echo "Config file was not found in the $curr_dir (sleeping)" >> "$log_file"
			sleep 60
		fi
		if [ ! -f "$curr_dir/config.json" ]; then
	                echo "Config file was not found in the $curr_dir" >> "$log_file"
			exit 1
		fi
		python run_language_modeling.py \
			--train_data_file $TRAIN_FILE \
			--eval_data_file $EVAL_FILE \
			--output_dir "$next_dir" \
			--model_name_or_path "$curr_dir" \
			--overwrite_output \
			--model_type roberta \
			--mlm \
			--config_name "$curr_dir" \
			--tokenizer_name "$curr_dir" \
			--do_train  \
			--do_eval \
			--line_by_line \
			--learning_rate 1e-5 \
			--num_train_epochs 1 \
			--save_total_limit 2 \
			--save_steps 5000 \
			--per_gpu_train_batch_size 7 \
			--per_gpu_eval_batch_size 9 \
			--warmup_steps 5000 \
			--do_eval \
			--line_by_line \
			--gradient_accumulation_steps 4 \
			--seed 42 \
			--evaluate_during_training \
			--block_size 128 \
			--fp16
		exit_code=$?
		if [ $exit_code != 0 ]; then
			echo "ERROR from modeling script: $exit_code"
			exit 1
		fi

		start_line=$((end_line + 1))
		v=$((v+1))
		echo "END:"  >> "$log_file"
		date  >> "$log_file"
	done
done
