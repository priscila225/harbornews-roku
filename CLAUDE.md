# Harbor News Roku

Roku channel for a local-news brand: headline list and a weather strip, written in BrighterScript with SceneGraph XML.

## Architecture

- `src/source/architecture` and `src/components/architecture` are the reusable framework layer: base controls and pages, tasks, the HTTP node and shared helpers. App code depends on it, never the reverse.
- `src/source/app` and `src/components/app` hold the app: `MainScene`, `pages/`, `controls/`, `managers/`, `tasks/`.
- Pages follow MVVM: `Page.xml/.bs` (wiring only), `viewModel/` (a Node component), `model/` (pure data shaping), `usecases/` (start tasks).
- The scene owns the page stack. Pages navigate by setting the scene's `navigateToPage` field (`{ page, params, mode }`).

## Tech stack

BrighterScript with `bslint` (`bslint.jsonc`), SceneGraph XML, `roUrlTransfer` for HTTP. Tests: plain BrightScript run in an interpreter (`npm test`) for pure helpers only.

## Conventions

- **Pages wire, view models think.** A `*Page.bs` file only finds nodes, observes fields and forwards events. Loading, selection and formatting logic lives in the view model or a use case. Why: pages cannot be unit-tested; view models and pure functions can.
- **Tasks talk only through their own fields.** A Task writes `m.top.result` and nothing else. It never touches page or scene nodes and never calls `callFunc` on them. Why: thread ownership; cross-thread node access forces a rendezvous and can deadlock the render thread.
- **Follow `bslint.jsonc`.** Use `function` (not `sub`), no `then` on block `if`, annotate every parameter and return type, return explicitly on every path. Why: consistency; style rules are warnings today and will become blocking.
- **Pair every observer on a long-lived node.** Each `observeField` on `m.global`, the scene or a manager needs a matching `unobserveField` in `onDestroy`. Why: pages are pushed and popped, and leaked observers keep firing into destroyed pages.
- **Guard every payload.** Check `parseJson` results and network bodies with the helpers in `ObjectUtils.bs` before dot access. Why: "Dot operator attempted on invalid" is the most common crash, and comparing `invalid` to a value raises a type mismatch.
- Start tasks with `startTask(taskName, params, callbackName)` from the component that owns the callback.

## Anti-patterns

- Writing a rendered node's field from a Task.
- Reading a Task's `result` right after setting `control = "run"`.
- Setting a component field to a value whose type differs from the XML `type`.
- Logic in `init()` that depends on a node not yet attached to the scene.

## Commands

```bash
npm run build   # compile and lint
npm test        # compile, then run the interpreter tests
```
