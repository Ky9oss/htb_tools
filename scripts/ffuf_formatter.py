#!/usr/bin/env python3
# ffuf_rename.py
# 前置命令：ffuf -w 1.txt -request post.txt -fw 28   -od ./ffuf_responses -o ffuf_summary.json -of json
# 用法: python3 ffuf_rename.py
# 说明:
#  - 读取 WORDLIST（每行一个 payload）。
#  - 扫描 OD_DIR 下的所有文件（递归）。
#  - 如果文件内容包含某个 payload，就把文件重命名为: <safe-payload>__<origfilename>
#  - 对冲突会追加序号。
# 注意: 若 payload 很短或在多个文件中常见，脚本会尽量按最长匹配优先，以减少误判。

import os
import re
import argparse
import pathlib
import shutil

# 配置（按需改）
WORDLIST = "1.txt"            # 你的 -w 文件
OD_DIR = "./ffuf_responses"   # -od 输出目录
DRY_RUN = False               # True 仅打印将要做的事，不真的重命名


def make_safe(name, max_len=120):
    # 把 payload 变为文件名安全的字符串
    s = name.strip()
    s = s[:max_len]
    s = re.sub(r'[\\/:"*?<>|]+', '_', s)      # 删除文件名里不允许的字符
    s = re.sub(r'\s+', '_', s)
    if s == "":
        s = "empty"
    return s


def load_wordlist(path):
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        # 过滤空行和注释行
        items = [line.rstrip("\n") for line in f if line.strip()
                 != "" and not line.startswith("#")]
    # 按长度降序排序，保证长匹配优先（减少短字符串误命中）
    items.sort(key=lambda x: -len(x))
    return items


def find_files(root):
    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            yield os.path.join(dirpath, fn)


def main():
    if not os.path.exists(WORDLIST):
        print(f"[!] 找不到 wordlist: {WORDLIST}")
        return
    if not os.path.isdir(OD_DIR):
        print(f"[!] 找不到 od 目录: {OD_DIR}")
        return

    words = load_wordlist(WORDLIST)
    print(f"[+] 载入 {len(words)} 个 payload（最长优先）")
    files = list(find_files(OD_DIR))
    print(f"[+] 扫描 {len(files)} 个文件 ...")

    renamed = 0
    for filepath in files:
        try:
            with open(filepath, 'rb') as f:
                data = f.read()
        except Exception as e:
            print(f"[-] 无法读取 {filepath}: {e}")
            continue
        # 解码为文本用于搜索（忽略解码错误）
        try:
            txt = data.decode('utf-8', errors='ignore')
        except:
            txt = str(data)

        matched = None
        for w in words:
            if w == "":
                continue
            if w in txt:
                matched = w
                break

        if matched:
            safe = make_safe(matched)
            dirname = os.path.dirname(filepath)
            base = os.path.basename(filepath)
            newbase = f"{safe}__{base}"
            newpath = os.path.join(dirname, newbase)

            # 如果目标名已存在，追加序号
            i = 1
            while os.path.exists(newpath):
                newbase = f"{safe}__{i}__{base}"
                newpath = os.path.join(dirname, newbase)
                i += 1

            print(f"[R] {os.path.relpath(filepath)
                         }  ->  {os.path.relpath(newpath)}")
            if not DRY_RUN:
                try:
                    shutil.move(filepath, newpath)
                    renamed += 1
                except Exception as e:
                    print(f"    [!] 重命名失败: {e}")
    print(f"[+] 完成。已重命名 {renamed} 个文件（DRY_RUN={DRY_RUN}）。")


if __name__ == "__main__":
    main()
