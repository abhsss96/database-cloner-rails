# database-cloner-rails

[![Gem Downloads](https://img.shields.io/gem/dt/database-cloner-rails)](https://rubygems.org/gems/database-cloner-rails)

A Rails gem that provides Rake tasks to back up and restore your database records across environments.

## How it works

The gem iterates over all ActiveRecord models in your app, serializes their records to Ruby files, and can replay those files to restore the data. Useful for seeding a staging environment from production data or creating snapshots.

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'database-cloner-rails'
```

Then run:

```bash
bundle install
```

## Usage

### Download (backup)

Dumps all records from every model into individual `.rb` files under `lib/tasks/database_cloner/db_dump/`:

```bash
rake database:download
```

Each file contains `Model.create(...)` calls — one per record — with `id`, `created_at`, and `updated_at` stripped out.

### Upload (restore)

Replays the dumped files to recreate records in the current database:

```bash
rake database:upload
```

If a model's dump file fails to load, it prints a warning and continues with the rest.

## Notes

- Only models that can be resolved via `classify.safe_constantize` are included.
- Records are ordered by `id` during the dump.
- The `db_dump/` directory must exist before running `database:download`.
