# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Chinese character learning material repository for kindergarten senior class (大班) children. The materials include teaching images and structured lesson content.

## Repository Structure

```
studyChina/
├── *.jpeg                    # Teaching images (汉字教学法, 提高专注力, 词语和短文教学, etc.)
├── word.md                   # Lesson content - Chinese characters organized by lesson (第1课-第30课)
├── studyWay.md               # Teaching methodology documentation
└── .playwright-mcp/          # Playwright test artifacts (can be ignored)
```

## Content Description

- **word.md**: Contains 30 lessons (第1课-第30课) of Chinese characters for kindergarten children
- **studyWay.md**: Teaching methods including 汉字教学法, 提高专注力, 词语教学法, and 短文教学法
- **JPEG images**: Visual teaching materials for different teaching modules

## Working with This Repository

This is a content repository, not a software project. No build, test, or lint commands apply.
When processing images for OCR or text extraction, use vision-capable models (e.g., Qwen2-VL, GPT-4V).
