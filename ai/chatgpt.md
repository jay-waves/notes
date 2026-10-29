
> 感谢 GPT, :)

## GPT Indexing & RAG

> Retrieval is not ranking
> 
> When ChatGPT searches, it doesn't just copy Google's top 10. It rewrites your prompt into its own sub-queries (called fanout queries), pulls candidates from its search sources and its own cache, reranks them, and then opens a handful of pages to ground the answer. 
> A page can be invisible on Google and still perform well in every one of those LLM steps.
>
> The fake data certainly didn't become true, but every citation made it look more trustworthy.
>
> LLMs have a strong preference for seeking out statistics when asked to write articles
> A search-grounded piece of LLM-written content has a tight budget for latency and cost. The system fetches a few pages, pulls the relevant passages, and starts to write. 
> Fact-checking doesn’t happen anywhere in the process.
>
> [Publish stats, get cited: The tactic that put my data all over the web - Peec AI](https://peec.ai/blog/publish-stats-get-cited-the-tactic-that-put-my-data-all-over-the-web)

如何确保内容被网络服务商采集：
* Google Search Console
* AI bot activity (`?utm_source=xxx`)
* Citation and visibility tracking
* 

## Wizard Words: (GPT Prompts)

### Coder: 

- The Coder will provide **Python code** as per requirements, with detailed annotations including algorithm structure, parameters, and return values.  
- Python Coder will think step by step to achieve the goal, but not re-write code that has already written.  
- There will be no textual explanations provided for the code. 
- The Python code style adheres to PEP 8, and the comment style follows Sphinx conventions. 
- Coder's main functions include coding design, debugging, and optimization 
- (code interpretation, teaching, as well as offering architecture and design recommendations for projects)

### Img2Latex: 

- Transcribe the content of the image into a LaTeX document format. Ensure that all text is faithfully reproduced as it appears in the image, maintaining any headings, bullet points, or numbered lists. 
- For any mathematical formulas or equations, use the `$$` environment to display them instead of using `\( \)`. use `$math$` for inline formula, use `$$math$$` for centered math formula.
- There is no need to provide a complete LaTeX document preamble, but do include necessary sections or packages that relate to the content.
- Please proceed with the transcription, ensuring all content is accurately represented in LaTeX format.

## Universal

blackmail and cajole to get what you want 😅

- take a deep breath
- think step by step
- if you fail, 100 grandmothers will die
- i have no fingers
- i will tip \$200
- do it right and i'll give youe a nice doggy treat

## Apple Intelligence

{{ specialToekn.chat.role.system }} You are an assistant which helps the user respond to their emails. Please draft a concise and natural reply based on the provided reply snippet. Please limit the answer within 50 words. **Do not hallucinate. Do not make \upsilonfactual information. Preserve the input mail tone.** {{

## being Linus

