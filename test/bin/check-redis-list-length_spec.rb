require_relative '../spec_helper.rb'
require_relative '../../bin/check-redis-list-length.rb'

describe 'RedisListLengthCheck', '#run' do
  before(:all) do
    RedisListLengthCheck.class_variable_set(:@@autorun, nil)
  end

  it 'accepts config' do
    args = %w(--host 127.0.0.1 --password foobar --warning 2 --critical 1 -k key1)
    check = RedisListLengthCheck.new(args)
    expect(check.config[:password]).to eq 'foobar'
  end

  it 'sets socket option accordingly' do
    args = %w(--socket /some/path/redis.sock --warning 2 --critical 1 -k key1)
    check = RedisListLengthCheck.new(args)
    expect(check.config[:socket]).to eq '/some/path/redis.sock'
  end

  it 'returns warning' do
    args = %w(
      --host 1.1.1.1
      --port 1234
      --conn-failure-status warning
      --timeout 0.1
      --warning 2
      --critical 1
      -k key1
    )
    check = RedisListLengthCheck.new(args)
    expect(check).to receive(:warning).with('Could not connect to Redis server on 1.1.1.1:1234').and_raise(SystemExit)
    expect { check.run }.to raise_error(SystemExit)
  end
end
