# Claude Code Cheat Sheet

You interact with Git through Claude Code (CC), not by typing Git commands. This page covers what to say to CC in the most common situations.

## Before You Start Working

Every time you sit down to work, start with:

> "Pull the latest changes"

This gets Dave's latest work onto your machine. Do this first, every time. It takes a few seconds and prevents almost all problems.

**Check your starting point.** After pulling, it's good practice to ask:

> "Is my branch clean? Any uncommitted changes?"

If CC says you have uncommitted changes from a previous session, decide: commit them, or discard them. Don't start new work on top of old uncommitted changes.

## The Daily Workflow

### 1. Pull latest

> "Pull the latest changes"

### 2. Do your work

Edit files in your text editor, Godot, or through CC. When you're ready to save a checkpoint:

### 3. Commit your work

> "Commit my changes with message 'add anxious dialogue for fog forest'"

Or if you want CC to write the message:

> "Commit my changes"

CC will look at what you changed and write an appropriate commit message.

**Commit often.** Small, frequent commits are better than one giant commit at the end of the day. Each commit is a checkpoint you can return to.

### 4. Push to share

> "Pull the latest changes, then push"

Always pull before pushing. You can say this as one instruction — CC handles the sequence.

## Common Situations

### "I edited a few files but only want to commit some of them"

> "Commit just data/dialogue/fog_forest.json with message 'add fog forest dialogue'"

Or:

> "Commit only the files in data/dialogue/"

### "I want to see what I've changed before committing"

> "Show me what files I've changed"

or

> "Show me the diff"

CC will show you a list of modified files and what changed in each one.

### "I made a mistake in my last commit"

If you haven't pushed yet:

> "Undo my last commit but keep the changes"

This removes the commit but leaves your files as they are, so you can fix things and commit again.

If you already pushed:

> "Revert my last commit"

This creates a new commit that undoes the previous one. Your mistake is still in history, but the current state is fixed.

### "I want to see what Dave has been working on"

> "Show me the recent commits"

or

> "What changed in the last few commits?"

### "I want to get a fresh start — throw away all my uncommitted changes"

> "Discard all my uncommitted changes"

**Be careful with this one.** It permanently deletes any work you haven't committed. CC will usually ask you to confirm.

### "I want to start a GSD task for my work"

> "/gsd-quick add new dialogue lines for the fog forest region"

See [GSD Basics](gsd-basics.md) for more on organizing your work.

## When Something Goes Wrong

### Push rejected — "someone else pushed first"

This means Dave pushed while you were working. Normal and harmless.

> "Pull the latest changes and then push again"

Most of the time, this just works — Git combines your changes with Dave's automatically.

### Merge conflict in a file you own

If the pull creates a conflict in a file you know (like a dialogue JSON or a doc you wrote):

> "Show me the conflict in data/dialogue/lantern_clearing.json"

CC will show you both versions. Then:

> "Keep my version" or "Keep Dave's version" or "Combine them like this: [explain what you want]"

After resolving:

> "Mark the conflict as resolved and commit"

### Merge conflict in a file you don't own

If the conflict is in a `.gd` file, a `.tscn` file, or anything in `.planning/`:

> "Abort the merge"

Then message Dave: "Hey, I've got a merge conflict in [filename] — can you sort it out?"

Don't try to resolve conflicts in code files. It's not your zone and you might break something.

### "Something broke and I don't know what happened"

Don't panic. Say to CC:

> "Show me git status — what's the state of the repo?"

Tell CC what you were trying to do and what went wrong. If CC can't help, tell Dave. Between the commit history and Dave's experience, anything can be fixed.

### "CC is asking me something about Git that I don't understand"

It's fine to say:

> "Explain what you're asking in plain English"

or

> "What's the safest option here?"

CC will walk you through it. If you're still unsure, pick the safe option or ask Dave.

## End of Session Checklist

Before you close Claude Code for the day:

1. **Commit any remaining work:** "Are there any uncommitted changes?"
2. **Push everything:** "Push my commits"
3. **Quick status check:** "Is everything pushed and clean?"

If CC confirms everything is pushed and clean, you're good. Your work is safe on GitHub and Dave can see it.

## Quick Reference

| I want to... | Say to Claude Code |
|---|---|
| Start my session | "Pull the latest changes" |
| Check for uncommitted work | "Is my branch clean?" |
| Save a checkpoint | "Commit my changes" |
| Save and share | "Pull latest, then commit and push" |
| See what I changed | "Show me the diff" |
| Commit specific files | "Commit just [filename]" |
| Undo last commit (not pushed) | "Undo my last commit but keep the changes" |
| Undo last commit (already pushed) | "Revert my last commit" |
| Fix a merge conflict (my file) | "Show me the conflict in [file]" |
| Fix a merge conflict (not my file) | "Abort the merge" then tell Dave |
| Throw away uncommitted changes | "Discard all my uncommitted changes" |
| See recent history | "Show me the recent commits" |
| End of session | "Is everything pushed and clean?" |
