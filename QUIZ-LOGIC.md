# The Exponential You Assessment — Quiz Logic Spec

Source of truth: `exponential-you.html` (single file, all logic inline JS, no dependencies).
Live: https://marisha-mv.github.io/manifesting-quiz/exponential-you.html

## 1. High-level model

**One engine, four branches.** The first question ("What are you trying to grow?") selects a branch — `biz`, `career`, `craft`, or `self`. The branch never changes the scoring; it changes:

- the wording of the stage question and ~14 of the 30 scenario questions
- which real student stories are shown as proof (casting)
- the **default pathway** recommended at the end

The diagnosis itself is universal: **10 bottlenecks** grouped into **4 systems**:

| System | Bottlenecks (id) |
|---|---|
| The Engine · Energy | 1 Running on Fumes · 2 The Recovery Debt |
| The OS · Psychology | 3 The Identity Ceiling · 4 The Impostor Loop · 5 Scarcity OS |
| The Multiplier · Leverage | 6 The Control Trap · 7 Lone Wolf Syndrome |
| The Compass · Vision & Life | 8 The Drift · 9 The Shiny Object Cycle · 10 The Deferred Life |

## 2. Screen flow (in order)

1. **Intake (4 answerable screens):** `grow` (branch select) → `stage` (branch-specific wording, e.g. revenue bands for biz, audience size for craft) → `hours`/week → `want` (where 10 reclaimed hours would go). These 4 personalize copy only — they are **not scored**.
2. **Four sections**, one per system. Each section = 1 info/education screen → **6 scenario questions** → 1 social-proof screen (3 real student stories, cast per branch from the `PROOF` table).
3. **Loader** — cosmetic 5.5s "Building your Bottleneck Profile" animation. No computation happens here.
4. **Email gate** — first name + email + consent checkbox (consent NOT required to proceed). Submits the lead payload, then advances regardless of network result.
5. **Results** — diagnosis screen.
6. **Bridge** — "why working harder hasn't fixed it" persuasion screen.
7. **Plan** — pathway recommendation + 12-week curriculum + membership offer + checkout.

Progress bar counts 34 answerable steps (4 intake + 30 questions). Back button works everywhere except loader/gate/results/bridge/plan.

## 3. Scoring

- 30 scenario questions, every answer has a value **1–5** (1 = healthy, 5 = severe). Emoji/label order always presents healthiest first.
- Each bottleneck owns exactly 3 consecutive questions: block *n* ← questions `3n−2 … 3n` (block 1 = Q1–3, block 2 = Q4–6, … block 10 = Q28–30).
- **Block score = sum of its 3 answers → range 3–15.** No weighting, no branch adjustment.
- Blocks are sorted by score descending. `topBlock` = highest score. Ties resolve by array order, i.e. **lower block id wins** (energy beats psychology beats leverage beats compass).
- Severity meter on results = `score / 15` as a percentage.

## 4. Pathway recommendation

```
if topBlock.id ∈ {1, 2}  →  Ageless Body        // energy override: "you can't grow anything on a dead battery"
else                     →  branch default:
   biz    → The Exponential Entrepreneur (26 programs)
   career → The Exponential Entrepreneur
   craft  → The Authority (14)
   self   → The Extraordinary Mind (24)
```

So there are only 4 possible pathway outcomes, and Ageless Body is reachable from any branch (only via the energy override).

## 5. The 12-week plan (3 phases)

- **Phase 1 = the program mapped to the user's #1 bottleneck** inside the recommended pathway, from `PATHWAY_MAPS[pathway][topBlockId]` — a 10-row lookup per pathway (every program verified in-pathway against the canonical pathway Airtable, July 2026). One override: **career branch + EE pathway + bottleneck 6 (Control Trap)** → Ultimate Leadership (Ferrazzi) instead of Scale Your Business.
- **Phases 2–3 = the pathway's fixed flagship arc** (`PATHWAY_ARCS[pathway].p2/.p3`). Career-on-EE uses a separate `ee_career` arc (Vivid Vision → The Transformational Leader).
- **Dedup rule:** if the Phase-1 program already occupies an arc slot, that slot pulls the next program from the pathway's ordered `backups` list, so the 3 phases are always distinct.

