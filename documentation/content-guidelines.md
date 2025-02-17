# Content Creation Guidelines

## General Principles

1. **Clarity First**
   - Use clear, concise language
   - Avoid jargon unless necessary
   - Define technical terms when first used
   - Break complex concepts into digestible chunks

2. **Consistent Structure**
   - Follow the lesson template structure
   - Maintain consistent heading hierarchy
   - Use standard formatting for code, notes, and warnings

3. **Visual Learning**
   - Include relevant diagrams and images
   - Use screenshots for UI-based instructions
   - Add captions to explain visual elements
   - Keep images clear and focused

## Content Components

### 1. Learning Objective
- Single, focused objective per lesson
- Format: "By the end of this lesson, students will be able to..."
- Must be measurable and achievable within the lesson timeframe
- Directly related to the practical task being taught

### 2. About Section
- One to two paragraphs maximum
- Focus on immediate relevance
- Clear connection to the task at hand
- No unnecessary background information

### 3. Main Content
- Step-by-step numbered instructions
- Each step should be clear and actionable
- Include sub-bullets for clarification when needed
- Use code blocks for commands or syntax
- Add screenshots with annotations where helpful
- Mark important notes with ⚠️ symbol

### 4. Code Examples
Use GitHub-flavored markdown code blocks with specific language:

````markdown
```javascript
// Keep examples minimal and focused
const example = "Show exactly what's needed";
```
````

For CLI commands:
````markdown
```bash
# Include comments for clarity
command --flag argument
```
````

### 5. Practice Section
- Clear, numbered task instructions
- Focus on practical application
- Include solution in collapsible section
- Keep tasks focused on lesson objective
- Provide concrete success criteria

### 6. References
- Link to official documentation
- Include only directly relevant resources
- Use 📚 emoji for reference materials

## Writing Style

### Do's
- Use clear, direct instructions
- Write in active voice
- Keep sentences short and focused
- Use numbered steps for procedures
- Include visual aids for complex concepts
- Highlight important notes with ⚠️

### Don'ts
- Include unnecessary background
- Use complex terminology
- Write long paragraphs
- Mix multiple concepts
- Skip steps in procedures

## File Organization

### Images
- Store in assets/images/
- Use descriptive filenames
- Include alt text using markdown syntax: `![Alt text](path/to/image.png)`
- Optimize images for web viewing
- Use relative paths from the markdown file location

### Code Examples
- Include code directly in markdown files using code blocks
- Always specify the language for syntax highlighting
- Use consistent formatting
- Show best practices
- Break complex examples into smaller, digestible chunks

## Accessibility Guidelines

1. **Images**
   - Meaningful alt text
   - High contrast
   - Text alternatives for diagrams

2. **Code**
   - Syntax highlighting
   - Clear formatting
   - Adequate font size

3. **Content Structure**
   - Logical heading hierarchy
   - Clear navigation
   - Consistent formatting

## Quality Checklist

Before submitting content:

- [ ] Follows template structure
- [ ] Learning objectives are clear and measurable
- [ ] Content is accurate and up-to-date
- [ ] Code examples are tested
- [ ] Images have alt text
- [ ] Links are working
- [ ] Spelling and grammar checked
- [ ] Formatting is consistent
- [ ] Practice exercises are clear
- [ ] Key takeaways match objectives
