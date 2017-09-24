# frozen_string_literal: true

describe "Application generation" do
  let(:status) { Bundler.clean_system(env, command, out: File::NULL) }

  let(:env) do
    { "RUBYOPT" => "-E UTF-8" }
  end

  after { FileUtils.rm_rf("tmp/test_app") }

  shared_examples_for "a sane generator" do
    it "successfully generates application" do
      expect(status).to eq(true)
    end
  end

  context "without flags" do
    let(:command) { "bin/decidim tmp/test_app" }

    it_behaves_like "a sane generator"

    context "and non utf-8 encoding" do
      let(:env) do
        { "RUBYOPT" => "-E ASCII" }
      end

      it_behaves_like "a sane generator"
    end
  end

  context "with --edge flag" do
    let(:command) { "bin/decidim --edge tmp/test_app" }

    it_behaves_like "a sane generator"
  end

  context "with --branch flag" do
    let(:command) { "bin/decidim --branch master tmp/test_app" }

    it_behaves_like "a sane generator"
  end

  context "with --path flag" do
    let(:command) { "bin/decidim --path #{File.expand_path("..", __dir__)} tmp/test_app" }

    it_behaves_like "a sane generator"
  end

  context "development application" do
    let(:command) { "bundle exec rake development_app" }

    it_behaves_like "a sane generator"
  end
end