## 6. Results-page personalization

- Diagnosis card interpolates intake phrases: what they're growing, stage phrase, hours phrase, want phrase + top block score/desc.
- **"Your own answer" quote card:** finds the highest-scoring question inside the top block; if that answer ≥ 4, replays the exact question + their chosen answer label back at them.
- Proof story next to the diagnosis: the story attached to the Phase-1 program (`questAssets[quest].proof`) if one exists, else the first story of the branch's results wall.
- Shows top-3 bottlenecks ranked (score /15), then all 10 as bars, then a "your top 3 span N of the 4 systems" chain insight.

## 7. Offer, pricing, checkout

- Tiers: **Monthly $49** / **Yearly $199 (struck from $299, "$100 OFF", default-selected, per-day framing $0.55 vs $0.82)**.
- Checkout: `secure.mindvalley.com` checkout_link API is prefetched when the plan screen mounts (`D7I02BYFN69URS4OQTEH` monthly, `DAR8S3TNQGFU4CWL7HP0` yearly); if the API doesn't resolve, hardcoded fallback flow URLs are used (charge plans `su|1446` / `su|1447`, yearly carries discount code `ORHPXJZIA`).
- Appended params: `utm_source=quiz`, `utm_medium=exponential-you`, `utm_campaign=<pathway key>`, `utm_content=<tier>`, `utm_term=<top-bottleneck-slug>`; ad click IDs (`gclid/fbclid/gbraid/wbraid/ttclid`) passed through from the landing URL; inbound UTMs re-forwarded prefixed `src_*`.
- **15-minute discount timer**, persisted in `localStorage` (key `mv_expyou_quiz_discount_expiry`, resets after 24h). At 0:00 it does NOT remove the discount — copy flips to "your $100 discount is still being held."
- Guarantee framing: 15-day money-back tied to doing week 1 of their Phase-1 program.
- **Exit ramp:** free masterclass link per pathway (Be Extraordinary masterclass for ee/auth/mind, 10X masterclass for body), tagged `utm_content=exit-ramp`.

## 8. Lead capture payload

`POST /api/submit-lead` (relative URL, `keepalive: true`, silent on failure):

```json
{
  "version": "exponential-you-v1",
  "firstName": "...", "email": "...", "consent": true,
  "submittedAt": "ISO-8601",
  "grow": "biz|career|craft|self",
  "stage": "pre|s1|s2|s3", "hours": "u40|h50|h70|h99",
  "want": "scale|health|family|think",
  "recommendedPathway": "ee|auth|mind|body",
  "topBlocks": [{ "id": 1, "name": "...", "score": 13 }],
  "allScores": [ /* all 10 */ ],
  "rawAnswers": { "1": 4, "...": "..." },
  "utm": { "source": "...", "medium": "...", "campaign": "...", "term": "...", "content": "..." },
  "referrer": "...", "userAgent": "..."
}
```

⚠️ On GitHub Pages there is no backend, so this endpoint 404s silently — leads are currently **not** captured (known open blocker). The pathway recommendation is computed at gate-submit time and included in the payload, so the CRM gets the full diagnosis without re-deriving it.

## 9. Known quirks (as of commit `9113c1f`)

1. **Dead branch in pathway copy:** the plan screen checks `pw.key === 'lon'` to show the energy-override explanation, but the energy pathway's key is `body` — so the energy-specific "why this pathway" copy never renders; the generic version shows instead. One-line fix.
2. **Dead fallback:** `FREE_CLASS[pw.key] || FREE_CLASS.man` — the `man` key doesn't exist, but `pw.key` is always valid, so it's unreachable.
3. Consent checkbox is optional by design — unchecked leads still submit with `consent: false`.
4. All stories are real, sourced from stories.mindvalley.com; photos self-hosted in `photos/`, with an initials-avatar fallback on image error.
