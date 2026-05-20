# ============================================================
# Makefile — Google Fiber FCR Capstone
# ============================================================
# One-command operations. Run `make help` to see all targets.
# ============================================================

.PHONY: help setup deps debug run test build docs docs-serve clean lint ci

# Default target
help:  ## Show this help
	@echo "Google Fiber FCR Capstone — available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# ── Setup ───────────────────────────────────────────────────
setup:  ## First-time setup: install dbt + copy profiles template
	pip install dbt-bigquery==1.8.*
	@if [ ! -f ~/.dbt/profiles.yml ]; then \
		mkdir -p ~/.dbt && \
		cp dbt/profiles.yml.example ~/.dbt/profiles.yml && \
		echo "✅ Copied profiles.yml.example → ~/.dbt/profiles.yml"; \
		echo "⚠️  Now edit ~/.dbt/profiles.yml and fill in your GCP project ID"; \
	else \
		echo "✅ ~/.dbt/profiles.yml already exists"; \
	fi
	cd dbt && dbt deps

deps:  ## Install dbt packages only
	cd dbt && dbt deps

debug:  ## Verify dbt + BigQuery connection
	cd dbt && dbt debug

# ── Daily ops ───────────────────────────────────────────────
run:  ## Run all dbt models (staging + marts)
	cd dbt && dbt run

test:  ## Run all dbt data quality tests
	cd dbt && dbt test

build:  ## Run + test in one shot (recommended)
	cd dbt && dbt build

# ── Selective ───────────────────────────────────────────────
run-staging:  ## Run only staging models
	cd dbt && dbt run --select staging

run-marts:  ## Run only marts
	cd dbt && dbt run --select marts

test-marts:  ## Test only the FCR mart
	cd dbt && dbt test --select mart_fiber_fcr

# ── Production ──────────────────────────────────────────────
run-prod:  ## Run against production dataset (uses service account)
	cd dbt && dbt run --target prod

test-prod:  ## Test on production
	cd dbt && dbt test --target prod

# ── Documentation ───────────────────────────────────────────
docs:  ## Generate dbt documentation site
	cd dbt && dbt docs generate

docs-serve:  ## Serve docs at http://localhost:8080
	cd dbt && dbt docs serve

# ── Hygiene ─────────────────────────────────────────────────
clean:  ## Remove dbt build artifacts
	cd dbt && dbt clean

# ── CI mimic ────────────────────────────────────────────────
ci:  ## Run what GitHub Actions runs (run + test on prod)
	cd dbt && dbt deps && dbt run --target prod && dbt test --target prod
