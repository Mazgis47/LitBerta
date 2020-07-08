#!/bin/bash
export TRAIN_FILE=./.data/train_small.txt
export EVAL_FILE=./.data/eval_small.txt
#export WANDB_WATCH=false
#export CUDA_LAUNCH_BLOCKING=1

python run_language_modeling.py \
	--train_data_file $TRAIN_FILE \
	--eval_data_file $EVAL_FILE \
	--output_dir ./.models/LitBERTa-base-v6 \
	--model_name_or_path ./.models/LitBERTa-base-v5 \
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
echo 'END:'
date
