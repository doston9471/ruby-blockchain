# Blockchain in Ruby (Sinatra)

Custom Blockchain app in Ruby with Sinatra framework

## System Requirements

- Ruby 3.4.2
- Sinatra

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/doston9471/ruby-blockchain.git
cd ruby-blockchain
```

2. Install dependencies:

```bash
bundle install
```

3. Set Environment Variables

```bash
mv .env.example .env
```

4. Start the server:

```bash
ruby blockchain.rb
```

## Usage

- Go to `http://localhost:4567/`
- Send a `POST` request to `http://localhost:4567/` with a JSON payload with `bpm` as the key and an integer as the value.
For example:
```
{ "bpm":50 }
```

Send as many requests as you like and refresh your browser to see your blocks grow! Use your actual heart rate (Beats Per Minute) to track it over time.

## Development

### Running Tests

```bash
bundle exec rspec
```

### Coverage

```bash
bundle exec rspec --format json --out coverage/coverage.json
```


### Running RuboCop

```bash
bundle exec rubocop
```

## API Endpoints

### GET blockchain
```bash
curl http://localhost:4567/
```

### POST blockchain
```bash
curl -X POST http://localhost:4567/ \
  -H "Content-Type: application/json" \
  -d '{"bpm": 70}'
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.