# Style Guide

## File and Directory Naming

### Directories
- Use lowercase with hyphens: `01-introduction-to-git`
- Include numerical prefixes: `01-`, `02-`, etc.
- Keep names concise but descriptive

### Files
- Use `README.md` for lesson content
- Use lowercase with hyphens: `git-workflow.png`
- Include file type in name when relevant

## Markdown Formatting

### Headers
```markdown
# Lesson Title
## Main Section
### Sub-section
```

### Text Formatting
- **Bold** for emphasis: `**important**`
- `code` for technical terms: `` `git commit` ``
- ⚠️ for important notes: `⚠️ Warning message`
- 📚 for references: `📚 Reference link`

### Lists
- Numbered lists for sequential steps
- Bullet points for non-sequential items
- Indent with 2 spaces for sub-items

### Code Blocks
````markdown
```javascript
// Code example
const example = "value";
```

```bash
# Command example
git commit -m "message"
```
````

### Links
- Internal: `[Next Lesson](../02-lesson-name)`
- External: `[Git Documentation](https://git-scm.com)`
- References: `📚 [Reference](link)`

### Images
```markdown
![Alt text](../../assets/images/example.png)
```

## Content Structure

### Lesson README
1. Title
2. Learning Objective
3. About
4. Main Topic
5. Practice
6. References

### Code Examples
```javascript
// Good example - clear and focused
function commitChanges(message) {
  // Add descriptive comment
  return gitCommit(message);
}

// Bad example - unclear and verbose
function doGit(m) {
  return gitCommitChangesToRepoWithMessage(m);
}
```

### Command Examples
```bash
# Good example - with comment
git add . # Stage all changes

# Bad example - no context
git add .
```

## Writing Style

### Voice and Tone
- Direct and clear
- Step-by-step instructions
- Present tense
- Active voice
- Technical but approachable

### Technical Writing
- One concept per step
- Clear success criteria
- Minimal background info
- Focused examples
- Practical instructions

### Formatting Conventions
- Use backticks for:
  - Commands: `git status`
  - File names: `README.md`
  - Branch names: `main`
- Use warning symbol for:
  - Important notes: ⚠️
  - Common mistakes: ⚠️
  - Critical steps: ⚠️

## Version Control

### Commit Messages
```
feat: Add git workflow lesson
fix: Correct command syntax in clone example
docs: Update markdown formatting
```

### Branch Names
- feature/add-git-lesson
- fix/command-syntax
- docs/update-formatting

## Documentation Standards

### Comments
- Use HTML comments for internal notes
- Keep comments concise
- Remove before publishing

### Practice Solutions
```markdown
<details>
<summary>Click for solution</summary>

\```bash
git clone https://github.com/user/repo.git
cd repo
git checkout -b feature
\```
</details>
```

### Important Notes
```markdown
⚠️ Always create a new branch before making changes

📚 For more details, see the [Git documentation](link)
