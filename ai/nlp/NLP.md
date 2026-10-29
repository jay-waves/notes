
## LLM Training Pipline

Translation task (en -> zh_tr)
* Pretraining: teaching the model to predict the next token in a sequence using a large bilingual 
    corpus of text data
* Supervised Fine-Tuning (SFT): refining the models's translation capabilities in general domains
* Low-Rank Adaptation (LoRA): Efficientlly adapting the model's translation capabilities to 
    specific domains (finance) without full fine-tuning
* Direct Preference Optimization (DPO): further improving capabilities using pairs of choose/reject 
    responses

## NLP tasks

NLP 主要指自然语言文本的处理。语言分析主要分为几个层次：词法、语法、语义、语用 (Lexical, Syntax, 
Semantic、Pragmatics). [^1]

[^1]: 这里略过 Morphology (形态学) 和 Lexicology (词汇学） 等传统语言学

NLP 的主要困难是，词法、词义、结构都存在大量歧义 (ambiguity), 并且，语言本身也在不断发展，
出现新的语言现象（流行词、术语、新含义或用法）。

NLP 常见的任务：

* 分词 (Tokenize)
    * Tokenization and Word Embedding
    * Lingua 短文本的语言识别
    * BudouX 让中日韩文本在合适的语义位置换行
    * SaT 没有可靠标点或换行混乱（OCR或转写处理后）的文本切分
    * [flashtext](https://github.com/vi3k6i5/flashtex) 关键词识别替换
* 语法与句法分析
    * 词性标注
    * 依存句法分析
    * 共指消解 (Coreference Resolution)
    * 关系抽取 (Relation Extraction)
* 语义理解（分类、识别）
    * 文本分类
    * 语义相似度 (Semantic Textual Similarity STS)
    * ftfy 乱码修复
    * NER (Named Entity Recognition)
* 检索和排序 (Retrieval)
* Sqeuence-to-Sequence
    * 翻译 (Machine Translation, MT)
    * 文本纠错
    * 文本摘要


