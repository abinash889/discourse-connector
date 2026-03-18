{
  title: 'Discourse',

  connection: {
    fields: [
      {
        name: 'base_url',
        label: 'Discourse URL',
        hint: 'e.g. https://yourforum.discourse.org'
      },
      {
        name: 'api_key',
        label: 'API Key',
        control_type: 'password'
      },
      {
        name: 'api_username',
        label: 'API Username'
      }
    ],

    authorization: {
      type: 'custom_auth',

      apply: lambda do |connection|
        headers(
          'Api-Key': connection['api_key'],
          'Api-Username': connection['api_username']
        )
      end
    },

    base_uri: lambda do |connection|
      connection['base_url']
    end
  },

  test: lambda do |connection|
    get("#{connection['base_url']}/site.json")
  end,

  actions: {
    create_post: {
      title: 'Create post',
      subtitle: 'Create a new post or topic in Discourse',

      input_fields: lambda do
        [
          {
            name: 'topic_id',
            label: 'Topic ID',
            type: 'integer',
            hint: 'Leave blank to create a new topic'
          },
          {
            name: 'title',
            label: 'Topic Title',
            hint: 'Required only when creating a new topic'
          },
          {
            name: 'raw',
            label: 'Post Content',
            control_type: 'text-area',
            optional: false
          },
          {
            name: 'category',
            label: 'Category ID',
            type: 'integer',
            hint: 'Required when creating a new topic'
          }
        ]
      end,

      execute: lambda do |connection, input|
        post("#{connection['base_url']}/posts.json")
          .payload(input)
      end,

      output_fields: lambda do
        [
          { name: 'id', label: 'Post ID', type: 'integer' },
          { name: 'topic_id', label: 'Topic ID', type: 'integer' },
          { name: 'post_number', label: 'Post Number', type: 'integer' },
          { name: 'url', label: 'Post URL' },
          { name: 'raw', label: 'Post Content' },
          { name: 'created_at', label: 'Created At', type: 'date_time' }
        ]
      end
    },

    list_topics: {
      title: 'List topics',
      subtitle: 'Get latest topics from Discourse',

      input_fields: lambda do
        []
      end,

      execute: lambda do |connection, _input|
        get("#{connection['base_url']}/latest.json")
          .dig('topic_list', 'topics') || []
      end,

      output_fields: lambda do
        [
          {
            name: 'topics',
            type: 'array',
            of: 'object',
            properties: [
              { name: 'id', label: 'Topic ID', type: 'integer' },
              { name: 'title', label: 'Title' },
              { name: 'fancy_title', label: 'Formatted Title' },
              { name: 'slug', label: 'Slug' },
              { name: 'posts_count', label: 'Posts Count', type: 'integer' },
              { name: 'reply_count', label: 'Reply Count', type: 'integer' },
              { name: 'highest_post_number', label: 'Highest Post Number', type: 'integer' },
              { name: 'views', label: 'Views', type: 'integer' },
              { name: 'like_count', label: 'Like Count', type: 'integer' },
              { name: 'category_id', label: 'Category ID', type: 'integer' },
              { name: 'created_at', label: 'Created At', type: 'date_time' },
              { name: 'last_posted_at', label: 'Last Posted At', type: 'date_time' },
              { name: 'bumped_at', label: 'Bumped At', type: 'date_time' },
              { name: 'last_poster_username', label: 'Last Poster Username' },
              { name: 'pinned', label: 'Pinned', type: 'boolean' },
              { name: 'pinned_globally', label: 'Pinned Globally', type: 'boolean' },
              { name: 'visible', label: 'Visible', type: 'boolean' },
              { name: 'closed', label: 'Closed', type: 'boolean' },
              { name: 'archived', label: 'Archived', type: 'boolean' },
              { name: 'has_accepted_answer', label: 'Has Accepted Answer', type: 'boolean' },
              { name: 'archetype', label: 'Archetype' },
              { name: 'image_url', label: 'Image URL' },
              { name: 'featured_link', label: 'Featured Link' },
              {
                name: 'posters',
                label: 'Posters',
                type: 'array',
                of: 'object',
                properties: [
                  { name: 'user_id', label: 'User ID', type: 'integer' },
                  { name: 'description', label: 'Description' },
                  { name: 'extras', label: 'Extras' }
                ]
              }
            ]
          }
        ]
      end
    },
    get_topic: {
      title: 'Get topic',
      subtitle: 'Get topic by topic ID',

      input_fields: lambda do
        [
          {
            name: 'topic_id',
            label: 'Topic ID',
            type: 'integer',
            optional: false
          }
        ]
      end,

      execute: lambda do |connection, input|
        get("#{connection['base_url']}/t/#{input['topic_id']}.json")
      end,

      output_fields: lambda do
        [
          { name: 'id', label: 'Topic ID', type: 'integer' },
          { name: 'title', label: 'Title' },
          { name: 'posts_count', label: 'Posts Count', type: 'integer' },
          { name: 'reply_count', label: 'Reply Count', type: 'integer' },
          { name: 'created_at', label: 'Created At', type: 'date_time' },
          { name: 'category_id', label: 'Category ID', type: 'integer' },
          { name: 'closed', label: 'Closed', type: 'boolean' },
          { name: 'archived', label: 'Archived', type: 'boolean' },
          {
            name: 'post_stream',
            label: 'Post Stream',
            type: 'object',
            properties: [
              {
                name: 'posts',
                label: 'Posts',
                type: 'array',
                of: 'object',
                properties: [
                  { name: 'id', label: 'Post ID', type: 'integer' },
                  { name: 'username', label: 'Username' },
                  { name: 'raw', label: 'Content' },
                  { name: 'created_at', label: 'Created At', type: 'date_time' },
                  { name: 'reply_count', label: 'Reply Count', type: 'integer' },
                  { name: 'like_count', label: 'Like Count', type: 'integer' }
                ]
              }
            ]
          }
        ]
      end
    },
    list_topics_by_category: {
      title: 'List topics by category',
      subtitle: 'Get latest topics from a specific category',

      input_fields: lambda do
        [
          {
            name: 'category_id',
            label: 'Category',
            control_type: 'select',
            pick_list: 'categories',
            optional: false
          }
        ]
      end,

      execute: lambda do |connection, input|
        get("#{connection['base_url']}/c/#{input['category_id']}/l/latest.json")
          .dig('topic_list', 'topics') || []
      end,

      output_fields: lambda do
        [
          {
            name: 'topics',
            type: 'array',
            of: 'object',
            properties: [
              { name: 'id', label: 'Topic ID', type: 'integer' },
              { name: 'title', label: 'Title' },
              { name: 'slug', label: 'Slug' },
              { name: 'posts_count', label: 'Posts Count', type: 'integer' },
              { name: 'reply_count', label: 'Reply Count', type: 'integer' },
              { name: 'views', label: 'Views', type: 'integer' },
              { name: 'created_at', label: 'Created At', type: 'date_time' },
              { name: 'last_posted_at', label: 'Last Posted At', type: 'date_time' },
              { name: 'closed', label: 'Closed', type: 'boolean' },
              { name: 'archived', label: 'Archived', type: 'boolean' },
              { name: 'category_id', label: 'Category ID', type: 'integer' }
            ]
          }
        ]
      end
    },
    search: {
      title: 'Search',
      subtitle: 'Search topics and posts in Discourse',

      input_fields: lambda do
        [
          {
            name: 'query',
            label: 'Search Query',
            hint: 'Enter keywords to search for',
            optional: false
          }
        ]
      end,

      execute: lambda do |connection, input|
        get("#{connection['base_url']}/search.json")
          .params(q: input['query'])
      end,

      output_fields: lambda do
        [
          {
            name: 'posts',
            label: 'Posts',
            type: 'array',
            of: 'object',
            properties: [
              { name: 'id', label: 'Post ID', type: 'integer' },
              { name: 'topic_id', label: 'Topic ID', type: 'integer' },
              { name: 'blurb', label: 'Excerpt' },
              { name: 'username', label: 'Username' },
              { name: 'created_at', label: 'Created At', type: 'date_time' }
            ]
          },
          {
            name: 'topics',
            label: 'Topics',
            type: 'array',
            of: 'object',
            properties: [
              { name: 'id', label: 'Topic ID', type: 'integer' },
              { name: 'title', label: 'Title' },
              { name: 'slug', label: 'Slug' },
              { name: 'posts_count', label: 'Posts Count', type: 'integer' },
              { name: 'category_id', label: 'Category ID', type: 'integer' },
              { name: 'created_at', label: 'Created At', type: 'date_time' }
            ]
          }
        ]
      end
    },
    get_user: {
      title: 'Get user',
      subtitle: 'Get user profile by username',

      input_fields: lambda do
        [
          {
            name: 'username',
            label: 'Username',
            hint: 'Discourse username e.g. john_doe',
            optional: false
          }
        ]
      end,

      execute: lambda do |connection, input|
        get("#{connection['base_url']}/users/#{input['username']}.json")
          .dig('user')
      end,

      output_fields: lambda do
        [
          { name: 'id', label: 'User ID', type: 'integer' },
          { name: 'username', label: 'Username' },
          { name: 'name', label: 'Full Name' },
          { name: 'email', label: 'Email' },
          { name: 'avatar_template', label: 'Avatar URL' },
          { name: 'trust_level', label: 'Trust Level', type: 'integer' },
          { name: 'post_count', label: 'Post Count', type: 'integer' },
          { name: 'topic_count', label: 'Topic Count', type: 'integer' },
          { name: 'likes_given', label: 'Likes Given', type: 'integer' },
          { name: 'likes_received', label: 'Likes Received', type: 'integer' },
          { name: 'created_at', label: 'Created At', type: 'date_time' },
          { name: 'last_seen_at', label: 'Last Seen At', type: 'date_time' },
          { name: 'website', label: 'Website' },
          { name: 'location', label: 'Location' },
          { name: 'bio_raw', label: 'Bio' }
        ]
      end
    },
  },

  triggers: {
    new_topic: {
      title: 'New topic',
      subtitle: 'Triggers when a new topic is created in Discourse',

      poll: lambda do |connection, input, last_cursor|
        since_id = last_cursor || 0

        topics = get("#{connection['base_url']}/latest.json")
                  .dig('topic_list', 'topics') || []

        new_topics = topics.select { |t| t['id'] > since_id.to_i }

        {
          events: new_topics,
          next_poll: new_topics.first&.dig('id') || last_cursor
        }
      end,

      dedup: lambda do |topic|
        topic['id']
      end,

      output_fields: lambda do
        [
          { name: 'id', label: 'Topic ID', type: 'integer' },
          { name: 'title', label: 'Title' },
          { name: 'slug', label: 'Slug' },
          { name: 'posts_count', label: 'Posts Count', type: 'integer' },
          { name: 'reply_count', label: 'Reply Count', type: 'integer' },
          { name: 'views', label: 'Views', type: 'integer' },
          { name: 'created_at', label: 'Created At', type: 'date_time' },
          { name: 'last_posted_at', label: 'Last Posted At', type: 'date_time' },
          { name: 'category_id', label: 'Category ID', type: 'integer' },
          { name: 'closed', label: 'Closed', type: 'boolean' },
          { name: 'archived', label: 'Archived', type: 'boolean' },
          { name: 'last_poster_username', label: 'Last Poster Username' }
        ]
      end
    },
    new_post: {
      title: 'New post',
      subtitle: 'Triggers when a new post is created in Discourse',

      poll: lambda do |connection, input, last_cursor|
        since_id = last_cursor || 0

        posts = get("#{connection['base_url']}/posts.json")
                  .dig('latest_posts') || []

        new_posts = posts.select { |p| p['id'] > since_id.to_i }

        {
          events: new_posts,
          next_poll: new_posts.first&.dig('id') || last_cursor
        }
      end,

      dedup: lambda do |post|
        post['id']
      end,

      output_fields: lambda do
        [
          { name: 'id', label: 'Post ID', type: 'integer' },
          { name: 'topic_id', label: 'Topic ID', type: 'integer' },
          { name: 'topic_title', label: 'Topic Title' },
          { name: 'username', label: 'Username' },
          { name: 'raw', label: 'Post Content' },
          { name: 'cooked', label: 'Post HTML Content' },
          { name: 'post_number', label: 'Post Number', type: 'integer' },
          { name: 'reply_count', label: 'Reply Count', type: 'integer' },
          { name: 'created_at', label: 'Created At', type: 'date_time' },
          { name: 'updated_at', label: 'Updated At', type: 'date_time' }
        ]
      end
    },
  },
  object_definitions: {},
  pick_lists: {
    categories: lambda do |connection|
      get("#{connection['base_url']}/categories.json")
        .dig('category_list', 'categories')
        .map { |c| [c['name'], c['id']] }
    end
  },
  methods: {}
}