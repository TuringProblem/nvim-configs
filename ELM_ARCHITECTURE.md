# The Elm Architecture (TEA) — applied to `example_fp.lua`

A guide to the architecture behind the tabbed monitor UI, written so you can
read it next to the code and understand every piece.

---

## The big idea

The whole program is **one piece of data** (the Model) plus **three pure
functions** that transform it. Everything that touches the outside world —
drawing to the monitor, opening the modem, reading touch events — is pushed to
the *edges*. The core never touches hardware.

```
        ┌─────────────────────────────────────┐
        │            PURE CORE                 │
        │                                      │
   init ───> Model ──> view ──> [Widgets]      │
        │      ^                    │          │
        │      │                    │          │
        │   update <── Msg <────────┘          │
        └──────│──────────────^───────────────┘
               │              │
        ┌──────▼──────────────│───────────────┐
        │         IMPURE SHELL │               │
        │   render(widgets)    hitTest(touch)  │
        │   modem / rednet     os.pullEvent     │
        └──────────────────────────────────────┘
```

Three pure functions:

```
init   : ()           -> Model        -- starting state
update : (Msg, Model) -> Model        -- next state (no side effects)
view   : Model        -> [Widget]     -- describe the screen as data
```

Two impure edge functions the runtime owns:

```
render  : (dev, [Widget]) -> ()        -- the ONLY drawing
hitTest : ([Widget], x, y) -> Msg | nil -- touch -> message
```

---

## Model = the data

Like the **M in MVC**, but stricter. The Model is the *entire* state of the
program in one immutable table.

```lua
local function init()
  return { tab = 1, count = 0 }   -- THIS is the whole app state
end
```

Right now the app knows three things: which tab is active, the counter value,
and (once you add it) whether the modem is on. Nothing else exists. No hidden
state in globals, no flags stashed on the monitor. **If it's not in the Model,
it's not state.**

### Immutable

You never write `model.tab = 2`. You make a *new* Model. That is what `merge`
does:

```lua
merge(model, { tab = 2 })   -- new table, old one untouched
```

Why bother? Past state never silently changes under you, and the Model fully
describes the screen — so debugging is trivial: print the Model, you know
exactly what's drawn.

---

## Msg = "something happened"

This is the part MVC doesn't really have. A Msg is **tagged data describing an
event** — not a function, not an action, just a label plus a payload.

```lua
local function SelectTab(i) return { kind = "SelectTab", index = i } end
local function Increment()  return { kind = "Increment" } end
```

`SelectTab(2)` produces `{ kind = "SelectTab", index = 2 }`. By itself it does
**nothing** — it's pure data meaning "the user wants tab 2." Something else
decides what that means.

Think of a Msg as a note passed across the room: *"user tapped Counter."* The
note changes nothing. Reading it and acting on it does.

---

## update = the only place state changes

```
update : (Msg, Model) -> Model
```

Takes the current state plus a thing-that-happened, returns the **next** state.
Pure — no drawing, no modem, no events. It's a big `if` over `msg.kind`:

```lua
if msg.kind == "Increment" then
  return merge(model, { count = model.count + 1 })
```

"Got Increment, here's a new Model with count one higher." This is your
reducer. **Every** state transition in the app lives here, in one place.

---

## view = Model -> picture (as data)

```
view : Model -> [Widget]
```

Looks at the Model, returns a **list of widgets** — plain tables saying "this
text, at this x,y, in these colors." It does **not** draw. It returns a
description of the screen as a value.

```lua
clickable(2, 5, " Count + ", colors.white, colors.green, Increment())
```

= "a clickable thing at (2,5) saying ' Count + ', and **if tapped, emit the
Increment Msg**." The widget carries its own Msg. That is the wire from the
screen back to `update`.

This is the **V in MVC**, but pure — `view` never mutates the screen.

---

## The shell ties it together — the loop

`runtime` is the only impure part. Watch the cycle:

```lua
local function runtime(dev)
  local model = init()                          -- 1. start state
  while true do
    local widgets = view(model)                 -- 2. state -> picture (pure)
    render(dev, widgets)                        -- 3. actually draw it (EFFECT)
    local _, _, x, y = os.pullEvent("monitor_touch") -- 4. wait for input (EFFECT)
    local msg = hitTest(widgets, x, y)          -- 5. touch -> Msg (which widget?)
    if msg then
      model = update(msg, model)                -- 6. Msg + state -> new state (pure)
    end
  end                                           -- loop: redraw new state
end
```

Round and round:

```
Model --view--> Widgets --render--> screen
  ^                                    |
  |                                  (tap)
update <--Msg-- hitTest <--touch-- os.pullEvent
```

`hitTest` is the mirror of `view`: `view` turns the Model into
widgets-with-msgs; `hitTest` takes a touch coordinate, finds which widget got
hit, and pulls its `.msg` back out. That closes the loop.

---

## Why split it this way

- **Pure core** (`init` / `update` / `view`) — no effects, so it's testable
  with zero hardware. Feed it a Model + Msg, assert on the resulting Model. No
  Minecraft needed.
- **Effects at the edges only** (`render` / `hitTest` / modem) — all the
  "dangerous" outside-world stuff lives in one small place.
- **One state, one place it changes** (`update`) — no surprise mutations
  scattered across the codebase.

---

## Adding the modem, in this frame

This is how a side effect (opening the modem) fits the architecture:

1. **Model** gains a field: `modem = false` (state).
2. Tapping the button emits `PowerOnModem()` (a **Msg** — "user wants modem on").
3. **update** sets `modem = true` (a pure state change — just the flag).
4. The **shell** notices the flag changed and calls `rednet.open` (the
   **effect**, at the edge).

### The common mistake

```lua
-- WRONG: view runs the effect immediately, on every render
clickable(2, 5, "power on Modem", colors.white, colors.green, StartupModem(true))
```

`StartupModem(true)` is a *call* — it runs `sleep` + `rednet.open` every time
`view` runs, before any click. `view` only **describes**. Pass the Msg instead:

```lua
-- RIGHT: the widget carries a Msg; the effect happens later, in the shell
clickable(2, 5, "power on Modem", colors.white, colors.green, PowerOnModem())
```

### Where the effect actually runs

The Elm answer is **commands**: `update` stays pure, and the runtime performs
the effect. A minimal version diffs the flag in the loop and acts on change:

```lua
local function runtime(dev)
  local model = init()
  local lastModem = model.modem
  while true do
    local widgets = view(model)
    render(dev, widgets)
    local _, _, x, y = os.pullEvent("monitor_touch")
    local msg = hitTest(widgets, x, y)
    if msg then
      model = update(msg, model)        -- pure
      if model.modem ~= lastModem then  -- effect at the edge
        StartupModem(model.modem)
        lastModem = model.modem
      end
    end
  end
end
```

`StartupModem` stays an impure edge function, called **only** from the runtime.

---

## The one-sentence version

`view` **describes**, `update` **decides**, the shell **acts**. State lives in
the Model; events are Msgs; effects only happen at the edges.
