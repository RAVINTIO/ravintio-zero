---
title: "Requirement: REQ-004 - ordered pickup and staleness review"
summary: "P0 offers entries in index order, and a review lists stale entries."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-004 - ordered pickup and staleness review

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000321-backlog-triage
**Source:** US-003, US-004
**Priority:** must-have

## User Story

As a developer, I see entries at P0 in priority and theme order, so that pickup starts with what matters most. As a maintainer, I get a list of entries older than the review age, so that I can drop or confirm each one.

## Functional Requirements
- `backlog-index.mjs --review` lists each entry whose age exceeds the review age, as id, slug, and days. An entry with no readable `**Date filed:**` is listed as undated. The script exits 0.
- The review age is `backlogReviewDays` in `product.yml`, default 5. A value that is not a positive integer reads as 5.
- `--today YYYY-MM-DD` fixes the clock. Age is whole days from the date filed to today.
- `ravintio-zero/templates/product.template.yml` documents `backlogReviewDays`, and this repo's `product.yml` sets it to 5.
- Discovery Start Actions step 10 runs `--review` first and asks whether each stale entry still applies. It then offers entries in index order. A pull-in or discard regenerates the index in the same commit.

## Acceptance Criteria
- [ ] AC-1: review lists a stale entry
  - Given an entry filed 6 days before the fixed date and one filed 2 days before
  - When the script runs with `--review`
  - Then it lists the first and not the second
- [ ] AC-2: age comes from product.yml
  - Given `backlogReviewDays: 10` in `product.yml`
  - When the script runs with `--review` and an entry is 6 days old
  - Then it lists nothing
- [ ] AC-3: step 10 uses the index order
  - Given Discovery Start Actions step 10
  - When a test reads it
  - Then it names `--review`, the index order, and the index regeneration

## Dependencies
REQ-002
