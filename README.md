# Discourse Connector for Workato (Unofficial)

A custom connector that enables seamless integration between **Discourse** (community platform) and business workflows in Workato.

This connector allows teams to automate community interactions, sync discussions, and integrate forum activity with support systems, CRMs, and internal tools.

> ⚠️ This is an unofficial connector and is not affiliated with or endorsed by Workato or Discourse.
> ⚠️ This connector uses publicly available Discourse APIs.

---

## 🚀 Why this connector matters

Modern teams rely heavily on community platforms like Discourse for support, discussions, and knowledge sharing. However, these conversations often remain disconnected from core business systems.

This connector bridges that gap by enabling:

- Automated topic creation from external systems
- Real-time monitoring of community activity
- Integration of forum discussions into internal workflows
- Improved collaboration between support, product, and community teams

---

## ✨ Features

### Actions

| Action                      | Description                                    |
| --------------------------- | ---------------------------------------------- |
| **Create post**             | Create a new topic or reply to an existing one |
| **List topics**             | Get latest topics across the forum             |
| **Get topic**               | Fetch a topic by ID including all its posts    |
| **List topics by category** | Get topics filtered by category                |
| **Search**                  | Search topics and posts by keyword             |
| **Get user**                | Fetch a user profile by username               |

---

### Triggers

| Trigger       | Description                                 |
| ------------- | ------------------------------------------- |
| **New topic** | Fires when a new topic is created (polling) |
| **New post**  | Fires when a new post is created (polling)  |

---

### Pick Lists

- **Categories** — Dynamic dropdown populated from your Discourse forum

---

## 💡 Use Cases

### 1. Customer Support Automation

- Automatically create a Discourse topic when a support ticket is raised
- Allow community members to contribute solutions

### 2. Community Monitoring

- Track new posts and trigger moderation workflows
- Notify internal teams when critical discussions appear

### 3. CRM Integration

- Create discussion threads for important customer accounts
- Sync feedback from Discourse into CRM systems

### 4. Knowledge Sharing

- Convert internal events into community discussions
- Build a knowledge base through automated topic creation

---

## 🧩 Example Recipes

### Example 1: Create topic from support ticket

- **Trigger:** New ticket in support system (e.g., Zendesk)
- **Action:** Create topic in Discourse

---

### Example 2: Monitor new discussions

- **Trigger:** New topic in Discourse
- **Action:** Send notification to Slack / Email

---

### Example 3: Sync community replies

- **Trigger:** New post in Discourse
- **Action:** Update internal system or notify team

---

## ⚙️ Prerequisites

- Ruby 3.x
- Bundler
- A Discourse forum with API access
- Workato account (for production use)

---

## 🔧 Setup

### 1. Clone the repository

```bash
git clone https://github.com/abinash889/discourse-connector.git
cd discourse-connector
```

---

### 2. Install dependencies

```bash
bundle install
```

---

### 3. Configure credentials

Copy the example settings file:

```bash
cp settings.yaml.example settings.yaml
```

Edit `settings.yaml`:

```yaml
base_url: "https://yourforum.discourse.org"
api_key: "your_api_key_here"
api_username: "your_username_here"
```

---

### 4. Generate API Key in Discourse

1. Go to **Admin → API → New API Key**
2. Set **User Level** to `Single User`
3. Select your admin user
4. Set scope to `Global`
5. Copy the key into `settings.yaml`

---

## 🧪 Running Tests

### First run (record VCR cassettes)

```bash
VCR_RECORD_MODE=once \
TEST_TOPIC_ID=your_topic_id \
TEST_CATEGORY_ID=your_category_id \
TEST_USERNAME=your_username \
bundle exec rspec
```

---

### Subsequent runs

```bash
bundle exec rspec
```

Tests use encrypted VCR cassettes, allowing contributors to run tests without real credentials after initial setup.

---

## 🐳 Local Development with Docker

```bash
# Build container
docker compose build

# Test an action
docker compose run connector workato exec actions.list_topics.execute \
  --connector=connector.rb \
  --settings=settings.yaml

# Run tests
docker compose run --rm \
  -e VCR_RECORD_MODE=once \
  -e TEST_TOPIC_ID=your_topic_id \
  -e TEST_CATEGORY_ID=your_category_id \
  -e TEST_USERNAME=your_username \
  connector bundle exec rspec
```

---

## 🏗️ Project Structure

```
discourse-connector/
├── connector.rb
├── Gemfile
├── settings.yaml.example
├── spec/
│   ├── connector_spec.rb
│   ├── spec_helper.rb
│   └── cassettes/
```

---

## 🔌 Using in Workato

1. Go to **Tools → Connector SDK**
2. Click **New Connector**
3. Paste contents of `connector.rb`
4. Save the connector
5. Configure connection using Discourse credentials
6. Start building recipes

---

## 📝 Notes

- Triggers currently use polling
- Webhook-based triggers may be added in future versions

---

## 🤝 Contributing

Contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👤 Author

**Abinash Bhatta**

Built with ❤️ as an open source contribution to the Workato community.

- GitHub: https://github.com/abinash889
- LinkedIn: https://www.linkedin.com/in/abinash-bhatta-982372187/

---
