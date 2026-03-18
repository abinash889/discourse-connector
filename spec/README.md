## Running tests

1. Copy settings example:
   cp settings.yaml.example settings.yaml

2. Fill in your Discourse credentials in settings.yaml

3. Set test data in .env:
   TEST_TOPIC_ID=your_topic_id
   TEST_CATEGORY_ID=your_category_id  
   TEST_USERNAME=your_username

4. Record cassettes (first time only):
   VCR_RECORD_MODE=once bundle exec rspec

5. Run tests normally after that:
   bundle exec rspec
