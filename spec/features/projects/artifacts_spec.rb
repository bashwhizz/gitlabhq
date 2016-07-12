require 'spec_helper'

describe 'Artifacts' do
  let(:artifacts_file) { fixture_file_upload(Rails.root + 'spec/fixtures/banana_sample.gif', 'image/gif') }
  let(:pipeline) { create(:ci_pipeline) }
  let(:build) { create(:ci_build, pipeline: pipeline) }
  let(:build2) { create(:ci_build) }
  let(:project) { pipeline.project }

  before do
    login_as(:user)
    project.team << [@user, :developer]
  end

  describe 'GET /:project/builds/:id/artifacts/download' do
    before do
      build.update_attributes(artifacts_file: artifacts_file)

      visit namespace_project_build_path(project.namespace, project, build)

      click_link 'Download'
    end

    context 'Build from other project' do
      before do
        build2.update_attributes(artifacts_file: artifacts_file)

        visit download_namespace_project_build_artifacts_path(
          project.namespace,
          project,
          build2)
      end

      it { expect(page.status_code).to eq(404) }
    end
  end
end
