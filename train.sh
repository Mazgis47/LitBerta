#!/bin/bash
train_data_file='./.initial_data/full-segmented.txt'
tmp_file='tmp.txt'
export TRAIN_FILE="./train_$tmp_file"
export EVAL_FILE="./eval_$tmp_file"
chunk_lines=3000000
epochs=4
epochs_idx=$((epochs -1))

#export WANDB_WATCH=false
#export CUDA_LAUNCH_BLOCKING=1
echo "Counting lines in main file..."
line_count=$(wc -l "$train_data_file" | cut -d ' ' -f 1)
echo "$line_count"

for i in $(seq 0 $epochs_idx); do
	echo "EPOCH: $i"
	next_i=$((i+1))
	start_line=1

	while [ $start_line -lt $line_count ]; do
		end_line=$((start_line + chunk_lines))
		sed -n "$start_line,$end_line p;$end_line q" "$train_data_file" > "$tmp_file"
		python split.py "$tmp_file" "$i"
		python run_language_modeling.py \
			--train_data_file $TRAIN_FILE \
			--eval_data_file $EVAL_FILE \
			--output_dir "./.models/LitBERTa-base-v$next_i" \
			--model_name_or_path "./.models/LitBERTa-base-v$i" \
			--overwrite_output \
			--model_type roberta \
			--mlm \
			--config_name .models/litberta \
			--tokenizer_name .models/litberta \
			--do_train  \
			--do_eval \
			--line_by_line \
			--learning_rate 1e-5 \
			--num_train_epochs 1 \
			--save_total_limit 2 \
			--save_steps 5000 \
			--per_gpu_train_batch_size 9 \
			--per_gpu_eval_batch_size 9 \
			--warmup_steps 5000 \
			--do_eval \
			--line_by_line \
			--gradient_accumulation_steps 4 \
			--seed 42 \
			--evaluate_during_training \
			--block_size 128 \
			--fp16
		start_line=$((end_line + 1))
		echo "END:"
		date
	done
done
