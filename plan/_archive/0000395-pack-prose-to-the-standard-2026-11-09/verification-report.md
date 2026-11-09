# Verification report - 0000395-pack-prose-to-the-standard

I ran the checks on the committed tree.

## REQ-001

- AC-1 verified. Method: ran `node ravintio-zero/scripts/prose-check.mjs check --baseline /tmp/step19-empty.json --files` over each slice list. Every list printed `ok`, except the six applied migrations, which a test pins to `main`.
- AC-2 verified. Method: each slice agent compared the rule anchor ids before and after. The orchestrator tests that read anchors pass.

## REQ-002

- AC-1 verified. Method: read `plan/state/prose-baseline.json`. The only keys outside `plan/` are the six `ravintio-zero/migrations/_done/` files.
- AC-2 verified. Method: ran the full suite in a clean clone. Only the two inherited suites fail.
