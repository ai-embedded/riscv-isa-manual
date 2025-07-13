#!/usr/bin/env python3
import re

def clean_file(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # 找到第一个brev8指令的位置
    brev8_line = None
    for i, line in enumerate(lines):
        if line.strip() == '==== brev8':
            brev8_line = i
            break
    
    if brev8_line is None:
        print("找不到brev8指令")
        return
    
    # 保留从开头到brev8结束的内容
    # 找到brev8之后的第一个新指令或文件结束
    end_line = len(lines)
    for i in range(brev8_line + 1, len(lines)):
        if lines[i].startswith('==== ') and not lines[i].startswith('==== brev8'):
            end_line = i
            break
        if lines[i].strip() == '<<<' and i + 1 < len(lines):
            # 检查下一行是否是新的指令
            if i + 2 < len(lines) and lines[i + 2].startswith('==== '):
                end_line = i + 1
                break
    
    # 保存清理后的内容
    clean_lines = lines[:end_line]
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.writelines(clean_lines)
    
    print(f"文件已清理，保留了前 {end_line} 行")
    return end_line

# 清理文件
lines_kept = clean_file('src_zh/scalar-crypto.adoc', 'src_zh/scalar-crypto-clean.adoc')