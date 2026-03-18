# frozen_string_literal: true

RSpec.describe 'connector', :vcr do
  let(:connector) { Workato::Connector::Sdk::Connector.from_file('connector.rb', settings) }
  let(:settings) { Workato::Connector::Sdk::Settings.from_default_file }

  let(:test_topic_id) { ENV.fetch('TEST_TOPIC_ID', '1').to_i }
  let(:test_category_id) { ENV.fetch('TEST_CATEGORY_ID', '1').to_i }
  let(:test_username) { ENV.fetch('TEST_USERNAME', 'system') }

  it { expect(connector).to be_present }

  describe 'test' do
    subject(:output) { connector.test(settings) }

    it 'connects to Discourse successfully' do
      expect(output).to be_present
    end
  end

  describe 'actions' do
    describe 'create_post' do
      subject(:output) do
        connector.actions.create_post.execute(settings, input)
      end

      let(:input) do
        {
          'title' => 'Test topic from RSpec',
          'raw' => 'This is a test post created by RSpec tests',
          'category' => test_category_id
        }
      end

      it 'creates a post successfully' do
        expect(output['id']).to be_present
        expect(output['topic_id']).to be_present
      end
    end

    describe 'list_topics' do
      subject(:output) do
        connector.actions.list_topics.execute(settings, {})
      end

      it 'returns array of topics' do
        expect(output).to be_an(Array)
        expect(output.first['id']).to be_present
        expect(output.first['title']).to be_present
      end
    end

    describe 'get_topic' do
      subject(:output) do
        connector.actions.get_topic.execute(settings, input)
      end

      let(:input) { { 'topic_id' => test_topic_id } }

      it 'returns topic details' do
        expect(output['id']).to eq(test_topic_id)
        expect(output['title']).to be_present
        expect(output['post_stream']).to be_present
      end
    end

    describe 'list_topics_by_category' do
      subject(:output) do
        connector.actions.list_topics_by_category.execute(settings, input)
      end

      let(:input) { { 'category_id' => test_category_id } }

      it 'returns topics for category' do
        expect(output).to be_an(Array)
      end
    end

    describe 'search' do
      subject(:output) do
        connector.actions.search.execute(settings, input)
      end

      let(:input) { { 'query' => 'test' } }

      it 'returns search results' do
        expect(output['topics']).to be_present
        expect(output['posts']).to be_present
      end
    end

    describe 'get_user' do
      subject(:output) do
        connector.actions.get_user.execute(settings, input)
      end

      let(:input) { { 'username' => test_username } }

      it 'returns user profile' do
        expect(output['id']).to be_present
        expect(output['username']).to eq(test_username)
      end
    end
  end

  describe 'triggers' do
    describe 'new_topic' do
      subject(:output) do
        connector.triggers.new_topic.poll(settings, {}, nil)
      end

      it 'returns events array' do
        expect(output[:events]).to be_an(Array)
        expect(output[:next_poll]).to be_present
      end
    end

    describe 'new_post' do
      subject(:output) do
        connector.triggers.new_post.poll(settings, {}, nil)
      end

      it 'returns events array' do
        expect(output[:events]).to be_an(Array)
        expect(output[:next_poll]).to be_present
      end
    end
  end

  describe 'pick_lists' do
    describe 'categories' do
      subject(:output) do
        connector.pick_lists.categories(settings)
      end

      it 'returns array of name/id pairs' do
        expect(output).to be_an(Array)
        expect(output.first.length).to eq(2)
      end
    end
  end
end