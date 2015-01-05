# おれん ElastiCache Snapshot

おれん ElastiCache のスナップショットを管理ツールくさ。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticache_snapshot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticache_snapshot

## Usage

### Set AWS Credentials

```bash
cat << EOT > ~/.aws/credentials
[default]
aws_access_key_id = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
region = ap-northeast-1
EOT
```

### Help

```bash
bundle exec bin/elasticache_snapshot
Commands:
  elasticache_snapshot create SNAPSHOT_NAME  # Create Snapshot SNAPSHOT_NAME
  elasticache_snapshot delete SNAPSHOT_NAME  # Dispose Snapshot SNAPSHOT_NAME
  elasticache_snapshot help [COMMAND]        # Describe available commands or one specific command
  elasticache_snapshot list                  # Describe Snapshots
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/elasticache_snapshot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
