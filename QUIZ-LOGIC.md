# The Exponential You Assessment — Quiz Logic Spec (v2, 5-question engine)

Source of truth: `exponential-you.html` (single file, all logic inline JS, no dependencies).
Live: https://marisha-mv.github.io/manifesting-quiz/exponential-you.html

> **v7 (Aug 2026, deep-sell results — Marisha teardown):** the bridge now runs a full sell per pathway from `PATHWAY_STORY`: root cause → **what it's costing you / why you can't move until it's fixed** (new `cost` beat) → let-go/call-in → **three concrete milestones (by month 3 / 6 / 12)**, specific and visceral (e.g. Mystic month-3 = clear fear-based money blocks built young → month-6 manifestations appear → month-12 '20 right decisions instead of 20 wrong ones') → two-futures chart with a plain-language grey-vs-purple read ('both roads get there, one is years faster') → 3 distinct in-pathway testimonials → transition line. The plan screen: 'the personalised curriculum we've mapped for you', each phase card uses `PROGRAM_WHY` (customer-language, e.g. Art of Manifesting = 'zero in on the ONE idea'; Unlimited Abundance = 'the switch — deals land in your lap'; Duality = 'create synchronicities') + a per-phase testimonial that MUST back up that program (`PROGRAM_PROOF`, exact-quest match keeps the badge, otherwise a real in-pathway student with the badge hidden — never a mismatched label), then a readiness CTA ('Are you ready to become X? This is that decision.'). Added real testimonials: Unlimited Abundance (Alison LeBruns), Art of Manifesting (Julie Pippin). Proof deduped by quest (`diverseWall`).

> **v6 (Aug 2026, customer-psychology bridge):** the bridge screen now runs a real sell, driven by a `PATHWAY_STORY` object (one per pathway). Arc: best-version identity → their own words → **the real reason it hasn't happened** (pathway-specific psychology, e.g. love = "loving from a checklist + doesn't feel safe to be seen") → **Let go of / Call in** ledger → **your next 3 months** + **your next 12 months** transformation (woven with their dream) → two-futures chart → **why this exact roadmap** (names the actual in-pathway programs) → in-pathway proof → CTA. All grounded in the verified pathway programs. Verified across all 6 pathways.

