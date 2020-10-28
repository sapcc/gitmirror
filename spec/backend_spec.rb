require "tmpdir"

RSpec.shared_examples "backend" do
  it 'mirrors a remote repository' do
    path = remote_git_repo("test")
    Dir.mktmpdir do |dir|
      Gitmirror.cache_dir = ::File.join dir, 'repo'
      repo = Gitmirror::Repository.new( "file://#{path}")
      repo.mirror()
      workdir = ::File.join dir, 'workdir'
      sha_hash = repo.checkout(workdir)

      expect(sha_hash).to eq("033e3e01379f8b81596c4367fdc91a8d22f47c85") 
      expect(File.exists?(::File.join workdir, "configure" )).to be_truthy
    end
  end

  it 'updates an exiting cached repo' do
    path = remote_git_repo("test")
    Dir.mktmpdir do |dir|
      Gitmirror.cache_dir = ::File.join dir, 'repo'
      repo = Gitmirror::Repository.new( "file://#{path}")
      repo.mirror()
      workdir = ::File.join dir, 'workdir'
      old_hash =  repo.checkout(workdir)
      add_commit "update", "2nd commit", "Another commit", remote: true
      repo.mirror()
      new_hash = repo.checkout(workdir)
      expect(new_hash).to_not eq(old_hash) 
      expect(File.exists?(::File.join workdir, "update" )).to be_truthy
    end
  end

  it 'mirrors a private repo using ssh protocol' do
    skip "Missing TEST_REPO_SSH_URL and TEST_REPO_SSH_KEY" unless ENV['TEST_REPO_SSH_URL'] && ENV['TEST_REPO_SSH_KEY']
    Dir.mktmpdir do |dir|
      Gitmirror.cache_dir = ::File.join dir, 'repo'
      repo = Gitmirror::Repository.new(ENV['TEST_REPO_SSH_URL'])
      repo.mirror(ENV['TEST_REPO_SSH_KEY'])
    end
  end

  it 'mirrors a private repo using https protocol' do
    skip "Missing TEST_REPO_HTTPS_URL and TEST_REPO_HTTPS_PASSWORD" unless ENV['TEST_REPO_HTTPS_URL'] && ENV['TEST_REPO_HTTPS_PASSWORD']
    Dir.mktmpdir do |dir|
      Gitmirror.cache_dir = ::File.join dir, 'repo'
      repo = Gitmirror::Repository.new(ENV['TEST_REPO_HTTPS_URL'])
      repo.mirror(ENV['TEST_REPO_HTTPS_PASSWORD'])
    end
  end

end
