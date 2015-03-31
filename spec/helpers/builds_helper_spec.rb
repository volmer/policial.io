require 'rails_helper'

RSpec.describe BuildsHelper, type: :helper do
  describe 'state_label' do
    it 'is a label containing the build state' do
      build = Build.new(state: 'failure')

      expect(helper.state_label(build)).to eq(
        '<span class="label label-danger">failure</span>'
      )
    end
  end

  describe 'bs_context' do
    it 'returns the Bootstrap context name of the given build state' do
      build = Build.new(state: 'pending')
      expect(helper.bs_context(build)).to eq('warning')

      build = Build.new(state: 'success')
      expect(helper.bs_context(build)).to eq('success')

      build = Build.new(state: 'failure')
      expect(helper.bs_context(build)).to eq('danger')

      build = Build.new(state: 'error')
      expect(helper.bs_context(build)).to eq('default')
    end
  end

  describe 'link_to_line' do
    it 'is a link to the line on GitHub where the given violation was found' do
      violation = Violation.new(
        filename: 'my/file.rb',
        line_number: 42,
        build: Build.new(repo: 'org/project', sha: '123abc')
      )

      expect(helper.link_to_line(violation)).to eq(
        '<a target="_blank" href="https://github.com/org/project/blob/123abc'\
        '/my/file.rb#L42">my/file.rb:42</a>'
      )
    end
  end
end
