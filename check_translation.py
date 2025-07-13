#!/usr/bin/env python3
"""
检查RISC-V手册翻译完整性的脚本
对比src和src_zh目录下每个文件的翻译状态
"""

import os
import re
from pathlib import Path

def count_lines(file_path):
    """计算文件的有效行数（忽略空行和注释）"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # 过滤空行和仅包含空白字符的行
        effective_lines = [line for line in lines if line.strip()]
        return len(effective_lines)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return 0

def analyze_translation_completion(src_file, zh_file):
    """分析翻译完成度"""
    src_lines = count_lines(src_file)
    zh_lines = count_lines(zh_file)
    
    if src_lines == 0:
        return 100 if zh_lines > 0 else 0
    
    # 计算完成度百分比
    completion_rate = min(100, (zh_lines / src_lines) * 100)
    return completion_rate

def check_missing_content(src_file, zh_file):
    """检查是否有未翻译的英文内容"""
    try:
        with open(zh_file, 'r', encoding='utf-8') as f:
            zh_content = f.read()
        
        # 检查是否包含大量英文句子（简单启发式）
        english_patterns = [
            r'\b[A-Z][a-z]+\s+[a-z]+\s+[a-z]+\b',  # 英文句子模式
            r'\bThe\b|\bThis\b|\bA\b|\bAn\b',        # 常见英文开头词
            r'\bshall\b|\bmust\b|\bshould\b',        # 规范文档常用词
        ]
        
        english_matches = 0
        for pattern in english_patterns:
            matches = re.findall(pattern, zh_content)
            english_matches += len(matches)
        
        # 如果英文匹配过多，可能存在未翻译内容
        return english_matches > 10
        
    except Exception as e:
        print(f"Error checking content in {zh_file}: {e}")
        return True

def main():
    src_dir = Path("src")
    zh_dir = Path("src_zh")
    
    print("# RISC-V ISA手册翻译完整性检查报告")
    print("## 检查时间:", "2025-07-13")
    print()
    
    # 获取所有adoc文件
    src_files = list(src_dir.glob("*.adoc"))
    results = []
    
    total_files = 0
    completed_files = 0
    
    for src_file in sorted(src_files):
        zh_file = zh_dir / src_file.name
        
        if not zh_file.exists():
            print(f"❌ **{src_file.name}** - 缺少中文翻译文件")
            results.append({
                'file': src_file.name,
                'status': 'missing',
                'completion': 0,
                'src_lines': count_lines(src_file),
                'zh_lines': 0
            })
            continue
        
        total_files += 1
        src_lines = count_lines(src_file)
        zh_lines = count_lines(zh_file)
        completion_rate = analyze_translation_completion(src_file, zh_file)
        has_untranslated = check_missing_content(src_file, zh_file)
        
        status = "incomplete"
        if completion_rate >= 90 and not has_untranslated:
            status = "completed"
            completed_files += 1
        elif completion_rate >= 70:
            status = "mostly_completed"
        
        emoji = "✅" if status == "completed" else "⚠️" if status == "mostly_completed" else "❌"
        
        print(f"{emoji} **{src_file.name}**")
        print(f"  - 源文件行数: {src_lines}")
        print(f"  - 中文文件行数: {zh_lines}")
        print(f"  - 完成度: {completion_rate:.1f}%")
        if has_untranslated:
            print(f"  - ⚠️ 可能包含未翻译内容")
        print()
        
        results.append({
            'file': src_file.name,
            'status': status,
            'completion': completion_rate,
            'src_lines': src_lines,
            'zh_lines': zh_lines,
            'has_untranslated': has_untranslated
        })
    
    # 统计报告
    print(f"## 📊 总体统计")
    print(f"- 总文件数: {total_files}")
    print(f"- 已完成文件数: {completed_files}")
    print(f"- 整体完成率: {completed_files/total_files*100:.1f}%")
    print()
    
    # 需要处理的文件
    incomplete_files = [r for r in results if r['status'] != 'completed']
    if incomplete_files:
        print("## 🔧 需要处理的文件:")
        for result in incomplete_files:
            print(f"- {result['file']} (完成度: {result['completion']:.1f}%)")
    else:
        print("## 🎉 所有文件翻译完成!")

if __name__ == "__main__":
    main()