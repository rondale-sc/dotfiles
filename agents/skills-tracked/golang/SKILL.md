---
name: golang
description: Personal Go (Golang) coding preferences and conventions. Use when writing or editing Go files (.go) — covers context.Context propagation and other Go style/structure preferences. Apply these by default when authoring or modifying Go code.
---

# Golang Preferences

Personal Go conventions to apply when writing or editing `.go` files.

## Context Handling

- Only `main.go` creates `context.Background()`; propagate it throughout the app.
- Use subcontexts (`WithTimeout`, `WithCancel`, etc.) for scoped operations.
- All I/O functions and API calls must accept `context.Context` as the first param.

```go
// main.go
func main() {
    ctx := context.Background()
    NewApp(ctx).Run()
}

// elsewhere
func (a *App) ProcessRequest(ctx context.Context, req Request) error {
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()
    return a.service.Handle(ctx, req)
}
```
