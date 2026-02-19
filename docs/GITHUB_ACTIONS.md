# Code Generation CI (GitHub Actions)

This repo includes a GitHub Actions workflow that ensures generated code is up to date. The workflow runs `build_runner` and fails the job (and PR) if generated files change.

See `.github/workflows/codegen_check.yml` for the implementation.

To run locally:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
git status --porcelain
```

If `git status` shows modified files after running `build_runner`, run the command and commit the generated files before pushing.
