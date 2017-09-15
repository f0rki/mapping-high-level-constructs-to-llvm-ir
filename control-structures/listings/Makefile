include ../../common.mk

simple_if_max_cleaned_cfg.png: simple_if_max_cleaned.ll
	opt -dot-cfg simple_if_max_cleaned.ll >/dev/null
	dot -Tpng cfg.max.dot > simple_if_max_cleaned_cfg.png
