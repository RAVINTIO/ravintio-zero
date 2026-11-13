---
title: "Strict testing standards"
summary: "Contract tests, mutation testing, and browser checks that the strict-testing archetype requires."
status: "active"
version: "0.1.0"
---
# Strict testing standards

The strict-testing archetype adds two P3 gates. The pack installs none of the tools below. You install them in your project.

## Contract tests

Each component API has a Pact contract file. Write the contract with Pact. The `pact-contracts` gate fails when a component has no contract file.

## Mutation testing

Run Stryker for JavaScript and TypeScript, or PIT for Java and Kotlin. The report must show a mutation score of at least 80. The `mutation-score` gate reads the report and fails below the threshold.

## Browser checks

Install the Playwright MCP server so the agent can drive a browser. Use it to check UI behaviour before you accept a UI change. The `setup` field in `archetype.json` describes the server entry.

## Raise the bar

You can raise `mutation-score` in `archetype.json`. Don't lower it below 80.
