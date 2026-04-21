---
created: 2026-04-21
tags: [idea, vertical, thoughts]
---

# Thought Capture Vertical Idea

A new vertical for quickly capturing internal thoughts — distinct from [[Kioku Bookmark App Name|Kioku/Kyoku]], which handles external bookmarks and things shared from outside. This is for personal, self-generated thoughts and ideas.

The app should have a Japanese name meaning "thought" (e.g. 念, 想, 考え) — something that reflects its internal, reflective nature.

## Core Concept

Fast, frictionless capture of personal thoughts, with automatic categorization, tagging, and connections between thoughts. Not just a dump — a queryable, connectable knowledge base of your own mind.

## Platform Coverage

**API**
- Full CRUD: create, list, get, update thoughts
- Auto-categorization and tag extraction from thought content

**Web App**
- Full CRUD UI
- Search by topic, tag, or connection
- View thought stats and connections

**Chrome Extension**
- Quick-capture a new thought from within the browser, without switching context

**Mobile App**
- Slim and lean — full CRUD
- Home screen widget for instant thought capture
- Thoughts dropped to DB immediately and connected to related entries

## Features

- **Auto-categorization**: classify thoughts automatically (e.g. question, reminder, insight)
- **Auto-tagging**: extract multiple tags from a single thought so they can be linked
- **Connections**: thoughts can be linked to one another; view related thoughts when querying
- **Stats**: how many thoughts created today, how many connections exist, etc.
- **Search**: query by topic and get all connected or related thoughts listed

## Background

Previously tried GhostScript but it didn't work well — thoughts got lost. Need something purpose-built for this use case. Kyoku handles external input; this handles internal output.

## Related

- [[Kioku Bookmark App Name]]
- [[Bookmark Vertical Idea]]
