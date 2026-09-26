# ADR 0020: How we use Claude — subscriptions for development, API later

- Status: Accepted for development tooling; API access is **open** (see "Open question")
- Date: 2026-09-26
- Decision: D21

## Context

The plan assumed a dedicated Anthropic API workspace from day one (ADR 0014). Before the 2026-10-14 demo we want to avoid API spend, and after the demo we may receive free Startup credits.

## Decision

- **Development** (Claude Code): Hannes uses a personal Claude Max subscription; the collaborator uses a gifted free one-week trial pass. Accounts are never shared.
- **API**: considered after the 10/14 demo, depending on whether we receive Startup credits. The API parts of ADR 0014 (dedicated workspace, spend limit, per-developer keys) apply from that point.

## Open question: the pre-demo API gap

Paid Claude plans do not include API or Console usage; the API is billed separately. But two pre-demo items call the Messages API:

- in-app extraction (P1-11), which is demo route step 3 and the core of the demo;
- the evaluation script (P05-4), which ADR 0002 relies on.

Options (to be decided by both members before P05-4 and P1-11 start):

| Option | What it means | Effect |
| --- | --- | --- |
| A | Prepay a small Console balance now, used only for evaluation, debugging and the demo; switch to credits later | Demo and evaluation run as planned. Rough cost from the `models.yaml` prices: about a dozen dollars per full evaluation run, a few tens of dollars before the demo |
| B | No API calls before the demo | Demo route step 3 becomes manual input plus a recording; evaluation and model selection move after the demo; the demo loses its core |
| C | Run the evaluation through the Claude Agent SDK on the monthly Agent SDK credit included with the Max plan | Only a rough check: the Agent SDK call path differs from the app's Messages API calls, so it cannot back ADR 0002. The app still needs the API |

## Consequences

- The collaborator's trial pass lasts 7 days. Activate it for the critical work and agree in advance on what happens when it expires.
- `secrets.example.json` keeps the Anthropic key field so enabling the API later needs no code change.

## References

- [Paid Claude plans do not include API and Console access](https://support.claude.com/en/articles/9876003-i-have-a-paid-claude-subscription-pro-max-team-or-enterprise-plans-why-do-i-have-to-pay-separately-to-use-the-claude-api-and-console)
- [Use the Claude Agent SDK with your Claude plan](https://support.claude.com/en/articles/15036540-use-the-claude-agent-sdk-with-your-claude-plan)
