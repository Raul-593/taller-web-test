# Automated Test - Taller Web
[![Pruebas Selenium](https://github.com/Raul-593/taller-web-test/actions/workflows/tests.yml/badge.svg)](https://github.com/Raul-593/taller-web-test/actions/workflows/tests.yml)

Selenium + pytest test suite for 593 Cycling Studio CRM, using the Page Object Model pattern. Test run against a local 
Supabase instance(`supabase start`), never agains production

## Setup

1. Start the local Supabase stack (from the taller-web repo root):
   ```bash
   supabase start
   ```
2. Run the app with the local test environment:
   ```bash
   npm run dev
   ```
3. Install test dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the tests:
   ```bash
   pytest -v
   ```

## Structure

```
pages/          # Page Object classes (one per screen/module)
tests/          # Test cases
conftest.py     # Shared fixtures (driver, logged-in session)
```

## Coverage

- Login (success and invalid credentials)
- Customer management (listing, creating)

## Notes

- Test data is seeded via `schema_test_data_taller_web.sql`, all prefixed with "QA TEST" for easy identification.
- Run `supabase db reset` to restore a clean test dataset between runs.