> **v5 (Aug 2026, persuasion arc — Raffaele):** the results no longer jump to the offer. After the gate there are now TWO beats: a **bridge** screen that runs the full arc — best-version identity → their own words → **The gap → Why this one thing decides everything → What another year of this costs (+ divergence chart) → Why a pathway, not another course → in-pathway proof** → "Show me my 12-week pathway" — then the **plan** screen makes the offer (compact pathway header → 12-week phases → stack → timer → tiers → guarantee → wall → exit ramp). All persuasion copy is assembled from the user's own dream/deeper answers + their named bottleneck. Also: added one verified photo'd Authority testimonial (Dijana Llugolli / Magnetic Charisma); other newly-sourced auth+conn testimonials are real names/quotes with initials avatars (stories.mindvalley.com doesn't expose per-reviewer photos scrapably).

> **v4 (Aug 2026, homepage six-pathway flagship):** this is now the mindvalley.com **homepage** quiz, reframed around **"designing the best version of you"** (aspiration-first, not bottleneck-first). Slide 1 is a **six-goal grid** — one per Mindvalley pathway — replacing the old four business-ish branches: 🚀 work & money → Exponential Entrepreneur · ✨ inner world & manifesting → **Modern Mystic** · 🧠 mind & potential → Extraordinary Mind · ❤️ find love & deepen relationships → **Art of Connection** · ⚡ body & energy → Ageless Body · 🎤 voice & influence → Authority. Modern Mystic + Art of Connection (maps, 12-week arcs, program covers, proof) were ported from `mv-quiz.html` (canonical Airtable). New `relationships` theme (block 11) + `The Disconnection` block. Routing: energy blocker (1/2) → Ageless Body; relationship blocker (11) → Art of Connection; else the goal's default pathway. Identities add **The Modern Mystic** and **The Connected {noun}**. Headline: "Design the Best Version of You". Open "dream" prompt is now "Picture the best version of you a year from now…". Fixed: spiritual "energy" no longer mis-routes manifesters to Ageless Body (physical-only energy keywords); recognition vs identity crystallize labels de-duped; "The full The X pathway" double-The. Verified end-to-end via jsdom across all 6 goals + both override paths. **This makes exponential-you the flagship; mv-quiz.html is now redundant.** Proof is now cast PER PATHWAY (`PATHWAY_WALL`) — every testimonial comes from a quest inside that pathway; branch-based `PROOF` removed. No Lifebook (Camille) testimonial anywhere. Authority + Art of Connection walls use real stories sourced from stories.mindvalley.com (Magnetic Charisma, Total Self-Confidence; Conscious Parenting, Calling in "The One").

> **v3 (Aug 2026, open-ended Deep Dive):** replaced the click-only Q3/Q4 with **two free-text captures** (Ryan Levesque "single most important question" style) + a **generated follow-up** + a **crystallize** screen whose options are built from detected themes. Everything is assembled client-side from what they typed — no backend, no API key — so the follow-up and the whole results page read bespoke. Flow is now **4 answerable steps**: `grow` (click) → `dream` (open) → `deeper` (open, prompt generated from their dream) → `block`/crystallize (click, options generated from their themes). A `THEMES` lexicon (freedom/money/recognition/energy/identity/presence/focus) scores the free text via `detectThemes()`; the dominant theme drives the profound follow-up, the crystallize options, the bottleneck id, and the results copy. Their exact words are quoted verbatim on results (`cleanQuote()`); the diagnosis weaves BOTH open answers. Payload is now `exponential-you-v3` (dreamText, deeperText, themes[], block, identity). Min 6 chars to advance each open screen. `STAGE_SETS` remains defined but unused; `SUCCESS_SETS`/`BLOCK_OPTS`/`WANTS` removed.

> **v2 (Aug 2026):** cut from 34 answerable steps to **5 questions**. Two goals only:
> (A) capture what transformation/success means to them in their own words, and
> (B) route them to a pathway and hand them an **identity** — fast, so nothing delays
> the Mindvalley signup. The 30-question scoring engine, section screens, and bridge
> screen were removed. (A sibling page, `mv-quiz.html`, explores the same 5Q identity
> format across all 6 pathways.)

## 1. High-level model

**One engine, four branches.** Q1 ("What are you trying to grow?") selects a branch — `biz`, `career`, `craft`, or `self`. The branch changes question wording, proof casting, the default pathway, and the identity noun.

There is **no scoring**. Q4 is a single self-diagnosis pick that maps directly onto the original 10-bottleneck model (block id → Phase-1 program via `PATHWAY_MAPS`).

## 2. The 5 questions (in order)

| # | id | Question | Feeds |
|---|----|----------|-------|
| 1 | `grow` | What are you trying to grow? (biz / career / craft / self) | branch → default pathway + identity noun |
| 2 | `stage` | Branch-specific stage (revenue band / career level / audience size / years in) | diagnosis copy (`stagePhrase`), proof casting |
| 3 | `success` | "Fast-forward 12 months. It worked. What changed?" — 4 branch-specific success pictures | **Goal A**: label mirrored verbatim in a quote card; phrase woven into diagnosis |
| 4 | `block` | "And what's really standing between you and that?" — 6 options → block ids **1, 3, 5, 6, 9, 10** | energy override (id 1 → Ageless Body), Phase-1 program, diagnosis |
| 5 | `want` | "When you get there — what does it actually give you?" (scale / health / family / think) | diagnosis copy |

Progress bar counts 5 answerable steps. Back button works on Q2–Q5.

## 3. Flow after Q5

1. **Loader** — cosmetic ~1.6s ("Matching your pathway…", 4 steps ending in "Naming who you're becoming").
2. **Email gate** — first name + email + optional consent. "Reveal my pathway". Submits lead payload, advances regardless of network result.
3. **One merged screen** (`plan`) — identity reveal → their-own-words quote → diagnosis → bottleneck proof story → divergence chart → 12-week plan → offer stack → tiers → CTA → guarantee → results wall → exit ramp. No intermediate results/bridge screens: nothing between the reveal and checkout.

## 4. Pathway + identity

```
if block.id ∈ {1, 2}  →  Ageless Body          // energy override
else                  →  branch default:
   biz    → The Exponential Entrepreneur
   career → The Exponential Entrepreneur
   craft  → The Authority
   self   → The Extraordinary Mind
```

Identity = `identityFor(pathway, grow)` with noun map biz→Founder, career→Leader, craft→Creator, self→Human:

- `ee` → **The Exponential {noun}**
- `auth` → **The Emerging Authority**
- `mind` → **The Extraordinary Mind**
- `body` → **The Recharged {noun}**

Each pathway has an `IDENTITY_CREED` one-liner shown under the identity name.

## 5. The 12-week plan (3 phases)

Unchanged from v1 except Phase 1 is keyed off the **picked** block id (not a score):

- **Phase 1** = `PATHWAY_MAPS[pathway][block.id]` (career+EE+block 6 → Ultimate Leadership override still applies).
- **Phases 2–3** = the pathway's flagship arc (`PATHWAY_ARCS`), `ee_career` variant for career-on-EE, dedup via `backups`.

## 6. Offer, pricing, checkout — unchanged from v1

Monthly $49 / Yearly $199 ($100 off, default), checkout_link API prefetch with hardcoded fallbacks, UTM + ad-click-ID forwarding, 15-minute localStorage timer, 15-day guarantee tied to Phase-1 week 1, free-masterclass exit ramp.

## 7. Lead capture payload (v2)

`POST /api/submit-lead` (relative URL, `keepalive: true`, silent on failure):

```json
{
  "version": "exponential-you-v2",
  "firstName": "...", "email": "...", "consent": true,
  "submittedAt": "ISO-8601",
  "grow": "biz|career|craft|self",
  "stage": "pre|s1|s2|s3",
  "success": "growth|freedom|status|whole",
  "successLabel": "their exact chosen wording",
  "block": { "id": 6, "name": "The Control Trap" },
  "want": "scale|health|family|think",
  "recommendedPathway": "ee|auth|mind|body",
  "identity": "The Exponential Founder",
  "utm": { "source": "...", "medium": "...", "campaign": "...", "term": "...", "content": "..." },
  "referrer": "...", "userAgent": "..."
}
```

⚠️ On GitHub Pages there is no backend, so this endpoint 404s silently — leads are currently **not** captured (known open blocker, unchanged). No analytics on the page either (blocker #2).

## 8. v1 quirks resolved in v2

1. `pw.key === 'lon'` dead branch — gone (the whole pwWhy block was replaced by the identity card).
2. `FREE_CLASS.man` dead fallback — now `FREE_CLASS.mind`.
3. "Start my **The** Exponential Entrepreneur pathway" CTA — now strips the leading "The".
4. Consent checkbox still optional by design; unchecked leads submit with `consent: false`.
5. All stories remain real (stories.mindvalley.com), photos self-hosted with initials fallback.

## 9. Data kept but currently unreferenced

`blocks` entries 2, 4, 7, 8 (Recovery Debt, Impostor Loop, Lone Wolf, The Drift) are not offered in Q4 but remain in `blocks`/`PATHWAY_MAPS` so Q4 options can be re-cast freely. The per-section `PROOF` castings (keys 1/7/16/22) are still used to pick the diagnosis proof story via `systemProofKey(block.id)`.
