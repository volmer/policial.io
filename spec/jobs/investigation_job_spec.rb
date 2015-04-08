require 'rails_helper'

RSpec.describe InvestigationJob, type: :job do
  let(:job) { described_class.new }

  let(:build) do
    Build.create!(
      repo: 'org/proj',
      pull_request: 3,
      user: 'volmer',
      sha: '123abc',
      payload: '{}'
    )
  end
  let!(:repo) { Repository.create!(name: 'org/proj') }

  describe '#perform' do
    context 'the investigation does not return violations' do
      before do
        allow_any_instance_of(
          Policial::Investigation
        ).to receive(:run).and_return([])
      end

      let!(:success_status_request) do
        stub_request(
          :post, 'https://api.github.com/repos/org/proj/statuses/123abc'
        ).with(body: hash_including(
          description: 'No code style violations were found.', state: 'success'
        ))
      end

      it 'sets the build state to success' do
        job.perform(build)

        expect(build.reload).to be_success
      end

      it 'sends the status to GitHub' do
        job.perform(build)

        expect(success_status_request).to have_been_requested
      end
    end

    context 'the investigation returns violations' do
      before do
        violations = [
          double(
            filename: 'my/file.rb',
            line_number: 42,
            messages: ['single quotes, please', 'wrong indentation']
          ),
          double(
            filename: 'app/extra.rb',
            line_number: 123,
            messages: ['remove space']
          )
        ]

        allow_any_instance_of(
          Policial::Investigation
        ).to receive(:run).and_return(violations)
      end

      let!(:failure_status_request) do
        stub_request(
          :post, 'https://api.github.com/repos/org/proj/statuses/123abc'
        ).with(body: hash_including(
          description: 'Code style violations found!', state: 'failure'
        ))
      end

      it 'sets the build state to failure' do
        job.perform(build)

        expect(build.reload).to be_failure
      end

      it 'populates the build with violations' do
        job.perform(build)
        build.reload

        expect(build.violations.count).to eq(3)

        expect(build.violations.first.filename).to eq('my/file.rb')
        expect(build.violations.first.line_number).to eq(42)
        expect(build.violations.first.message).to eq('single quotes, please')

        expect(build.violations.second.filename).to eq('my/file.rb')
        expect(build.violations.second.line_number).to eq(42)
        expect(build.violations.second.message).to eq('wrong indentation')

        expect(build.violations.third.filename).to eq('app/extra.rb')
        expect(build.violations.third.line_number).to eq(123)
        expect(build.violations.third.message).to eq('remove space')
      end

      it 'sends the status to GitHub' do
        job.perform(build)

        expect(failure_status_request).to have_been_requested
      end
    end

    context 'an error happens during the investigation' do
      before { expect(JSON).to receive(:parse).and_raise('Busted!') }

      let!(:error_status_request) do
        stub_request(
          :post, 'https://api.github.com/repos/org/proj/statuses/123abc'
        ).with(body: hash_including(
          description: 'Policial could not complete the investigation.',
          state: 'error'
        ))
      end

      it 'raises the error' do
        expect { job.perform(build) }.to raise_error('Busted!')
      end

      it 'sets the build state to error' do
        expect { job.perform(build) }.to raise_error

        expect(build.reload).to be_error
      end

      it 'sends the status to GitHub' do
        expect { job.perform(build) }.to raise_error

        expect(error_status_request).to have_been_requested
      end
    end
  end
end
