# Research Prompt: Codex Token Efficiency

Use this prompt to research why Codex sessions are consuming very high input tokens with relatively little output, for example `4.5M input tokens` and `40k output tokens`.

```md
You are an expert in AI coding-agent workflows, context engineering, prompt design, and token-cost optimization.

Task:
Research concrete options to reduce extreme input-token usage in Codex sessions where usage looks like roughly 4.5M input tokens and 40k output tokens.

Context:
- This is happening in Codex-style coding sessions on a local repository.
- I want practical ways to reduce input-token burn without materially harming correctness or autonomy.
- I care about both root-cause diagnosis and actionable fixes.
- Assume the agent may be repeatedly re-reading large instructions, large files, large diffs, plans, logs, or conversation history.

Research goals:
1. Identify the most likely causes of very high input-token usage with low output-token usage.
2. Separate unavoidable input-token costs from wasteful or avoidable ones.
3. Recommend multiple solution paths, including low-effort quick wins and higher-leverage structural changes.
4. Explain tradeoffs: token savings vs reliability, context quality, and implementation effort.
5. Prioritize the best options for someone actively using Codex in a real repo.

Focus areas to evaluate:
- Large AGENTS.md / instruction files and repeated instruction ingestion
- Re-reading too many files or reading files that are larger than necessary
- Overly verbose planning artifacts, plan churn, or repeated status updates
- Excessive tool output being fed back into the model
- Repeated diff reads, log reads, and test-output reads
- Context accumulation across long sessions
- Whether subagents help reduce or increase total token usage
- Summarization / compression strategies for long histories
- File-selection / retrieval strategies instead of broad scanning
- Prompt changes that reduce unnecessary analysis verbosity
- Model / workflow choices that change token efficiency
- Guardrails for when to reset context or start a fresh thread

Questions to answer:
1. What are the top 5-10 most plausible drivers of a 4.5M-in / 40k-out pattern in Codex?
2. Which of those are usually the biggest contributors in practice?
3. What workflow changes would most likely reduce input tokens quickly?
4. What repo-level changes would help, such as trimming instruction files, shortening plans, or tightening file-discovery rules?
5. What tool-usage changes would help, such as limiting command output, avoiding repeated file reads, or summarizing logs?
6. When should a user prefer a fresh session, handoff summary, or narrower task decomposition?
7. Which changes are safest, and which create unacceptable risk of missed context?
8. What concrete experiments should I run to measure improvement?

Method requirements:
- Build a causal model first: where the input tokens are probably being spent.
- Distinguish evidence-based guidance from inference.
- Prefer current official documentation and primary sources when available.
- If exact Codex internals are not public, infer carefully from observable agent behavior and state that clearly.
- Do not give generic "use fewer tokens" advice without specific implementation guidance.

Output format:
1. Executive summary
2. Likely root causes ranked by impact
3. Recommended interventions ranked by impact / effort
4. Quick wins I can apply immediately
5. Structural changes for sustained reduction
6. Risks and failure modes of over-optimizing context
7. Measurement plan

For each recommended intervention, include:
- What to change
- Why it should reduce input tokens
- Expected impact: low / medium / high
- Implementation effort: low / medium / high
- Risk to quality or correctness: low / medium / high
- Whether it is a prompt change, workflow change, repo change, or tool change

End with:
- A prioritized top-3 action plan for my next Codex session
- A sample "lean Codex workflow" that minimizes input tokens while preserving quality
```
