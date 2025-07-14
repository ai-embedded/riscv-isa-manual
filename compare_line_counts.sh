#!/bin/bash

# Files to process (excluding already processed ones)
files=(
"zc.adoc"
"zfa.adoc"
"zfh.adoc"
"zfinx.adoc"
"zicond.adoc"
"zicsr.adoc"
"zifencei.adoc"
"zihintntl.adoc"
"zihintpause.adoc"
"zilsd.adoc"
"zimop.adoc"
"zpm.adoc"
"ztso-st-ext.adoc"
)

echo "Comparing line counts between English and Chinese versions:"
echo "============================================================"

for file in "${files[@]}"; do
    en_file="/home/share/samba/tools/script_tools/risc-v-docs/riscv-isa-manual/src/$file"
    zh_file="/home/share/samba/tools/script_tools/risc-v-docs/riscv-isa-manual/src_zh/$file"
    
    if [ -f "$en_file" ] && [ -f "$zh_file" ]; then
        en_lines=$(wc -l < "$en_file")
        zh_lines=$(wc -l < "$zh_file")
        diff=$((zh_lines - en_lines))
        
        if [ $diff -gt 0 ]; then
            echo "$file: EN=$en_lines lines, ZH=$zh_lines lines (+$diff lines in Chinese)"
        fi
    elif [ ! -f "$zh_file" ]; then
        echo "$file: Chinese version not found"
    fi
done