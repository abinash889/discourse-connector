# Discourse Connector for Workato

A custom Workato connector for [Discourse](https://www.discourse.org/) — the open source community forum platform.

![Workato](https://img.shields.io/badge/Workato-Custom%20Connector-blue)
![Ruby](https://img.shields.io/badge/Ruby-3.x-red)
![Tests](https://img.shields.io/badge/Tests-11%20passing-brightgreen)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Features

### Actions

| Action                      | Description                                    |
| --------------------------- | ---------------------------------------------- |
| **Create post**             | Create a new topic or reply to an existing one |
| **List topics**             | Get latest topics across the forum             |
| **Get topic**               | Fetch a topic by ID including all its posts    |
| **List topics by category** | Get topics filtered by category (dropdown)     |
| **Search**                  | Search topics and posts by keyword             |
| **Get user**                | Fetch a user profile by username               |

### Triggers

| Trigger       | Description                                 |
| ------------- | ------------------------------------------- |
| **New topic** | Fires when a new topic is created (polling) |
| **New post**  | Fires when a new post is created (polling)  |

### Pick Lists

- **Categories** — Dynamic dropdown populated from your Discourse forum

---

## Prerequisites

- Ruby 3.x
- Bundler
- A Discourse forum with API access
- Workato account (for production use)

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/abinash889/discourse-connector.git
cd discourse-connector
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure credentials

Copy the example settings file:

```bash
cp settings.yaml.example settings.yaml
```

Edit `settings.yaml` with your Discourse credentials:

```yaml
base_url: "https://yourforum.discourse.org"
api_key: "your_api_key_here"
api_username: "your_username_here"
```

### 4. Generate an API key in Discourse

1. Go to **Admin → API → New API Key**
2. Set **User Level** to `Single User`
3. Set **User** to your admin username
4. Set **Scope** to `Global`
5. Copy the key into `settings.yaml`

---

## Running Tests

### First time — record VCR cassettes

Set your test data environment variables and record:

```bash
VCR_RECORD_MODE=once \
TEST_TOPIC_ID=your_topic_id \
TEST_CATEGORY_ID=your_category_id \
TEST_USERNAME=your_username \
bundle exec rspec
```

### After that — run normally (no credentials needed)

```bash
bundle exec rspec
```

Tests use encrypted VCR cassettes so contributors can run them without real credentials after the initial recording.

---

## Local Development with Docker

If you're on Windows or want an isolated environment:

```bash
# Build
docker compose build

# Test an action
docker compose run connector workato exec actions.list_topics.execute \
  --connector=connector.rb \
  --settings=settings.yaml

# Run all tests
docker compose run --rm \
  -e VCR_RECORD_MODE=once \
  -e TEST_TOPIC_ID=your_topic_id \
  -e TEST_CATEGORY_ID=your_category_id \
  -e TEST_USERNAME=your_username \
  connector bundle exec rspec
```

---

## Project Structure

```
discourse-connector/
├── connector.rb          # Main connector code
├── Gemfile               # Dependencies
├── Gemfile.lock          # Pinned versions
├── settings.yaml.example # Credentials template
├── .rspec                # RSpec configuration
└── spec/
    ├── connector_spec.rb # All tests
    ├── spec_helper.rb    # Test setup
    └── cassettes/        # Encrypted VCR recordings
```

---

## Using in Workato

1. Go to **Tools → Connector SDK**
2. Click **New connector**
3. Paste the contents of `connector.rb`
4. Click **Save**
5. Create a new connection with your Discourse URL, API key, and username
6. Start building recipes!

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/add-new-action`)
3. Write tests for your changes
4. Make sure all tests pass (`bundle exec rspec`)
5. Submit a pull request

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Author

**Abinash Bhatta**

Built with ❤️ for the Workato community.

- GitHub: [abinash889](https://github.com/abinash889)
- LinkedIn: [Abinash Bhatta](https://www.linkedin.com/in/abinash-bhatta-982372187/)
