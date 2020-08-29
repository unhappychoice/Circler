# frozen_string_literal: true

require 'spec_helper'

describe CircleCI::CLI::Command::BaseCommand do
  describe '.reponame' do
    subject { described_class.reponame }

    context 'when git repository has a github remote' do
      let(:rugged_response_remote_url) { 'git@github.com:user/repository.git' }
      it 'extracts the reponame from the origin url' do
        expect(subject).to eq('user/repository')
      end
    end

    context 'when git repository has a github remote that contains a dot' do
      let(:rugged_response_remote_url) { 'git@github.com:user/example.com.git' }
      it 'extracts the reponame from the origin url, including the dot' do
        expect(subject).to eq('user/example.com')
      end
    end

    context 'when git repository has a non-github remote' do
      let(:rugged_response_remote_url) { 'git@bitbucket.org:user/repository.git' }
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.branch_name' do
    subject { described_class.branch_name(options) }
    let(:options) { OpenStruct.new }

    context 'with all option' do
      let(:options) { OpenStruct.new(all: true) }
      let(:rugged_response_branch_name) { 'branch' }
      let(:rugged_response_is_branch) { true }

      it { is_expected.to eq(nil) }
    end

    context 'with branch option' do
      let(:options) { OpenStruct.new(branch: 'optionBranch') }
      let(:rugged_response_branch_name) { 'branch' }
      let(:rugged_response_is_branch) { true }

      it { is_expected.to eq('optionBranch') }
    end

    context 'with a valid current branch' do
      let(:rugged_response_branch_name) { 'branch' }
      let(:rugged_response_is_branch) { true }

      it { is_expected.to eq(rugged_response_branch_name) }
    end

    context 'with no current branch' do
      let(:rugged_response_branch_name) { nil }
      let(:rugged_response_is_branch) { false }

      it { is_expected.to be_nil }
    end
  end
end
