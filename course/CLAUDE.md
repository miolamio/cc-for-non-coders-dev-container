# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Course materials for "Claude Code: суперсила для НЕпрограммистов" (Season 1) by Automatica. A 5-session Russian-language intensive (Feb 24 — Mar 9, 2026) teaching non-developers to use Claude Code for everyday work automation.

Instructor: Антон Вдовиченко, CEO Automatica (@codegeek).

## Repository structure

- `course-outline.md` — detailed 5-session lesson plans (PART 1) + landing page copy (PART 2)
- `landing-page.md` — **source of truth** for marketing copy (finalized version)
- `timepad.md` — Timepad event listing (synced with landing-page.md)
- `assets/` — supplementary materials:
  - `humanizer.md` — writing style guide for removing AI-generated text patterns (used to humanize course copy)
  - `automatica-io-n8n-automation-2-0.pdf` — landing page from a previous Automatica course (n8n 2.0, Dec 2025), used as design/structure reference
- `sessions/` — organized by session number (`01-setup/` through `05-agent-teams/`), each containing `demo/` subdirectories with self-contained project examples (28 demos total)
- `.claude/skills/` — 16 reusable skills (document generation, design, MCP building, etc.)

## Content hierarchy

- `landing-page.md` is the canonical marketing copy — always defer to it
- `timepad.md` mirrors landing-page.md with minor platform-specific tweaks
- `course-outline.md` PART 2 may lag behind — if in doubt, landing-page.md wins

## Session demos

Each session folder (`sessions/01-setup/` etc.) contains a `demo/` directory with multiple self-contained example projects. Demos are practical business scenarios: financial dashboards, CRM cleanup, contract comparison, vendor evaluation, SEO audits, NPS analysis, cold outreach personalization, and more. Some demos include their own `.claude/` config (commands, settings) as teaching examples — see `sessions/04-agents/demo/slash-commands-and-hooks/` for an example.

## Language and writing rules

All content is in Russian. When generating or editing text for this project:

1. Apply the humanizer guide (`assets/humanizer.md`) — avoid AI-isms listed there (inflated significance, promotional language, rule-of-three, em dash overuse, sycophantic tone, filler phrases, etc.)
2. Use specific details over vague claims
3. Vary sentence structure naturally
4. Keep a conversational but competent tone — not corporate, not overly casual
5. No emojis in course materials unless explicitly requested

## Course structure (5 sessions, 2 academic hours each)

1. **Installation & first tasks** — setup, file organization, format conversion
2. **Context & skills** — CLAUDE.md, Skills system, slash commands
3. **MCP** — connecting external services (Google Drive, Brave Search, databases)
4. **Agents & subagents** — Task Tool, parallel processing, hooks
5. **Agent Teams** — multi-agent orchestration, n8n integration overview

## Key context

- The course uses GLM-5 as the primary AI provider (included in course price), with Claude Pro/Max and alternatives (Kimi, OpenRouter) as options
- Target audience: entrepreneurs, managers, analysts, marketers — no programming experience required
- The previous Automatica course (n8n 2.0) PDF serves as a template for landing page structure and visual style
- Pricing: 29,000 ₽ early bird / 39,000 ₽ regular / 49,000 ₽ corporate